@attached(peer, names: suffixed(Mock))
public macro GenerateMock() = #externalMacro(module: "MacroKitMacros", type: "GenerateMockMacro")

public struct MockMember<Input, Output> {
    public var output: Output!
    public var inputs: [Input] = []
    public var outputs: [Output] = []

    public var wasCalled: Bool { !outputs.isEmpty }

    public init() { }

    public mutating func execute(_ input: Input) -> Output {
        inputs.append(input)
        outputs.append(output)
        return output
    }
    public mutating func execute<Success, Failure: Error>(_ input: Input) throws -> Success where Output == Result<Success, Failure> {
        inputs.append(input)
        outputs.append(output)
        return try output.get()
    }

    public mutating func getter() -> Output {
        outputs.append(output)
        return output
    }
    public mutating func getter<Success, Failure: Error>() throws -> Success where Output == Result<Success, Failure> {
        outputs.append(output)
        return try output.get()
    }
    public mutating func setter(_ input: Input) where Input == Output {
        inputs.append(input)
        output = input
    }
}
