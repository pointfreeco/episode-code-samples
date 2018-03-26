@_exported import Foundation

//public func pow(_ a: UInt, _ b: UInt) -> UInt {
//  return UInt(pow(Double(a), Double(b)))
//}
public func pow(_ a: Int, _ b: Int) -> Int {
  return Int(pow(Double(a), Double(b)))
}

public enum Result<Value, Error> {
  case success(Value)
  case failure(Error)
}

public enum Either<A, B> {
  case left(A)
  case right(B)
}
