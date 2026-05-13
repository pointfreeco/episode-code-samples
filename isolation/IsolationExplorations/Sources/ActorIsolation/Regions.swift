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
  Task {
    account.balance += 10
  }
}
