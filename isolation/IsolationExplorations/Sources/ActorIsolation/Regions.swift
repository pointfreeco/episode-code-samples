import Foundation

extension Bank {
  func transfer(account: Bank.Account) {
    accounts[account.id] = account
  }
}

@MainActor func log(account: Bank.Account) {}

func linkAccounts(_ lhs: Bank.Account, _ rhs: sending Bank.Account) async -> Bank.Account {
  // [{(lhs), Task}, (rhs)]
  Task { rhs.balance += 1 }
  // [{(lhs), Task}, {(rhs), Task2}]
  return lhs
}

func specialActorBehavior() {
  let account = Bank.Account(id: UUID())
  // [(account)]
  let bank = Bank(account: account)
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
