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

func linkAccounts(_ lhs: Bank.Account, _ rhs: Bank.Account) -> Bank.Account {
  // lhs.referrer = rhs
  lhs
}

func functionMerging() async throws {
  // Regions: []
  let account1 = Bank.Account(id: UUID())
  // [(account1)]
  let account2 = Bank.Account(id: UUID())
  // [(account1), (account2)]
  let result = linkAccounts(account1, account2)
  // [(account1, account2, result)]
  Task {
    account1.balance += 1
  }
  // [{(account1, account2, result), Task}]
//  result.balance += 1
}

func alias() {
  let account = Bank.Account(id: UUID())
  // [(account)]
  let otherAccount = account
  // [(account, otherAccount)]
}


class SomeNonSendable {
  func operate(account: Bank.Account) {}
}

func nonSendable() {
  let account = Bank.Account(id: UUID())
  // [(account)]
  let nonSendable = SomeNonSendable()
  // [(account), (nonSendable)]
  nonSendable.operate(account: account)
  // [(account, nonSendable)]
}

func closureMerging() {
  let account1 = Bank.Account(id: UUID())
  // [(account1)]
  let account2 = Bank.Account(id: UUID())
  // [(account1), (account2)]

  let f = {
    account1.balance += 1
    account2.balance += 1
  }
  // [(account1, account2, f)]
  Task {
    f()
  }
  // [{(account1, account2, f), Task}]
//  account1.balance += 1
}

func controlFlow() {
  let account1 = Bank.Account(id: UUID())
  // [(account1)]
  let account2 = Bank.Account(id: UUID())
  // [(account1), (account2)]
  if Bool.random() {
    _ = linkAccounts(account1, account2)
    // [(account1, account2)]
  }
  // [(account1, account2)]
//  Task { account1.balance += 1 }
//  Task { account2.balance += 1 }
}

func invalidRegions() async {
  let chase = Bank()
  let boa = Bank()
  let account = Bank.Account(id: UUID())
  // [{(), chase}, {(), boa}, (account)]

  switch Bool.random() {
  case true:
    await chase.transfer(account: account)
    // [{(account), chase}, {(), boa}]
  case false:
    await boa.transfer(account: account)
    // [{(), chase}, {(account), boa}]
  }

  // [{(), chase}, {(), boa}, {(account), invalid}]
  account.balance += 1
}

func guardRegions() async {
  let chase = Bank()
  let boa = Bank()
  let account = Bank.Account(id: UUID())
  // [{(), chase}, {(), boa}, (account)]

  guard Bool.random()
  else {
    await boa.transfer(account: account)
    // [{(), chase}, {(account), boa}]
    return
  }

  await chase.transfer(account: account)
  // [{(account), chase}, {(), boa}]
//  account.balance += 1
}

func loopRegions() async {
  let bank = Bank()
  let account = Bank.Account(id: UUID())
  while true {
    await bank.transfer(account: account)
  }
}
