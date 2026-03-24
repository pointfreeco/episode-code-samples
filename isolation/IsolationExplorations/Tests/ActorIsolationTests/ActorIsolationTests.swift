import Foundation
import Testing

@testable import ActorIsolation

@Suite struct BankTests {
  @Test func basics() async throws {
    let bank = Bank()
    let id1 = await bank.openAccount(initialDeposit: 100)
    let id2 = await bank.openAccount(initialDeposit: 100)
    try await bank.transfer(amount: 50, from: id1, to: id2)
    #expect(await bank.totalDeposits == 200)
    #expect(try await bank.account(for: id1) { $0.balance } == 50)
    #expect(try await bank.account(for: id2) { $0.balance } == 150)
  }

  @Test func newAccountRush() async {
    let bank = Bank()
    await withTaskGroup { group in
      for _ in 1...1000 {
        group.addTask {
          await bank.openAccount(initialDeposit: 100)
        }
      }
    }
    #expect(await bank.totalDeposits == 100 * 1000)
  }

  @Test func busyDepositDay() async throws {
    let bank = Bank()
    let id = await bank.openAccount(initialDeposit: 0)
    await withThrowingTaskGroup { group in
      for _ in 1...1000 {
        group.addTask {
          try await bank.account(for: id) { account in
            account.deposit(100)
          }
        }
      }
    }
    #expect(await bank.totalDeposits == 100 * 1000)
  }
}
