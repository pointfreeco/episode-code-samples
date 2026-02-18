import Foundation
import os

final class Bank: Sendable {
  private let accounts = OSAllocatedUnfairLock<[Account.ID: Account]>(checkedState: [:])

  func transfer(
    amount: Int,
    from fromID: Account.ID,
    to toID: Account.ID
  ) throws {
    let fromAccount = try account(for: fromID)
    let toAccount = try account(for: toID)
    try lock.withLock {
      try fromAccount.withdraw(amount)
      toAccount.deposit(amount)
    }
  }

  func openAccount(initialDeposit: Int = 0) -> Account.ID {
    lock.withLock {
      let id = UUID()
      accounts[id] = Account(id: id, balance: initialDeposit)
      return id
    }
  }

  var totalDeposits: Int {
    lock.withLock {
      accounts.values.reduce(into: 0) { $0 += $1.balance }
    }
  }

  func account(for id: Account.ID) throws -> Account {
    try lock.withLock {
      guard let account = accounts[id]
      else {
        struct AccountNotFound: Error {}
        throw AccountNotFound()
      }
      return account
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
    self.init(uncheckedState: checkedStated())
  }
}
