import Foundation

nonisolated(nonsending) func operation() async {}

final class LoggingExecutor: SerialExecutor {
  private let queue = DispatchSerialQueue(label: "co.pointfree.logging-executor")
  func enqueue(_ job: consuming ExecutorJob) {
    print("-> Job enqueued: \(job.description) @ priority \(job.priority.rawValue)")
    let unownedJob = UnownedJob(job)
    queue.async {
      unownedJob.runSynchronously(on: self.asUnownedSerialExecutor())
    }
  }
}

func accessExecutor(bank: Bank) /* async */ {
  _ = bank.unownedExecutor
}
//@MainActor
//func check(bank: Bank) async {
//  bank.asyncMethod()
//  let erased = bank as any MyProtocol
//  erased.syncMethod()
//  await erased.asyncMethod()
//}

protocol MyProtocol {
  func syncMethod()
  func asyncMethod() async
}

actor Bank {
  func syncMethod() {
    print(accounts)
  }
  func asyncMethod() {
    print(accounts)
  }
  var accounts: [Account.ID: Account] = [:]
  let routingNumber: String
  init(routingNumber: String = "1212121212") {
    self.routingNumber = routingNumber
  }

  let executor = LoggingExecutor()
  nonisolated var unownedExecutor: UnownedSerialExecutor {
    executor.asUnownedSerialExecutor()
  }

  func transfer(
    amount: Int,
    from fromID: Account.ID,
    to toID: Account.ID
  ) throws {
    printFunction()
    try account(for: fromID) { try $0.withdraw(amount) }
    try account(for: toID) { $0.deposit(amount) }
  }

  func checkedTransfer(
    amount: Int,
    from fromID: Account.ID,
    to toID: Account.ID
  ) async throws {
    printFunction()
    let fromAccount = try account(for: fromID)
    let toAccount = try account(for: toID)
    try fromAccount.withdraw(amount)
    try await Task.sleep(for: .seconds(1))  // Fraud check
    toAccount.deposit(amount)
  }

  func openAccount(initialDeposit: Int = 0) -> Account.ID {
    printFunction()
    let id = UUID()
    accounts[id] = Account(id: id, balance: initialDeposit)
    return id
  }

  var totalDeposits: Int {
    printFunction()
    var sum = 0
    for account in accounts.values {
      sum += account.balance
    }
    return sum
  }

  func account(for id: Account.ID) throws -> Account {
    printFunction()
    guard let account = accounts[id] else {
      struct AccountNotFound: Error {}
      throw AccountNotFound()
    }
    return account
  }

  func account<R: Sendable>(for id: Account.ID, body: @Sendable (Account) throws -> R) throws -> R {
    printFunction()
    return try body(account(for: id))
  }

  final class Account: Identifiable {
    let id: UUID
    var balance: Int
    var balanceHistory: [Int] = []
    init(
      id: UUID,
      balance: Int = 0
    ) {
      self.id = id
      self.balance = balance
    }
    nonisolated func deposit(_ amount: Int) {
      balanceHistory.append(balance)
      balance += amount
    }
    nonisolated func withdraw(_ amount: Int) throws {
      guard balance >= amount
      else {
        struct InsufficientFunds: Error {}
        throw InsufficientFunds()
      }
      balance -= amount
    }
    nonisolated(nonsending)
    private func prepareHistory() async throws -> Data {
      Data()
    }
    nonisolated(nonsending)
    private func writeHistory(data: Data) async throws -> URL {
      .temporaryDirectory
    }
    nonisolated(nonsending)
    func exportHistory() async throws -> URL {
      let data = try await prepareHistory()
      return try await writeHistory(data: data)
    }
  }

  func export() async throws -> URL {
    printIsolation()
    for account in accounts.values {
      _ = try await account.exportHistory()
    }
    return .temporaryDirectory
  }
}

private func printIsolation(
  function: StaticString = #function,
  isolation: (any Actor)? = #isolation
) {
  print(
    function,
    "\(isolation as (any Actor)?, default: "nonisolated")",
    "\((isolation as (any Actor)?).map(ObjectIdentifier.init), default: "nonisolated")",
  )
}

private func printFunction(_ f: StaticString = #function) {
  print(f)
}

