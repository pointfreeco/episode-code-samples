extension Parser {
  /// Returns a parser that runs this parser and the given parser, returning both outputs in a
  /// tuple.
  ///
  /// This operator is used to gather up multiple values and can bundle them into a single data type
  /// when used alongside the ``map(_:)`` operator.
  ///
  /// In the following example, two `Double`s are parsed using ``take(_:)-1fw8y`` before they are
  /// combined into a `Point`.
  ///
  /// ```swift
  /// struct Point { var x, y: Double }
  ///
  /// var input = "-1.5,1"[...].utf8
  /// let output = Double.parser()
  ///   .skip(",")
  ///   .take(Double.parser())
  ///   .map(Point.init)
  ///   .parse(&input) // => Point(x: -1.5, y: 1)
  /// precondition(Substring(input) == "")
  /// ```
  ///
  /// - Parameter parser: A parser to run immediately after this parser.
  /// - Returns: A parser that runs two parsers, returning both outputs in a tuple.
  @inlinable
  public func take<P>(
    _ parser: P
  ) -> Parsers.Take2<Self, P>
  where P: Parser, P.Input == Input {
    .init(self, parser)
  }

  /// Returns a parser that runs this parser and the given parser, returning this parser's outputs
  /// and the given parser's output in a flattened tuple.
  ///
  /// - Parameter parser: A parser to run immediately after this parser.
  /// - Returns: A parser that runs two parsers, returning both outputs in a flattened tuple.
  @inlinable
  public func take<A, B, P>(
    _ parser: P
  ) -> Parsers.Take3<Self, A, B, P>
  where P: Parser, P.Input == Input, Output == (A, B) {
    .init(self, parser)
  }

  /// Returns a parser that runs this parser and the given parser, returning this parser's outputs
  /// and the given parser's output in a flattened tuple.
  ///
  /// - Parameter parser: A parser to run immediately after this parser.
  /// - Returns: A parser that runs two parsers, returning both outputs in a flattened tuple.
  @inlinable
  public func take<A, B, C, P>(
    _ parser: P
  ) -> Parsers.Take4<Self, A, B, C, P>
  where P: Parser, P.Input == Input, Output == (A, B, C) {
    .init(self, parser)
  }

  /// Returns a parser that runs this parser and the given parser, returning this parser's outputs
  /// and the given parser's output in a flattened tuple.
  ///
  /// - Parameter parser: A parser to run immediately after this parser.
  /// - Returns: A parser that runs two parsers, returning both outputs in a flattened tuple.
  @inlinable
  public func take<A, B, C, D, P>(
    _ parser: P
  ) -> Parsers.Take5<Self, A, B, C, D, P>
  where P: Parser, P.Input == Input, Output == (A, B, C, D) {
    .init(self, parser)
  }

  /// Returns a parser that runs this parser and the given parser, returning this parser's outputs
  /// and the given parser's output in a flattened tuple.
  ///
  /// - Parameter parser: A parser to run immediately after this parser.
  /// - Returns: A parser that runs two parsers, returning both outputs in a flattened tuple.
  @inlinable
  public func take<A, B, C, D, E, P>(
    _ parser: P
  ) -> Parsers.Take6<Self, A, B, C, D, E, P>
  where P: Parser, P.Input == Input, Output == (A, B, C, D, E) {
    .init(self, parser)
  }

  /// Returns a parser that runs this parser and the given parser, returning this parser's outputs
  /// and the given parser's output in a flattened tuple.
  ///
  /// - Parameter parser: A parser to run immediately after this parser.
  /// - Returns: A parser that runs two parsers, returning both outputs in a flattened tuple.
  @inlinable
  public func take<A, B, C, D, E, F, P>(
    _ parser: P
  ) -> Parsers.Take7<Self, A, B, C, D, E, F, P>
  where P: Parser, P.Input == Input, Output == (A, B, C, D, E, F) {
    .init(self, parser)
  }

  /// Returns a parser that runs this parser and the given parser, returning this parser's outputs
  /// and the given parser's output in a flattened tuple.
  ///
  /// - Parameter parser: A parser to run immediately after this parser.
  /// - Returns: A parser that runs two parsers, returning both outputs in a flattened tuple.
  @inlinable
  public func take<A, B, C, D, E, F, G, P>(
    _ parser: P
  ) -> Parsers.Take8<Self, A, B, C, D, E, F, G, P>
  where P: Parser, P.Input == Input, Output == (A, B, C, D, E, F, G) {
    .init(self, parser)
  }

  /// Returns a parser that runs this parser and the given parser, returning this parser's outputs
  /// and the given parser's output in a flattened tuple.
  ///
  /// - Parameter parser: A parser to run immediately after this parser.
  /// - Returns: A parser that runs two parsers, returning both outputs in a flattened tuple.
  @inlinable
  public func take<A, B, C, D, E, F, G, H, P>(
    _ parser: P
  ) -> Parsers.Take9<Self, A, B, C, D, E, F, G, H, P>
  where P: Parser, P.Input == Input, Output == (A, B, C, D, E, F, G, H) {
    .init(self, parser)
  }

  /// Returns a parser that runs this parser and the given parser, returning this parser's outputs
  /// and the given parser's output in a flattened tuple.
  ///
  /// - Parameter parser: A parser to run immediately after this parser.
  /// - Returns: A parser that runs two parsers, returning both outputs in a flattened tuple.
  @inlinable
  public func take<A, B, C, D, E, F, G, H, I, P>(
    _ parser: P
  ) -> Parsers.Take10<Self, A, B, C, D, E, F, G, H, I, P>
  where P: Parser, P.Input == Input, Output == (A, B, C, D, E, F, G, H, I) {
    .init(self, parser)
  }

  /// Returns a parser that runs this parser and the given parser, returning this parser's outputs
  /// and the given parser's output in a flattened tuple.
  ///
  /// - Parameter parser: A parser to run immediately after this parser.
  /// - Returns: A parser that runs two parsers, returning both outputs in a flattened tuple.
  @inlinable
  public func take<A, B, C, D, E, F, G, H, I, J, P>(
    _ parser: P
  ) -> Parsers.Take11<Self, A, B, C, D, E, F, G, H, I, J, P>
  where P: Parser, P.Input == Input, Output == (A, B, C, D, E, F, G, H, I, J) {
    .init(self, parser)
  }
}

extension Parsers {
  /// A parser that runs two parsers, one after the other, and returns both outputs in a tuple.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// the ``Parser/take(_:)-6f1jr`` operation, which constructs this type.
  public struct Take2<A, B>: Parser
  where
    A: Parser,
    B: Parser,
    A.Input == B.Input
  {
    public let a: A
    public let b: B

    @inlinable
    public init(_ a: A, _ b: B) {
      self.a = a
      self.b = b
    }

    @inlinable
    public func parse(_ input: inout A.Input) -> (A.Output, B.Output)? {
      let original = input
      guard let a = self.a.parse(&input)
      else { return nil }
      guard let b = self.b.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b)
    }
  }

  /// A parser that runs a parser of a tuple of outputs and another parser, one after the other,
  /// and returns a flattened tuple of the first parser's outputs and the second parser's output.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// the ``Parser/take(_:)-3ezb3`` operation, which constructs this type.
  public struct Take3<AB, A, B, C>: Parser
  where
    AB: Parser,
    AB.Output == (A, B),
    C: Parser,
    AB.Input == C.Input
  {
    public let ab: AB
    public let c: C

    @inlinable
    public init(
      _ ab: AB,
      _ c: C
    ) {
      self.ab = ab
      self.c = c
    }

    @inlinable
    public func parse(_ input: inout AB.Input) -> (A, B, C.Output)? {
      let original = input
      guard let (a, b) = self.ab.parse(&input)
      else { return nil }
      guard let c = self.c.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c)
    }
  }

  /// A parser that runs a parser of a tuple of outputs and another parser, one after the other,
  /// and returns a flattened tuple of the first parser's outputs and the second parser's output.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// the ``Parser/take(_:)-3thpr`` operation, which constructs this type.
  public struct Take4<ABC, A, B, C, D>: Parser
  where
    ABC: Parser,
    ABC.Output == (A, B, C),
    D: Parser,
    ABC.Input == D.Input
  {
    public let abc: ABC
    public let d: D

    @inlinable
    public init(
      _ abc: ABC,
      _ d: D
    ) {
      self.abc = abc
      self.d = d
    }

    @inlinable
    public func parse(_ input: inout ABC.Input) -> (A, B, C, D.Output)? {
      let original = input
      guard let (a, b, c) = self.abc.parse(&input)
      else { return nil }
      guard let d = self.d.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c, d)
    }
  }

  /// A parser that runs a parser of a tuple of outputs and another parser, one after the other,
  /// and returns a flattened tuple of the first parser's outputs and the second parser's output.\
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// the ``Parser/take(_:)-5qnt6`` operation, which constructs this type.
  public struct Take5<ABCD, A, B, C, D, E>: Parser
  where
    ABCD: Parser,
    ABCD.Output == (A, B, C, D),
    E: Parser,
    ABCD.Input == E.Input
  {
    public let abcd: ABCD
    public let e: E

    @inlinable
    public init(
      _ abcd: ABCD,
      _ e: E
    ) {
      self.abcd = abcd
      self.e = e
    }

    @inlinable
    public func parse(_ input: inout ABCD.Input) -> (A, B, C, D, E.Output)? {
      let original = input
      guard let (a, b, c, d) = self.abcd.parse(&input)
      else { return nil }
      guard let e = self.e.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c, d, e)
    }
  }

  /// A parser that runs a parser of a tuple of outputs and another parser, one after the other,
  /// and returns a flattened tuple of the first parser's outputs and the second parser's output.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// the ``Parser/take(_:)-74wwn`` operation, which constructs this type.
  public struct Take6<ABCDE, A, B, C, D, E, F>: Parser
  where
    ABCDE: Parser,
    ABCDE.Output == (A, B, C, D, E),
    F: Parser,
    ABCDE.Input == F.Input
  {
    public let abcde: ABCDE
    public let f: F

    @inlinable
    public init(
      _ abcde: ABCDE,
      _ f: F
    ) {
      self.abcde = abcde
      self.f = f
    }

    @inlinable
    public func parse(_ input: inout ABCDE.Input) -> (A, B, C, D, E, F.Output)? {
      let original = input
      guard let (a, b, c, d, e) = self.abcde.parse(&input)
      else { return nil }
      guard let f = self.f.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c, d, e, f)
    }
  }

  /// A parser that runs a parser of a tuple of outputs and another parser, one after the other,
  /// and returns a flattened tuple of the first parser's outputs and the second parser's output.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// the ``Parser/take(_:)-5wm45`` operation, which constructs this type.
  public struct Take7<ABCDEF, A, B, C, D, E, F, G>: Parser
  where
    ABCDEF: Parser,
    ABCDEF.Output == (A, B, C, D, E, F),
    G: Parser,
    ABCDEF.Input == G.Input
  {
    public let abcdef: ABCDEF
    public let g: G

    @inlinable
    public init(
      _ abcdef: ABCDEF,
      _ g: G
    ) {
      self.abcdef = abcdef
      self.g = g
    }

    @inlinable
    public func parse(_ input: inout ABCDEF.Input) -> (A, B, C, D, E, F, G.Output)? {
      let original = input
      guard let (a, b, c, d, e, f) = self.abcdef.parse(&input)
      else { return nil }
      guard let g = self.g.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c, d, e, f, g)
    }
  }

  /// A parser that runs a parser of a tuple of outputs and another parser, one after the other,
  /// and returns a flattened tuple of the first parser's outputs and the second parser's output.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// the ``Parser/take(_:)-9ytif`` operation, which constructs this type.
  public struct Take8<ABCDEFG, A, B, C, D, E, F, G, H>: Parser
  where
    ABCDEFG: Parser,
    ABCDEFG.Output == (A, B, C, D, E, F, G),
    H: Parser,
    ABCDEFG.Input == H.Input
  {
    public let abcdefg: ABCDEFG
    public let h: H

    @inlinable
    public init(
      _ abcdefg: ABCDEFG,
      _ h: H
    ) {
      self.abcdefg = abcdefg
      self.h = h
    }

    @inlinable
    public func parse(_ input: inout ABCDEFG.Input) -> (A, B, C, D, E, F, G, H.Output)? {
      let original = input
      guard let (a, b, c, d, e, f, g) = self.abcdefg.parse(&input)
      else { return nil }
      guard let h = self.h.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c, d, e, f, g, h)
    }
  }

  /// A parser that runs a parser of a tuple of outputs and another parser, one after the other,
  /// and returns a flattened tuple of the first parser's outputs and the second parser's output.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// the ``Parser/take(_:)-226d4`` operation, which constructs this type.
  public struct Take9<ABCDEFGH, A, B, C, D, E, F, G, H, I>: Parser
  where
    ABCDEFGH: Parser,
    ABCDEFGH.Output == (A, B, C, D, E, F, G, H),
    I: Parser,
    ABCDEFGH.Input == I.Input
  {
    public let abcdefgh: ABCDEFGH
    public let i: I

    @inlinable
    public init(
      _ abcdefgh: ABCDEFGH,
      _ i: I
    ) {
      self.abcdefgh = abcdefgh
      self.i = i
    }

    @inlinable
    public func parse(_ input: inout ABCDEFGH.Input) -> (A, B, C, D, E, F, G, H, I.Output)? {
      let original = input
      guard let (a, b, c, d, e, f, g, h) = self.abcdefgh.parse(&input)
      else { return nil }
      guard let i = self.i.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c, d, e, f, g, h, i)
    }
  }

  /// A parser that runs a parser of a tuple of outputs and another parser, one after the other,
  /// and returns a flattened tuple of the first parser's outputs and the second parser's output.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// the ``Parser/take(_:)-fbhx`` operation, which constructs this type.
  public struct Take10<ABCDEFGHI, A, B, C, D, E, F, G, H, I, J>: Parser
  where
    ABCDEFGHI: Parser,
    ABCDEFGHI.Output == (A, B, C, D, E, F, G, H, I),
    J: Parser,
    ABCDEFGHI.Input == J.Input
  {
    public let abcdefghi: ABCDEFGHI
    public let j: J

    @inlinable
    public init(
      _ abcdefghi: ABCDEFGHI,
      _ j: J
    ) {
      self.abcdefghi = abcdefghi
      self.j = j
    }

    @inlinable
    public func parse(_ input: inout ABCDEFGHI.Input) -> (A, B, C, D, E, F, G, H, I, J.Output)? {
      let original = input
      guard let (a, b, c, d, e, f, g, h, i) = self.abcdefghi.parse(&input)
      else { return nil }
      guard let j = self.j.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c, d, e, f, g, h, i, j)
    }
  }

  /// A parser that runs a parser of a tuple of outputs and another parser, one after the other,
  /// and returns a flattened tuple of the first parser's outputs and the second parser's output.
  ///
  /// You will not typically need to interact with this type directly. Instead you will usually use
  /// the ``Parser/take(_:)-5a47k`` operation, which constructs this type.
  public struct Take11<ABCDEFGHIJ, A, B, C, D, E, F, G, H, I, J, K>: Parser
  where
    ABCDEFGHIJ: Parser,
    ABCDEFGHIJ.Output == (A, B, C, D, E, F, G, H, I, J),
    K: Parser,
    ABCDEFGHIJ.Input == K.Input
  {
    public let abcdefghij: ABCDEFGHIJ
    public let k: K

    @inlinable
    public init(
      _ abcdefghij: ABCDEFGHIJ,
      _ k: K
    ) {
      self.abcdefghij = abcdefghij
      self.k = k
    }

    @inlinable
    public func parse(_ input: inout ABCDEFGHIJ.Input) -> (A, B, C, D, E, F, G, H, I, J, K.Output)?
    {
      let original = input
      guard let (a, b, c, d, e, f, g, h, i, j) = self.abcdefghij.parse(&input)
      else { return nil }
      guard let k = self.k.parse(&input)
      else {
        input = original
        return nil
      }
      return (a, b, c, d, e, f, g, h, i, j, k)
    }
  }
}
