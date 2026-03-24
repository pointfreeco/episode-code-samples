import Testing

@testable import LegacyIsolation

@Suite struct BankTests {
  @Test func basics() throws {
    let bank = Bank()
    let id1 = bank.openAccount(initialDeposit: 100)
    let id2 = bank.openAccount(initialDeposit: 100)
    try bank.transfer(amount: 50, from: id1, to: id2)
    #expect(bank.totalDeposits == 200)
    #expect(try bank.account(for: id1) { $0.state.withLock(\.balance) } == 50)
    #expect(try bank.account(for: id2) { $0.state.withLock(\.balance) } == 150)
  }

  @Test func newAccountRush() async {
    let bank = Bank()
    await withTaskGroup { group in
      for _ in 1...1000 {
        group.addTask {
          bank.openAccount(initialDeposit: 100)
        }
      }
    }
    #expect(bank.totalDeposits == 100 * 1000)
  }

  @Test func busyDepositDay() async throws {
    let bank = Bank()
    let id = bank.openAccount(initialDeposit: 0)
    await withThrowingTaskGroup { group in
      for _ in 1...1000 {
        group.addTask {
          try bank.account(for: id) { account in
            account.deposit(100)
          }
        }
      }
    }
    #expect(bank.totalDeposits == 100 * 1000)
  }
}
