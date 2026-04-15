import Foundation

actor Bank {
  private var accounts: [Account.ID: Account] = [:]

  func transfer(
    amount: Int,
    from fromID: Account.ID,
    to toID: Account.ID
  ) throws {
    let fromAccount = try account(for: fromID)
    let toAccount = try account(for: toID)
    try fromAccount.withdraw(amount)
    toAccount.deposit(amount)
  }

  func openAccount(initialDeposit: Int = 0) -> Account.ID {
    let id = UUID()
    accounts[id] = Account(id: id, balance: initialDeposit)
    return id
  }

  var totalDeposits: Int {
    accounts.values.reduce(into: 0) { $0 += $1.balance }
  }

  func account(for id: Account.ID) throws -> Account {
    guard let account = accounts[id] else {
      struct AccountNotFound: Error {}
      throw AccountNotFound()
    }
    return account
  }
  func totallyFine() throws {
    let account = try account(for: UUID())
    print(account.balance)
  }
  func take(account: Bank.Account) {
    accounts[account.id] = account
  }
  func operate() {
    let account = Bank.Account(id: UUID())
    take(account: account)
    print(account.balance)
  }


  func account<R: Sendable>(for id: Account.ID, body: @Sendable (Account) -> R) throws -> R{
    try body(account(for: id))
  }

  final class Account: Identifiable {
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
