enum Validated<Valid, Invalid> {
  case valid(Valid)
  case invalid([Invalid])
}
