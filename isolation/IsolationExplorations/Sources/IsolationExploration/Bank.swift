import Foundation
import os
import Synchronization

func exploration() {
  class NS {
    var count = 0
    init(count: Int = 0) {
      self.count = count
    }
  }
  let state = NS()
  let ns = Mutex(state)
//  _ = state.count
  var next: NS!
  ns.withLock {
    next = $0
    $0 = NS()
  }
//  var count = 0
//  Task {
//    count += 1
//  }
//  count = 1
  Task {
    let escaped = ns.withLock { $0 }
    print(escaped.count)
  }
  let escaped = ns.withLock { $0 }
  print(escaped.count)
}

final class Bank: Sendable {
  private let accounts = Mutex<[Account.ID: Account]>([:])

  func transfer(
    amount: Int,
    from fromID: Account.ID,
    to toID: Account.ID
  ) throws {
    try accounts.withLock {
      let fromAccount = try $0.account(for: fromID)
      let toAccount = try $0.account(for: toID)
      try fromAccount.withdraw(amount)
      toAccount.deposit(amount)
    }
  }

  func openAccount(initialDeposit: Int = 0) -> Account.ID {
    accounts.withLock {
      let id = UUID()
      $0[id] = Account(id: id, balance: initialDeposit)
      return id
    }
  }

  var totalDeposits: Int {
    accounts.withLock {
      $0.values.reduce(into: 0) { $0 += $1.balance }
    }
  }

  func account(for id: Account.ID) throws -> Account {
    try accounts.withLock {
      guard let account = $0[id] else {
        struct AccountNotFound: Error {}
        throw AccountNotFound()
      }
      return account
    }
  }
  
  func account<R: Sendable>(for id: Account.ID, body: @Sendable (Account) -> R) throws -> R{
    try accounts.withLock {
      try body($0.account(for: id))
    }
  }

  class Account: Identifiable {
    let id: UUID
    var balance: Int
    var balanceHistory: [Int] = []
    init(id: UUID, balance: Int = 0) {
      self.id = id
      self.balance = balance
    }
    func deposit(_ amount: Int) {
      balanceHistory.append(balance)
      balance += amount
    }
    func withdraw(_ amount: Int) throws {
      guard balance >= amount
      else {
        struct InsufficientFunds: Error {}
        throw InsufficientFunds()
      }
      balance -= amount
    }
  }
}

extension OSAllocatedUnfairLock {
  init(checkedState: @Sendable @autoclosure () -> State) {
    self.init(uncheckedState: checkedState())
  }
}

extension [Bank.Account.ID: Bank.Account] {
  struct AccountNotFound: Error {}
  func account(for id: Key) throws -> Value {
    guard let value = self[id]
    else {
      throw AccountNotFound()
    }
    return value
  }
}
