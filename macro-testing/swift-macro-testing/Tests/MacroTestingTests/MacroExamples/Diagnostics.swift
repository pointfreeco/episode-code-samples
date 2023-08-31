import SwiftSyntax
import SwiftDiagnostics

struct SimpleDiagnosticMessage: DiagnosticMessage, Error {
  let message: String
  let diagnosticID: MessageID
  let severity: DiagnosticSeverity
}

extension SimpleDiagnosticMessage: FixItMessage {
  var fixItID: MessageID { diagnosticID }
}

enum CustomError: Error, CustomStringConvertible {
   case message(String)

   var description: String {
     switch self {
     case .message(let text):
       return text
     }
   }
 }
