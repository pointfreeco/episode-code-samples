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

  @Test func transaction() async throws {
    let bank = Bank()
    let otherBank = Bank()
    try await bank.run { bank in
      let id1 = bank.openAccount(initialDeposit: 100)
      let id2 = bank.openAccount(initialDeposit: 100)
      let id3 = otherBank.openAccount(initialDeposit: 100)
      try bank.transfer(amount: 50, from: id1, to: id2)
      #expect(bank.totalDeposits == 200)
      #expect(try bank.account(for: id1).balance == 50)
      #expect(try bank.account(for: id2).balance == 150)
    }
  }

  @Test func nonAtomicProblem() async throws {
    let bank = Bank()
    let id1 = await bank.openAccount(initialDeposit: 100)
    let id2 = await bank.openAccount(initialDeposit: 100)
    let transfer = Task {
      try await bank.run { bank in
        let startingDeposits = bank.totalDeposits
        try bank.transfer(amount: 50, from: id1, to: id2)
        _ = { Thread.sleep(forTimeInterval: 1) }()
        #expect(bank.totalDeposits == startingDeposits)
        try #expect(bank.account(for: id1) { $0.balance } == 50)
        #expect(try bank.account(for: id2) { $0.balance } == 150)
      }
    }
    let withdraw = Task {
      try await Task.sleep(for: .seconds(0.5))
      try await bank.account(for: id1) {
        try $0.withdraw(50)
      }
    }
    _ = try await (withdraw.value, transfer.value)
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
