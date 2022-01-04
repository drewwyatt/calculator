enum Token: Equatable {
  case number(Double)
  case leftParen
  case rightParen
  case asterisk
  case forwardSlash
  case plusSign
  case hyphen
  case endOfLine
}

enum Operator {
  case multiply
  case divide
  case plus
  case minus
}
