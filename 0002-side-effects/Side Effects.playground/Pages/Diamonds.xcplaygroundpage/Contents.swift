// https://www.pointfree.co/episodes/ep2-side-effects

import Foundation

let formatter = NumberFormatter()

func decimalStyle(_ format: NumberFormatter) {
  format.numberStyle = .decimal
  format.maximumFractionDigits = 2
}

//func decimalStyle(_ format: NumberFormatter) -> NumberFormatter {
//  let format = format.copy() as! NumberFormatter
//  format.numberStyle = .decimal
//  format.maximumFractionDigits = 2
//  return format
//}

func currencyStyle(_ format: NumberFormatter) {
  format.numberStyle = .currency
  format.roundingMode = .down
}

func wholeStyle(_ format: NumberFormatter) {
  format.maximumFractionDigits = 0
}

decimalStyle(formatter)
wholeStyle(formatter)
formatter.string(from: 1234.6)

currencyStyle(formatter)
formatter.string(from: 1234.6)

decimalStyle(formatter)
wholeStyle(formatter)
formatter.string(from: 1234.6)


struct NumberFormatterConfig {
  var numberStyle: NumberFormatter.Style = .none
  var roundingMode: NumberFormatter.RoundingMode = .up
  var maximumFractionDigits: Int = 0

  var formatter: NumberFormatter {
    let result = NumberFormatter()
    result.numberStyle = self.numberStyle
    result.roundingMode = self.roundingMode
    result.maximumFractionDigits = self.maximumFractionDigits
    return result
  }
}


func decimalStyle(_ format: NumberFormatterConfig) -> NumberFormatterConfig {
  var format = format
  format.numberStyle = .decimal
  format.maximumFractionDigits = 2
  return format
}

func currencyStyle(_ format: NumberFormatterConfig) -> NumberFormatterConfig {
  var format = format
  format.numberStyle = .currency
  format.roundingMode = .down
  return format
}

decimalStyle >>> currencyStyle

func wholeStyle(_ format: NumberFormatterConfig) -> NumberFormatterConfig {
  var format = format
  format.maximumFractionDigits = 0
  return format
}

wholeStyle(decimalStyle(NumberFormatterConfig()))
  .formatter
  .string(from: 1234.6)

wholeStyle(currencyStyle(NumberFormatterConfig()))
  .formatter
  .string(from: 1234.6)

wholeStyle(decimalStyle(NumberFormatterConfig()))
  .formatter
  .string(from: 1234.6)




func inoutDecimalStyle(_ format: inout NumberFormatterConfig) {
  format.numberStyle = .decimal
  format.maximumFractionDigits = 2
}

func inoutCurrencyStyle(_ format: inout NumberFormatterConfig) {
  format.numberStyle = .currency
  format.roundingMode = .down
}

func inoutWholeStyle(_ format: inout NumberFormatterConfig) {
  format.maximumFractionDigits = 0
}

var config = NumberFormatterConfig()

inoutDecimalStyle(&config)
inoutWholeStyle(&config)
config.formatter.string(from: 1234.6)

inoutCurrencyStyle(&config)
config.formatter.string(from: 1234.6)

inoutDecimalStyle(&config)
inoutWholeStyle(&config)
config.formatter.string(from: 1234.6)

func toInout<A>(_ f: @escaping (A) -> A) -> (inout A) -> Void {
  return { a in
    a = f(a)
  }
}

func fromInout<A>(_ f: @escaping (inout A) -> Void) -> (A) -> A {
  return { a in
    var a = a
    f(&a)
    return a
  }
}

precedencegroup SingleTypeComposition {
  associativity: left
  higherThan: ForwardApplication
}

infix operator <>: SingleTypeComposition

func <> <A>(f: @escaping (A) -> A, g: @escaping (A) -> A) -> (A) -> A {
  return f >>> g
}

func <> <A>(f: @escaping (inout A) -> Void, g: @escaping (inout A) -> Void) -> (inout A) -> Void {
  return { a in
    f(&a)
    g(&a)
  }
}

func |> <A>(a: inout A, f: (inout A) -> Void) {
  f(&a)
}

config |> decimalStyle <> currencyStyle
config |> inoutDecimalStyle <> inoutCurrencyStyle
