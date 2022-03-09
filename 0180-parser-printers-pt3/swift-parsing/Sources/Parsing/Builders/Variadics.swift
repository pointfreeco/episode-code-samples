// BEGIN AUTO-GENERATED CONTENT

extension Parsers {
  public struct ZipOO<P0: Parser, P1: Parser>: Parser
  where
    P0.Input == P1.Input
  {
    public let p0: P0, p1: P1

    @inlinable public init(_ p0: P0, _ p1: P1) {
      self.p0 = p0
      self.p1 = p1
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        return (o0, o1)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1>(
    _ p0: P0, _ p1: P1
  ) -> Parsers.ZipOO<P0, P1> {
    Parsers.ZipOO(p0, p1)
  }
}

extension Parsers {
  public struct ZipOV<P0: Parser, P1: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Output == Void
  {
    public let p0: P0, p1: P1

    @inlinable public init(_ p0: P0, _ p1: P1) {
      self.p0 = p0
      self.p1 = p1
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P0.Output {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        return o0
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1>(
    _ p0: P0, _ p1: P1
  ) -> Parsers.ZipOV<P0, P1> {
    Parsers.ZipOV(p0, p1)
  }
}

extension Parsers {
  public struct ZipVO<P0: Parser, P1: Parser>: Parser
  where
    P0.Input == P1.Input,
    P0.Output == Void
  {
    public let p0: P0, p1: P1

    @inlinable public init(_ p0: P0, _ p1: P1) {
      self.p0 = p0
      self.p1 = p1
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P1.Output {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        return o1
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1>(
    _ p0: P0, _ p1: P1
  ) -> Parsers.ZipVO<P0, P1> {
    Parsers.ZipVO(p0, p1)
  }
}

extension Parsers {
  public struct ZipVV<P0: Parser, P1: Parser>: Parser
  where
    P0.Input == P1.Input,
    P0.Output == Void,
    P1.Output == Void
  {
    public let p0: P0, p1: P1

    @inlinable public init(_ p0: P0, _ p1: P1) {
      self.p0 = p0
      self.p1 = p1
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1>(
    _ p0: P0, _ p1: P1
  ) -> Parsers.ZipVV<P0, P1> {
    Parsers.ZipVV(p0, p1)
  }
}

extension Parsers {
  public struct ZipOOO<P0: Parser, P1: Parser, P2: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input
  {
    public let p0: P0, p1: P1, p2: P2

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P2.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        return (o0, o1, o2)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2>(
    _ p0: P0, _ p1: P1, _ p2: P2
  ) -> Parsers.ZipOOO<P0, P1, P2> {
    Parsers.ZipOOO(p0, p1, p2)
  }
}

extension Parsers {
  public struct ZipOOV<P0: Parser, P1: Parser, P2: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        return (o0, o1)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2>(
    _ p0: P0, _ p1: P1, _ p2: P2
  ) -> Parsers.ZipOOV<P0, P1, P2> {
    Parsers.ZipOOV(p0, p1, p2)
  }
}

extension Parsers {
  public struct ZipOVO<P0: Parser, P1: Parser, P2: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P1.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P2.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        return (o0, o2)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2>(
    _ p0: P0, _ p1: P1, _ p2: P2
  ) -> Parsers.ZipOVO<P0, P1, P2> {
    Parsers.ZipOVO(p0, p1, p2)
  }
}

extension Parsers {
  public struct ZipOVV<P0: Parser, P1: Parser, P2: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P1.Output == Void,
    P2.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P0.Output {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        return o0
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2>(
    _ p0: P0, _ p1: P1, _ p2: P2
  ) -> Parsers.ZipOVV<P0, P1, P2> {
    Parsers.ZipOVV(p0, p1, p2)
  }
}

extension Parsers {
  public struct ZipVOO<P0: Parser, P1: Parser, P2: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P0.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P2.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        return (o1, o2)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2>(
    _ p0: P0, _ p1: P1, _ p2: P2
  ) -> Parsers.ZipVOO<P0, P1, P2> {
    Parsers.ZipVOO(p0, p1, p2)
  }
}

extension Parsers {
  public struct ZipVOV<P0: Parser, P1: Parser, P2: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P0.Output == Void,
    P2.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P1.Output {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        return o1
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2>(
    _ p0: P0, _ p1: P1, _ p2: P2
  ) -> Parsers.ZipVOV<P0, P1, P2> {
    Parsers.ZipVOV(p0, p1, p2)
  }
}

extension Parsers {
  public struct ZipVVO<P0: Parser, P1: Parser, P2: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P0.Output == Void,
    P1.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P2.Output {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        return o2
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2>(
    _ p0: P0, _ p1: P1, _ p2: P2
  ) -> Parsers.ZipVVO<P0, P1, P2> {
    Parsers.ZipVVO(p0, p1, p2)
  }
}

extension Parsers {
  public struct ZipVVV<P0: Parser, P1: Parser, P2: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P0.Output == Void,
    P1.Output == Void,
    P2.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2>(
    _ p0: P0, _ p1: P1, _ p2: P2
  ) -> Parsers.ZipVVV<P0, P1, P2> {
    Parsers.ZipVVV(p0, p1, p2)
  }
}

extension Parsers {
  public struct ZipOOOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P2.Output,
      P3.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        return (o0, o1, o2, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3
  ) -> Parsers.ZipOOOO<P0, P1, P2, P3> {
    Parsers.ZipOOOO(p0, p1, p2, p3)
  }
}

extension Parsers {
  public struct ZipOOOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P2.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        return (o0, o1, o2)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3
  ) -> Parsers.ZipOOOV<P0, P1, P2, P3> {
    Parsers.ZipOOOV(p0, p1, p2, p3)
  }
}

extension Parsers {
  public struct ZipOOVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P2.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P3.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        return (o0, o1, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3
  ) -> Parsers.ZipOOVO<P0, P1, P2, P3> {
    Parsers.ZipOOVO(p0, p1, p2, p3)
  }
}

extension Parsers {
  public struct ZipOOVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P2.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        return (o0, o1)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3
  ) -> Parsers.ZipOOVV<P0, P1, P2, P3> {
    Parsers.ZipOOVV(p0, p1, p2, p3)
  }
}

extension Parsers {
  public struct ZipOVOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P1.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P2.Output,
      P3.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        return (o0, o2, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3
  ) -> Parsers.ZipOVOO<P0, P1, P2, P3> {
    Parsers.ZipOVOO(p0, p1, p2, p3)
  }
}

extension Parsers {
  public struct ZipOVOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P1.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P2.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        return (o0, o2)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3
  ) -> Parsers.ZipOVOV<P0, P1, P2, P3> {
    Parsers.ZipOVOV(p0, p1, p2, p3)
  }
}

extension Parsers {
  public struct ZipOVVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P1.Output == Void,
    P2.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P3.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        return (o0, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3
  ) -> Parsers.ZipOVVO<P0, P1, P2, P3> {
    Parsers.ZipOVVO(p0, p1, p2, p3)
  }
}

extension Parsers {
  public struct ZipOVVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P1.Output == Void,
    P2.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P0.Output {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        return o0
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3
  ) -> Parsers.ZipOVVV<P0, P1, P2, P3> {
    Parsers.ZipOVVV(p0, p1, p2, p3)
  }
}

extension Parsers {
  public struct ZipVOOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P0.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P2.Output,
      P3.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        return (o1, o2, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3
  ) -> Parsers.ZipVOOO<P0, P1, P2, P3> {
    Parsers.ZipVOOO(p0, p1, p2, p3)
  }
}

extension Parsers {
  public struct ZipVOOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P0.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P2.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        return (o1, o2)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3
  ) -> Parsers.ZipVOOV<P0, P1, P2, P3> {
    Parsers.ZipVOOV(p0, p1, p2, p3)
  }
}

extension Parsers {
  public struct ZipVOVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P0.Output == Void,
    P2.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P3.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        return (o1, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3
  ) -> Parsers.ZipVOVO<P0, P1, P2, P3> {
    Parsers.ZipVOVO(p0, p1, p2, p3)
  }
}

extension Parsers {
  public struct ZipVOVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P0.Output == Void,
    P2.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P1.Output {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        return o1
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3
  ) -> Parsers.ZipVOVV<P0, P1, P2, P3> {
    Parsers.ZipVOVV(p0, p1, p2, p3)
  }
}

extension Parsers {
  public struct ZipVVOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P0.Output == Void,
    P1.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P2.Output,
      P3.Output
    ) {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        return (o2, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3
  ) -> Parsers.ZipVVOO<P0, P1, P2, P3> {
    Parsers.ZipVVOO(p0, p1, p2, p3)
  }
}

extension Parsers {
  public struct ZipVVOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P0.Output == Void,
    P1.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P2.Output {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        return o2
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3
  ) -> Parsers.ZipVVOV<P0, P1, P2, P3> {
    Parsers.ZipVVOV(p0, p1, p2, p3)
  }
}

extension Parsers {
  public struct ZipVVVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P0.Output == Void,
    P1.Output == Void,
    P2.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P3.Output {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        return o3
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3
  ) -> Parsers.ZipVVVO<P0, P1, P2, P3> {
    Parsers.ZipVVVO(p0, p1, p2, p3)
  }
}

extension Parsers {
  public struct ZipVVVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P0.Output == Void,
    P1.Output == Void,
    P2.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3
  ) -> Parsers.ZipVVVV<P0, P1, P2, P3> {
    Parsers.ZipVVVV(p0, p1, p2, p3)
  }
}

extension Parsers {
  public struct ZipOOOOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P2.Output,
      P3.Output,
      P4.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        return (o0, o1, o2, o3, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipOOOOO<P0, P1, P2, P3, P4> {
    Parsers.ZipOOOOO(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipOOOOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P2.Output,
      P3.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        return (o0, o1, o2, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipOOOOV<P0, P1, P2, P3, P4> {
    Parsers.ZipOOOOV(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipOOOVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P2.Output,
      P4.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        return (o0, o1, o2, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipOOOVO<P0, P1, P2, P3, P4> {
    Parsers.ZipOOOVO(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipOOOVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P3.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P2.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        return (o0, o1, o2)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipOOOVV<P0, P1, P2, P3, P4> {
    Parsers.ZipOOOVV(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipOOVOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P2.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P3.Output,
      P4.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        return (o0, o1, o3, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipOOVOO<P0, P1, P2, P3, P4> {
    Parsers.ZipOOVOO(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipOOVOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P2.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P3.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        return (o0, o1, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipOOVOV<P0, P1, P2, P3, P4> {
    Parsers.ZipOOVOV(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipOOVVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P2.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P4.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        return (o0, o1, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipOOVVO<P0, P1, P2, P3, P4> {
    Parsers.ZipOOVVO(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipOOVVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P2.Output == Void,
    P3.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        return (o0, o1)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipOOVVV<P0, P1, P2, P3, P4> {
    Parsers.ZipOOVVV(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipOVOOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P1.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P2.Output,
      P3.Output,
      P4.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        return (o0, o2, o3, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipOVOOO<P0, P1, P2, P3, P4> {
    Parsers.ZipOVOOO(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipOVOOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P1.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P2.Output,
      P3.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        return (o0, o2, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipOVOOV<P0, P1, P2, P3, P4> {
    Parsers.ZipOVOOV(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipOVOVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P1.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P2.Output,
      P4.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        return (o0, o2, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipOVOVO<P0, P1, P2, P3, P4> {
    Parsers.ZipOVOVO(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipOVOVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P1.Output == Void,
    P3.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P2.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        return (o0, o2)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipOVOVV<P0, P1, P2, P3, P4> {
    Parsers.ZipOVOVV(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipOVVOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P1.Output == Void,
    P2.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P3.Output,
      P4.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        return (o0, o3, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipOVVOO<P0, P1, P2, P3, P4> {
    Parsers.ZipOVVOO(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipOVVOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P1.Output == Void,
    P2.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P3.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        return (o0, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipOVVOV<P0, P1, P2, P3, P4> {
    Parsers.ZipOVVOV(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipOVVVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P1.Output == Void,
    P2.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P4.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        return (o0, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipOVVVO<P0, P1, P2, P3, P4> {
    Parsers.ZipOVVVO(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipOVVVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P1.Output == Void,
    P2.Output == Void,
    P3.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P0.Output {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        return o0
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipOVVVV<P0, P1, P2, P3, P4> {
    Parsers.ZipOVVVV(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipVOOOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P0.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P2.Output,
      P3.Output,
      P4.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        return (o1, o2, o3, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipVOOOO<P0, P1, P2, P3, P4> {
    Parsers.ZipVOOOO(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipVOOOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P0.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P2.Output,
      P3.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        return (o1, o2, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipVOOOV<P0, P1, P2, P3, P4> {
    Parsers.ZipVOOOV(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipVOOVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P0.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P2.Output,
      P4.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        return (o1, o2, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipVOOVO<P0, P1, P2, P3, P4> {
    Parsers.ZipVOOVO(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipVOOVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P0.Output == Void,
    P3.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P2.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        return (o1, o2)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipVOOVV<P0, P1, P2, P3, P4> {
    Parsers.ZipVOOVV(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipVOVOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P0.Output == Void,
    P2.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P3.Output,
      P4.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        return (o1, o3, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipVOVOO<P0, P1, P2, P3, P4> {
    Parsers.ZipVOVOO(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipVOVOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P0.Output == Void,
    P2.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P3.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        return (o1, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipVOVOV<P0, P1, P2, P3, P4> {
    Parsers.ZipVOVOV(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipVOVVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P0.Output == Void,
    P2.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P4.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        return (o1, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipVOVVO<P0, P1, P2, P3, P4> {
    Parsers.ZipVOVVO(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipVOVVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P0.Output == Void,
    P2.Output == Void,
    P3.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P1.Output {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        return o1
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipVOVVV<P0, P1, P2, P3, P4> {
    Parsers.ZipVOVVV(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipVVOOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P0.Output == Void,
    P1.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P2.Output,
      P3.Output,
      P4.Output
    ) {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        return (o2, o3, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipVVOOO<P0, P1, P2, P3, P4> {
    Parsers.ZipVVOOO(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipVVOOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P0.Output == Void,
    P1.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P2.Output,
      P3.Output
    ) {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        return (o2, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipVVOOV<P0, P1, P2, P3, P4> {
    Parsers.ZipVVOOV(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipVVOVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P0.Output == Void,
    P1.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P2.Output,
      P4.Output
    ) {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        return (o2, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipVVOVO<P0, P1, P2, P3, P4> {
    Parsers.ZipVVOVO(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipVVOVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P0.Output == Void,
    P1.Output == Void,
    P3.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P2.Output {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        return o2
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipVVOVV<P0, P1, P2, P3, P4> {
    Parsers.ZipVVOVV(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipVVVOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P0.Output == Void,
    P1.Output == Void,
    P2.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P3.Output,
      P4.Output
    ) {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        return (o3, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipVVVOO<P0, P1, P2, P3, P4> {
    Parsers.ZipVVVOO(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipVVVOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P0.Output == Void,
    P1.Output == Void,
    P2.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P3.Output {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        return o3
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipVVVOV<P0, P1, P2, P3, P4> {
    Parsers.ZipVVVOV(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipVVVVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P0.Output == Void,
    P1.Output == Void,
    P2.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P4.Output {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        return o4
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipVVVVO<P0, P1, P2, P3, P4> {
    Parsers.ZipVVVVO(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipVVVVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P0.Output == Void,
    P1.Output == Void,
    P2.Output == Void,
    P3.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.ZipVVVVV<P0, P1, P2, P3, P4> {
    Parsers.ZipVVVVV(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct ZipOOOOOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P2.Output,
      P3.Output,
      P4.Output,
      P5.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o0, o1, o2, o3, o4, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOOOOOO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOOOOOO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOOOOOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P2.Output,
      P3.Output,
      P4.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        try p5.parse(&input)
        return (o0, o1, o2, o3, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOOOOOV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOOOOOV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOOOOVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P2.Output,
      P3.Output,
      P5.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o0, o1, o2, o3, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOOOOVO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOOOOVO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOOOOVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P4.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P2.Output,
      P3.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        try p5.parse(&input)
        return (o0, o1, o2, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOOOOVV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOOOOVV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOOOVOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P2.Output,
      P4.Output,
      P5.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o0, o1, o2, o4, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOOOVOO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOOOVOO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOOOVOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P3.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P2.Output,
      P4.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        try p5.parse(&input)
        return (o0, o1, o2, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOOOVOV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOOOVOV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOOOVVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P3.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P2.Output,
      P5.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o0, o1, o2, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOOOVVO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOOOVVO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOOOVVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P3.Output == Void,
    P4.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P2.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        try p5.parse(&input)
        return (o0, o1, o2)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOOOVVV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOOOVVV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOOVOOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P2.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P3.Output,
      P4.Output,
      P5.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o0, o1, o3, o4, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOOVOOO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOOVOOO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOOVOOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P2.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P3.Output,
      P4.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        try p5.parse(&input)
        return (o0, o1, o3, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOOVOOV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOOVOOV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOOVOVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P2.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P3.Output,
      P5.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o0, o1, o3, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOOVOVO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOOVOVO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOOVOVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P2.Output == Void,
    P4.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P3.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        try p5.parse(&input)
        return (o0, o1, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOOVOVV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOOVOVV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOOVVOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P2.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P4.Output,
      P5.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o0, o1, o4, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOOVVOO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOOVVOO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOOVVOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P2.Output == Void,
    P3.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P4.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        try p5.parse(&input)
        return (o0, o1, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOOVVOV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOOVVOV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOOVVVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P2.Output == Void,
    P3.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output,
      P5.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o0, o1, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOOVVVO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOOVVVO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOOVVVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P2.Output == Void,
    P3.Output == Void,
    P4.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P1.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        try p5.parse(&input)
        return (o0, o1)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOOVVVV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOOVVVV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOVOOOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P1.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P2.Output,
      P3.Output,
      P4.Output,
      P5.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o0, o2, o3, o4, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOVOOOO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOVOOOO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOVOOOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P1.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P2.Output,
      P3.Output,
      P4.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        try p5.parse(&input)
        return (o0, o2, o3, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOVOOOV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOVOOOV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOVOOVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P1.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P2.Output,
      P3.Output,
      P5.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o0, o2, o3, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOVOOVO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOVOOVO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOVOOVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P1.Output == Void,
    P4.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P2.Output,
      P3.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        try p5.parse(&input)
        return (o0, o2, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOVOOVV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOVOOVV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOVOVOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P1.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P2.Output,
      P4.Output,
      P5.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o0, o2, o4, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOVOVOO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOVOVOO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOVOVOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P1.Output == Void,
    P3.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P2.Output,
      P4.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        try p5.parse(&input)
        return (o0, o2, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOVOVOV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOVOVOV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOVOVVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P1.Output == Void,
    P3.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P2.Output,
      P5.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o0, o2, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOVOVVO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOVOVVO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOVOVVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P1.Output == Void,
    P3.Output == Void,
    P4.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P2.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        try p5.parse(&input)
        return (o0, o2)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOVOVVV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOVOVVV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOVVOOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P1.Output == Void,
    P2.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P3.Output,
      P4.Output,
      P5.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o0, o3, o4, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOVVOOO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOVVOOO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOVVOOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P1.Output == Void,
    P2.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P3.Output,
      P4.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        try p5.parse(&input)
        return (o0, o3, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOVVOOV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOVVOOV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOVVOVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P1.Output == Void,
    P2.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P3.Output,
      P5.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o0, o3, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOVVOVO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOVVOVO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOVVOVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P1.Output == Void,
    P2.Output == Void,
    P4.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P3.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        try p5.parse(&input)
        return (o0, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOVVOVV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOVVOVV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOVVVOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P1.Output == Void,
    P2.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P4.Output,
      P5.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o0, o4, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOVVVOO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOVVVOO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOVVVOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P1.Output == Void,
    P2.Output == Void,
    P3.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P4.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        try p5.parse(&input)
        return (o0, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOVVVOV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOVVVOV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOVVVVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P1.Output == Void,
    P2.Output == Void,
    P3.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P0.Output,
      P5.Output
    ) {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o0, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOVVVVO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOVVVVO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipOVVVVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P1.Output == Void,
    P2.Output == Void,
    P3.Output == Void,
    P4.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P0.Output {
      do {
        let o0 = try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        try p5.parse(&input)
        return o0
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipOVVVVV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipOVVVVV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVOOOOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P2.Output,
      P3.Output,
      P4.Output,
      P5.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o1, o2, o3, o4, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVOOOOO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVOOOOO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVOOOOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P2.Output,
      P3.Output,
      P4.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        try p5.parse(&input)
        return (o1, o2, o3, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVOOOOV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVOOOOV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVOOOVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P2.Output,
      P3.Output,
      P5.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o1, o2, o3, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVOOOVO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVOOOVO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVOOOVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P4.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P2.Output,
      P3.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        try p5.parse(&input)
        return (o1, o2, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVOOOVV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVOOOVV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVOOVOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P2.Output,
      P4.Output,
      P5.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o1, o2, o4, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVOOVOO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVOOVOO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVOOVOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P3.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P2.Output,
      P4.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        try p5.parse(&input)
        return (o1, o2, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVOOVOV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVOOVOV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVOOVVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P3.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P2.Output,
      P5.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o1, o2, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVOOVVO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVOOVVO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVOOVVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P3.Output == Void,
    P4.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P2.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        try p5.parse(&input)
        return (o1, o2)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVOOVVV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVOOVVV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVOVOOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P2.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P3.Output,
      P4.Output,
      P5.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o1, o3, o4, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVOVOOO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVOVOOO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVOVOOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P2.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P3.Output,
      P4.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        try p5.parse(&input)
        return (o1, o3, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVOVOOV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVOVOOV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVOVOVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P2.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P3.Output,
      P5.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o1, o3, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVOVOVO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVOVOVO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVOVOVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P2.Output == Void,
    P4.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P3.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        try p5.parse(&input)
        return (o1, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVOVOVV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVOVOVV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVOVVOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P2.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P4.Output,
      P5.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o1, o4, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVOVVOO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVOVVOO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVOVVOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P2.Output == Void,
    P3.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P4.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        try p5.parse(&input)
        return (o1, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVOVVOV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVOVVOV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVOVVVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P2.Output == Void,
    P3.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P1.Output,
      P5.Output
    ) {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o1, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVOVVVO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVOVVVO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVOVVVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P2.Output == Void,
    P3.Output == Void,
    P4.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P1.Output {
      do {
        try p0.parse(&input)
        let o1 = try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        try p5.parse(&input)
        return o1
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVOVVVV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVOVVVV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVVOOOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P1.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P2.Output,
      P3.Output,
      P4.Output,
      P5.Output
    ) {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o2, o3, o4, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVVOOOO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVVOOOO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVVOOOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P1.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P2.Output,
      P3.Output,
      P4.Output
    ) {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        try p5.parse(&input)
        return (o2, o3, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVVOOOV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVVOOOV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVVOOVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P1.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P2.Output,
      P3.Output,
      P5.Output
    ) {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o2, o3, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVVOOVO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVVOOVO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVVOOVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P1.Output == Void,
    P4.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P2.Output,
      P3.Output
    ) {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        try p5.parse(&input)
        return (o2, o3)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVVOOVV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVVOOVV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVVOVOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P1.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P2.Output,
      P4.Output,
      P5.Output
    ) {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o2, o4, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVVOVOO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVVOVOO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVVOVOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P1.Output == Void,
    P3.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P2.Output,
      P4.Output
    ) {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        try p5.parse(&input)
        return (o2, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVVOVOV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVVOVOV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVVOVVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P1.Output == Void,
    P3.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P2.Output,
      P5.Output
    ) {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o2, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVVOVVO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVVOVVO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVVOVVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P1.Output == Void,
    P3.Output == Void,
    P4.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P2.Output {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        let o2 = try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        try p5.parse(&input)
        return o2
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVVOVVV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVVOVVV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVVVOOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P1.Output == Void,
    P2.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P3.Output,
      P4.Output,
      P5.Output
    ) {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o3, o4, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVVVOOO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVVVOOO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVVVOOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P1.Output == Void,
    P2.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P3.Output,
      P4.Output
    ) {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        let o4 = try p4.parse(&input)
        try p5.parse(&input)
        return (o3, o4)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVVVOOV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVVVOOV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVVVOVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P1.Output == Void,
    P2.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P3.Output,
      P5.Output
    ) {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o3, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVVVOVO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVVVOVO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVVVOVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P1.Output == Void,
    P2.Output == Void,
    P4.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P3.Output {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        let o3 = try p3.parse(&input)
        try p4.parse(&input)
        try p5.parse(&input)
        return o3
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVVVOVV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVVVOVV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVVVVOO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P1.Output == Void,
    P2.Output == Void,
    P3.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> (
      P4.Output,
      P5.Output
    ) {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return (o4, o5)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVVVVOO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVVVVOO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVVVVOV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P1.Output == Void,
    P2.Output == Void,
    P3.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P4.Output {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        let o4 = try p4.parse(&input)
        try p5.parse(&input)
        return o4
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVVVVOV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVVVVOV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVVVVVO<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P1.Output == Void,
    P2.Output == Void,
    P3.Output == Void,
    P4.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P5.Output {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        let o5 = try p5.parse(&input)
        return o5
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVVVVVO<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVVVVVO(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct ZipVVVVVV<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == Void,
    P1.Output == Void,
    P2.Output == Void,
    P3.Output == Void,
    P4.Output == Void,
    P5.Output == Void
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows {
      do {
        try p0.parse(&input)
        try p1.parse(&input)
        try p2.parse(&input)
        try p3.parse(&input)
        try p4.parse(&input)
        try p5.parse(&input)
      } catch { throw ParsingError.wrap(error, at: input) }
    }
  }
}

extension ParserBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.ZipVVVVVV<P0, P1, P2, P3, P4, P5> {
    Parsers.ZipVVVVVV(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct OneOf2<P0: Parser, P1: Parser>: Parser
  where
    P0.Input == P1.Input,
    P0.Output == P1.Output
  {
    public let p0: P0, p1: P1

    @inlinable public init(_ p0: P0, _ p1: P1) {
      self.p0 = p0
      self.p1 = p1
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P0.Output {
      let original = input
      do { return try self.p0.parse(&input) } catch let e0 {
        do { input = original; return try self.p1.parse(&input) } catch let e1 {
          throw ParsingError.manyFailed(
            [e0, e1], at: input
          )
        }
      }
    }
  }
}

extension OneOfBuilder {
  @inlinable public static func buildBlock<P0, P1>(
    _ p0: P0, _ p1: P1
  ) -> Parsers.OneOf2<P0, P1> {
    Parsers.OneOf2(p0, p1)
  }
}

extension Parsers {
  public struct OneOf3<P0: Parser, P1: Parser, P2: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P0.Output == P1.Output,
    P1.Output == P2.Output
  {
    public let p0: P0, p1: P1, p2: P2

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P0.Output {
      let original = input
      do { return try self.p0.parse(&input) } catch let e0 {
        do { input = original; return try self.p1.parse(&input) } catch let e1 {
          do { input = original; return try self.p2.parse(&input) } catch let e2 {
            throw ParsingError.manyFailed(
              [e0, e1, e2], at: input
            )
          }
        }
      }
    }
  }
}

extension OneOfBuilder {
  @inlinable public static func buildBlock<P0, P1, P2>(
    _ p0: P0, _ p1: P1, _ p2: P2
  ) -> Parsers.OneOf3<P0, P1, P2> {
    Parsers.OneOf3(p0, p1, p2)
  }
}

extension Parsers {
  public struct OneOf4<P0: Parser, P1: Parser, P2: Parser, P3: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P0.Output == P1.Output,
    P1.Output == P2.Output,
    P2.Output == P3.Output
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P0.Output {
      let original = input
      do { return try self.p0.parse(&input) } catch let e0 {
        do { input = original; return try self.p1.parse(&input) } catch let e1 {
          do { input = original; return try self.p2.parse(&input) } catch let e2 {
            do { input = original; return try self.p3.parse(&input) } catch let e3 {
              throw ParsingError.manyFailed(
                [e0, e1, e2, e3], at: input
              )
            }
          }
        }
      }
    }
  }
}

extension OneOfBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3
  ) -> Parsers.OneOf4<P0, P1, P2, P3> {
    Parsers.OneOf4(p0, p1, p2, p3)
  }
}

extension Parsers {
  public struct OneOf5<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P0.Output == P1.Output,
    P1.Output == P2.Output,
    P2.Output == P3.Output,
    P3.Output == P4.Output
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P0.Output {
      let original = input
      do { return try self.p0.parse(&input) } catch let e0 {
        do { input = original; return try self.p1.parse(&input) } catch let e1 {
          do { input = original; return try self.p2.parse(&input) } catch let e2 {
            do { input = original; return try self.p3.parse(&input) } catch let e3 {
              do { input = original; return try self.p4.parse(&input) } catch let e4 {
                throw ParsingError.manyFailed(
                  [e0, e1, e2, e3, e4], at: input
                )
              }
            }
          }
        }
      }
    }
  }
}

extension OneOfBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4
  ) -> Parsers.OneOf5<P0, P1, P2, P3, P4> {
    Parsers.OneOf5(p0, p1, p2, p3, p4)
  }
}

extension Parsers {
  public struct OneOf6<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P0.Output == P1.Output,
    P1.Output == P2.Output,
    P2.Output == P3.Output,
    P3.Output == P4.Output,
    P4.Output == P5.Output
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P0.Output {
      let original = input
      do { return try self.p0.parse(&input) } catch let e0 {
        do { input = original; return try self.p1.parse(&input) } catch let e1 {
          do { input = original; return try self.p2.parse(&input) } catch let e2 {
            do { input = original; return try self.p3.parse(&input) } catch let e3 {
              do { input = original; return try self.p4.parse(&input) } catch let e4 {
                do { input = original; return try self.p5.parse(&input) } catch let e5 {
                  throw ParsingError.manyFailed(
                    [e0, e1, e2, e3, e4, e5], at: input
                  )
                }
              }
            }
          }
        }
      }
    }
  }
}

extension OneOfBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5
  ) -> Parsers.OneOf6<P0, P1, P2, P3, P4, P5> {
    Parsers.OneOf6(p0, p1, p2, p3, p4, p5)
  }
}

extension Parsers {
  public struct OneOf7<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser, P6: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P5.Input == P6.Input,
    P0.Output == P1.Output,
    P1.Output == P2.Output,
    P2.Output == P3.Output,
    P3.Output == P4.Output,
    P4.Output == P5.Output,
    P5.Output == P6.Output
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5, p6: P6

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
      self.p6 = p6
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P0.Output {
      let original = input
      do { return try self.p0.parse(&input) } catch let e0 {
        do { input = original; return try self.p1.parse(&input) } catch let e1 {
          do { input = original; return try self.p2.parse(&input) } catch let e2 {
            do { input = original; return try self.p3.parse(&input) } catch let e3 {
              do { input = original; return try self.p4.parse(&input) } catch let e4 {
                do { input = original; return try self.p5.parse(&input) } catch let e5 {
                  do { input = original; return try self.p6.parse(&input) } catch let e6 {
                    throw ParsingError.manyFailed(
                      [e0, e1, e2, e3, e4, e5, e6], at: input
                    )
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

extension OneOfBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5, P6>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6
  ) -> Parsers.OneOf7<P0, P1, P2, P3, P4, P5, P6> {
    Parsers.OneOf7(p0, p1, p2, p3, p4, p5, p6)
  }
}

extension Parsers {
  public struct OneOf8<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser, P6: Parser, P7: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P5.Input == P6.Input,
    P6.Input == P7.Input,
    P0.Output == P1.Output,
    P1.Output == P2.Output,
    P2.Output == P3.Output,
    P3.Output == P4.Output,
    P4.Output == P5.Output,
    P5.Output == P6.Output,
    P6.Output == P7.Output
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5, p6: P6, p7: P7

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
      self.p6 = p6
      self.p7 = p7
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P0.Output {
      let original = input
      do { return try self.p0.parse(&input) } catch let e0 {
        do { input = original; return try self.p1.parse(&input) } catch let e1 {
          do { input = original; return try self.p2.parse(&input) } catch let e2 {
            do { input = original; return try self.p3.parse(&input) } catch let e3 {
              do { input = original; return try self.p4.parse(&input) } catch let e4 {
                do { input = original; return try self.p5.parse(&input) } catch let e5 {
                  do { input = original; return try self.p6.parse(&input) } catch let e6 {
                    do { input = original; return try self.p7.parse(&input) } catch let e7 {
                      throw ParsingError.manyFailed(
                        [e0, e1, e2, e3, e4, e5, e6, e7], at: input
                      )
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

extension OneOfBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5, P6, P7>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7
  ) -> Parsers.OneOf8<P0, P1, P2, P3, P4, P5, P6, P7> {
    Parsers.OneOf8(p0, p1, p2, p3, p4, p5, p6, p7)
  }
}

extension Parsers {
  public struct OneOf9<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser, P6: Parser, P7: Parser, P8: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P5.Input == P6.Input,
    P6.Input == P7.Input,
    P7.Input == P8.Input,
    P0.Output == P1.Output,
    P1.Output == P2.Output,
    P2.Output == P3.Output,
    P3.Output == P4.Output,
    P4.Output == P5.Output,
    P5.Output == P6.Output,
    P6.Output == P7.Output,
    P7.Output == P8.Output
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5, p6: P6, p7: P7, p8: P8

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
      self.p6 = p6
      self.p7 = p7
      self.p8 = p8
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P0.Output {
      let original = input
      do { return try self.p0.parse(&input) } catch let e0 {
        do { input = original; return try self.p1.parse(&input) } catch let e1 {
          do { input = original; return try self.p2.parse(&input) } catch let e2 {
            do { input = original; return try self.p3.parse(&input) } catch let e3 {
              do { input = original; return try self.p4.parse(&input) } catch let e4 {
                do { input = original; return try self.p5.parse(&input) } catch let e5 {
                  do { input = original; return try self.p6.parse(&input) } catch let e6 {
                    do { input = original; return try self.p7.parse(&input) } catch let e7 {
                      do { input = original; return try self.p8.parse(&input) } catch let e8 {
                        throw ParsingError.manyFailed(
                          [e0, e1, e2, e3, e4, e5, e6, e7, e8], at: input
                        )
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

extension OneOfBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5, P6, P7, P8>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8
  ) -> Parsers.OneOf9<P0, P1, P2, P3, P4, P5, P6, P7, P8> {
    Parsers.OneOf9(p0, p1, p2, p3, p4, p5, p6, p7, p8)
  }
}

extension Parsers {
  public struct OneOf10<P0: Parser, P1: Parser, P2: Parser, P3: Parser, P4: Parser, P5: Parser, P6: Parser, P7: Parser, P8: Parser, P9: Parser>: Parser
  where
    P0.Input == P1.Input,
    P1.Input == P2.Input,
    P2.Input == P3.Input,
    P3.Input == P4.Input,
    P4.Input == P5.Input,
    P5.Input == P6.Input,
    P6.Input == P7.Input,
    P7.Input == P8.Input,
    P8.Input == P9.Input,
    P0.Output == P1.Output,
    P1.Output == P2.Output,
    P2.Output == P3.Output,
    P3.Output == P4.Output,
    P4.Output == P5.Output,
    P5.Output == P6.Output,
    P6.Output == P7.Output,
    P7.Output == P8.Output,
    P8.Output == P9.Output
  {
    public let p0: P0, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5, p6: P6, p7: P7, p8: P8, p9: P9

    @inlinable public init(_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8, _ p9: P9) {
      self.p0 = p0
      self.p1 = p1
      self.p2 = p2
      self.p3 = p3
      self.p4 = p4
      self.p5 = p5
      self.p6 = p6
      self.p7 = p7
      self.p8 = p8
      self.p9 = p9
    }

    @inlinable public func parse(_ input: inout P0.Input) rethrows -> P0.Output {
      let original = input
      do { return try self.p0.parse(&input) } catch let e0 {
        do { input = original; return try self.p1.parse(&input) } catch let e1 {
          do { input = original; return try self.p2.parse(&input) } catch let e2 {
            do { input = original; return try self.p3.parse(&input) } catch let e3 {
              do { input = original; return try self.p4.parse(&input) } catch let e4 {
                do { input = original; return try self.p5.parse(&input) } catch let e5 {
                  do { input = original; return try self.p6.parse(&input) } catch let e6 {
                    do { input = original; return try self.p7.parse(&input) } catch let e7 {
                      do { input = original; return try self.p8.parse(&input) } catch let e8 {
                        do { input = original; return try self.p9.parse(&input) } catch let e9 {
                          throw ParsingError.manyFailed(
                            [e0, e1, e2, e3, e4, e5, e6, e7, e8, e9], at: input
                          )
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

extension OneOfBuilder {
  @inlinable public static func buildBlock<P0, P1, P2, P3, P4, P5, P6, P7, P8, P9>(
    _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8, _ p9: P9
  ) -> Parsers.OneOf10<P0, P1, P2, P3, P4, P5, P6, P7, P8, P9> {
    Parsers.OneOf10(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9)
  }
}

// END AUTO-GENERATED CONTENT
