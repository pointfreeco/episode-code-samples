extension Actor {
  public func run<R, Failure: Error>(_ body: @Sendable (isolated Self) throws(Failure) -> R) throws(Failure) -> R {
    try body(self)
  }
}
