import Parsing

enum TransactionKind: String, CaseIterable {
  case credit = "CREDIT"
  case debit = "DEBIT"
}

struct Date {
  var month, day, year: Int
  //  init?(mmddyyyy: String) { ... }
}

struct Amount {
  var valueTimes100: Int
  //  init?(twoDecimalPlaces text: Substring) { ... }
}

struct Transaction {
  let kind: TransactionKind
  let date: Date
  let description: String
  let amount: Amount
}

try ParsePrint
{
  ParsePrint(.memberwise(Date.init(month:day:year:))) {
    Digits(2)
    Digits(2)
    Digits(4)
  }
  Whitespace(1..., .horizontal).printing("\t")
}
.print(Date(month: 4, day: 20, year: 2022))

let transaction = ParsePrint(.memberwise(Transaction.init)) {
  // Parse the transaction kind.
  ParsePrint {
    TransactionKind.parser()
    Whitespace(1..., .horizontal).printing("\t".utf8)
  }
  // Parse the date, e.g. "01012021".
  ParsePrint {
    ParsePrint(.memberwise(Date.init(month:day:year:))) {
      Digits(2)
      Digits(2)
      Digits(4)
    }
    Whitespace(1..., .horizontal).printing("\t".utf8)
  }
  // Parse the transaction description, e.g. "ACH transfer".
  ParsePrint {
    Consumed {
      Many(1...) {
        From(.substring) {
          Prefix(1...) { $0.isLetter || $0.isNumber }
        }
      } separator: {
        Whitespace(1..., .horizontal)
      }
    }
    .map(.string)
    Whitespace(1..., .horizontal).printing("\t".utf8)
  }
  // Parse the amount, e.g. `$100.00`.
  ParsePrint(
    .convert(
      apply: { dollars, cents in
        Amount(valueTimes100: dollars*100 + cents)
      },
      unapply: { amount in
        amount.valueTimes100.quotientAndRemainder(dividingBy: 100)
      }
    )
  ) {
    "$".utf8
    Digits()
    ".".utf8
    Digits(2)
  }
}

try transaction.print(Transaction(kind: .credit, date: Date(month: 4, day: 20, year: 2022), description: "Point-Free", amount: Amount(valueTimes100: 18_00)))

320.quotientAndRemainder(dividingBy: 100)

let statement = Many {
  transaction
} separator: {
  "\n".utf8
}

let input = """
  CREDIT    04062020    PayPal transfer    $4.99
  CREDIT    04032020    Payroll March      $69.73
  DEBIT     04022020    ACH transfer       $38.25
  DEBIT     03242020    IRS tax payment    $52249.98
  """

let output = try statement.parse(input) as [Transaction]
print(try statement.print(output))
