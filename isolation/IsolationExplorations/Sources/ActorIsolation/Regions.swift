import Foundation

func regions() {
  // Regions: []
  let account1 = Bank.Account(id: UUID())
  // Regions: [(account1)]
  let account2 = Bank.Account(id: UUID())
  // Regions: [(account1), (account2)]
  Task {
    account1.balance += 10
  }
  // Regions: [{(account1), Task1}, (account2)]
  Task {
    account2.balance += 10
  }
  // Regions: [{(account1), Task1}, {(account2), Task2}]
}

func regions2(account: Bank.Account) async {
  // Regions: [{(account), Task}]
//  Task {
//    account.balance += 10
//  }
}

extension Bank {
  func transfer(account: Bank.Account) {
    accounts[account.id] = account
  }
}

func actorRegions() async {
  // Regions: []
  let chase = Bank()
  let boa = Bank()
  // [{(), chase}, {(), boa}]
  let account = Bank.Account(id: UUID())
  // [{(), chase}, {(), boa}, (account)]
  await chase.transfer(account: account)
  // [{(account), chase}, {(), boa}]
//  Task {
//    account.balance += 1
//  }
}
@MainActor
func globalActorRegions() async {
  let account = Bank.Account(id: UUID())
  // Regions: [{(account), @MainActor}]
  log(account: account)
  // Regions: [{(account), @MainActor}]
  log(account: account)
}
@MainActor func log(account: Bank.Account) {}
