import Parsing

@resultBuilder
enum ParserBuilder {
  static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0,
    _ p1: P1,
    _ p2: P2,
    _ p3: P3,
    _ p4: P4
  )
  -> Parsers.Take3<Parsers.SkipSecond<Parsers.Take2<Parsers.SkipSecond<P0, P1>, P2>, P3>, P0.Output, P2.Output, P4>
  where
    P0: Parser,
    P1: Parser,
    P2: Parser,
    P3: Parser,
    P4: Parser,
    P1.Output == Void,
    P3.Output == Void
  {
    p0.skip(p1).take(p2).skip(p3).take(p4)
  }

  static func buildBlock<P0, P1, P2>(
    _ p0: P0,
    _ p1: P1,
    _ p2: P2
  )
  -> Parsers.Take3<Parsers.Take2<P0, P1>, P0.Output, P1.Output, P2>
  where
    P0: Parser,
    P1: Parser,
    P2: Parser
  {
    p0.take(p1).take(p2)
  }

  static func buildBlock<P0>(
    _ p0: P0
  )
  -> P0
  where
    P0: Parser
  {
    p0
  }

  static func buildBlock<P0, P1, P2>(
    _ p0: P0,
    _ p1: P1,
    _ p2: P2
  )
  -> Parsers.Take2<Parsers.SkipSecond<P0, P1>, P2>
  where
    P0: Parser,
    P1: Parser,
    P2: Parser,
    P1.Output == Void
  {
    p0.skip(p1).take(p2)
  }

  static func buildBlock<P0, P1, P2, P3>(
    _ p0: P0,
    _ p1: P1,
    _ p2: P2,
    _ p3: P3
  ) -> Parsers.Take2<Parsers.SkipSecond<Parsers.SkipSecond<P0, P1>, P2>, P3>
  where
    P0: Parser,
    P1: Parser,
    P2: Parser,
    P3: Parser,
    P1.Output == Void,
    P2.Output == Void
  {
    p0.skip(p1).skip(p2).take(p3)
  }

  static func buildBlock<P0, P1>(
    _ p0: P0,
    _ p1: P1
  )
  -> Parsers.Take2<P0, P1>
  where
    P0: Parser,
    P1: Parser
  {
    p0.take(p1)
  }

  static func buildBlock<P0, P1>(
     _ p0: P0,
     _ p1: P1
   )
   -> Parsers.SkipSecond<P0, P1>
   where
     P0: Parser,
     P1: Parser,
     P0.Output == Void,
     P1.Output == Void
   {
     p0.skip(p1)
   }

  static func buildBlock<P0, P1, P2>(
      _ p0: P0,
      _ p1: P1,
      _ p2: P2
    )
    -> Parsers.SkipSecond<Parsers.SkipSecond<P0, P1>, P2>
    where
      P0: Parser,
      P1: Parser,
      P2: Parser,
      P0.Output == Void,
      P1.Output == Void,
      P2.Output == Void
    {
      p0.skip(p1).skip(p2)
    }


  static func buildBlock<P0, P1, P2, P3>(
      _ p0: P0,
      _ p1: P1,
      _ p2: P2,
      _ p3: P3
    )
    -> Parsers.SkipSecond<Parsers.SkipFirst<Parsers.SkipSecond<P0, P1>, P2>, P3>
    where
      P0: Parser,
      P1: Parser,
      P2: Parser,
      P3: Parser,
      P0.Output == Void,
      P1.Output == Void,
      P3.Output == Void
    {
      p0.skip(p1).take(p2).skip(p3)
    }

  static func buildBlock<P0, P1, P2, P3, P4>(
      _ p0: P0,
      _ p1: P1,
      _ p2: P2,
      _ p3: P3,
      _ p4: P4
    )
    -> Parsers.SkipSecond<Parsers.SkipSecond<Parsers.SkipFirst<Parsers.SkipSecond<P0, P1>, P2>, P3>, P4>
    where
      P0: Parser,
      P1: Parser,
      P2: Parser,
      P3: Parser,
      P4: Parser,
      P0.Output == Void,
      P1.Output == Void,
      P3.Output == Void,
      P4.Output == Void
    {
      p0.skip(p1).take(p2).skip(p3).skip(p4)
    }


  static func buildBlock<P0, P1, P2>(
      _ p0: P0,
      _ p1: P1,
      _ p2: P2
    )
    -> Parsers.SkipFirst<Parsers.SkipSecond<P0, P1>, P2>
    where
      P0: Parser,
      P1: Parser,
      P2: Parser,
      P0.Output == Void,
      P1.Output == Void
    {
      p0.skip(p1).take(p2)
    }


  static func buildBlock<P0, P1>(
      _ p0: P0,
      _ p1: P1
    )
    -> Parsers.SkipFirst<P0, P1>
    where
      P0: Parser,
      P1: Parser,
      P0.Output == Void
    {
      p0.take(p1)
    }


    static func buildBlock<P0, P1, P2>(
      _ p0: P0,
      _ p1: P1,
      _ p2: P2
    )
    -> Parsers.SkipSecond<Parsers.SkipFirst<P0, P1>, P2>
    where
      P0: Parser,
      P1: Parser,
      P2: Parser,
      P0.Output == Void,
      P2.Output == Void
    {
      p0.take(p1).skip(p2)
    }
}

struct Parse<Parsers, NewOutput>: Parser where Parsers: Parser {
  let transform: (Parsers.Output) -> NewOutput
  let parsers: Parsers
  init(
    _ transform: @escaping (Parsers.Output) -> NewOutput,
    @ParserBuilder parsers: () -> Parsers
  ) {
    self.transform = transform
    self.parsers = parsers()
  }
  init(
    _ newOutput: NewOutput,
    @ParserBuilder parsers: () -> Parsers
  )
  where Parsers.Output == Void
  {
    self.init({ newOutput }, parsers: parsers)
  }
  init(
    @ParserBuilder parsers: () -> Parsers
  )
  where Parsers.Output == NewOutput
  {
    self.transform = { $0 }
    self.parsers = parsers()
  }
  func parse(_ input: inout Parsers.Input) -> NewOutput? {
    self.parsers.parse(&input).map(transform)
  }
}

@resultBuilder
enum OneOfBuilder {
  static func buildBlock<P0, P1, P2>(
    _ p0: P0,
    _ p1: P1,
    _ p2: P2
  )
  -> Parsers.OneOf<Parsers.OneOf<P0, P1>, P2>
  where
    P0: Parser,
    P1: Parser,
    P2: Parser
  {
    p0.orElse(p1).orElse(p2)
  }

  static func buildBlock<P0, P1>(
    _ p0: P0,
    _ p1: P1
  )
  -> Parsers.OneOf<P0, P1>
  where
    P0: Parser,
    P1: Parser
  {
    p0.orElse(p1)
  }

  static func buildBlock<P0, P1, P2, P3, P4>(
      _ p0: P0,
      _ p1: P1,
      _ p2: P2,
      _ p3: P3,
      _ p4: P4
    )
    -> Parsers.OneOf<Parsers.OneOf<Parsers.OneOf<Parsers.OneOf<P0, P1>, P2>, P3>, P4>
    {
      p0.orElse(p1).orElse(p2).orElse(p3).orElse(p4)
    }
}

extension Parsers.OneOf {
  init(@OneOfBuilder build: () -> Self) {
    self = build()
  }
}

typealias OneOf = Parsers.OneOf

extension Many where Result == [Element.Output] {
  init(
    @ParserBuilder _ element: () -> Element,
    @ParserBuilder separator: () -> Separator
  ) {
    self.init(element(), separator: separator())
  }
}

extension Skip {
  init(@ParserBuilder build: () -> Upstream) {
    self.init(build())
  }
}
