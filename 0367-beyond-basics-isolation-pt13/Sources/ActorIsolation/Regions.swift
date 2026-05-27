import Foundation

extension Bank {
  func transfer(account: Bank.Account) {
    accounts[account.id] = account
  }
}

@MainActor func log(account: Bank.Account) {}

func linkAccounts(
  _ lhs: Bank.Account,
  _ rhs: sending Bank.Account
) async -> sending Bank.Account {
  // [{(lhs), Task}, (rhs)]
  // Task { rhs.balance += 1 }
  // [{(lhs), Task}, (rhs)]
  return rhs
}

func specialActorBehavior() {
  let account = Bank.Account(id: UUID())
  // [(account)]
  let bank = Bank(account: account)
  _ = bank
  // [{(account), bank}]
//  account.balance += 1
}

func sendingLinkAccounts(account: sending Bank.Account) async {
  // [(account)]
  let account1 = Bank.Account(id: UUID())
  let account2 = Bank.Account(id: UUID())
  // [(account), (account1), (account2)]
  _ = await linkAccounts(account1, account)
  // [{(account, linkAccounts}, (account1), (account2)]
  account2.balance += 1
}

func accessBankAccount() async throws {
  let bank = Bank()
  let id = await bank.openAccount()
  let account = try await bank.close(accountID: id)
  // [(account)]
}

extension Bank {
  func close(accountID: Account.ID) throws -> sending Account {
    nonisolated(unsafe) let account = try account(for: accountID)
    // [(account)]
    accounts[accountID] = nil
    // [(account)]
    return account
  }
}

func bankLinkAccounts() async {
  let account1 = Bank.Account(id: UUID())
  let account2 = Bank.Account(id: UUID())
  // [(account1), (account2)]
  let account3 = await linkAccounts(account1, account2)
  // [(account1), {(account2), Task}, (account3)]
  //account2.balance += 1
  account1.balance += 1
  Task { account1.balance += 1 }
  account3.balance += 1
  Task { account3.balance += 1 }
}

func transferBetweenBanks() async throws {
  let chase = Bank()
  let boa = Bank()
  // [{(), chase}, {(), boa}]
  let account = Bank.Account(id: UUID())
  // [{(), chase}, {(), boa}, (account)]
  await chase.transfer(account: account)
  // [{(account), chase}, {(), boa}]
  let closedAccount = try await chase.close(accountID: account.id)
  // [{(), chase}, {(), boa}, (closedAccount)]
  await boa.transfer(account: closedAccount)
  // [{(), chase}, {(closedAccount), boa})]
}
