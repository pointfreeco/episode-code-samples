import Foundation
import MacroKit

// Basic
@GenerateMock
protocol DependencyA {
    var name: String { get }

    func updateName() async throws
}

// Inheritance
@GenerateMock
protocol DependencyB: DependencyA {
    var name: String { get }

    func updateName() async throws
}

// Associated Types
@GenerateMock
protocol DependencyC {
    associatedtype Input: DataProtocol
    associatedtype Output: Codable

    func convert(_ input: Input) async throws -> Output
}
