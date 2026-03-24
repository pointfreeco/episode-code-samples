import Foundation
import os
import Synchronization

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
      $0.values.reduce(into: 0) { $0 += $1.state.withLock(\.balance) }
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

  final class Account: Identifiable, Sendable {
    let id: UUID
    let state: Mutex<State>
    struct State {
      var balance: Int
      var balanceHistory: [Int] = []
    }
    init(id: UUID, balance: Int = 0) {
      self.id = id
      state = Mutex(State(balance: balance))
    }
    func deposit(_ amount: Int) {
      state.withLock {
        $0.balanceHistory.append($0.balance)
        $0.balance += amount
      }
    }
    func withdraw(_ amount: Int) throws {
      try state.withLock {
        guard $0.balance >= amount
        else {
          struct InsufficientFunds: Error {}
          throw InsufficientFunds()
        }
        $0.balance -= amount
      }
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
