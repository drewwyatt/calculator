extension Token {
  var number: Double? {
    switch self {
    case .number(let value):
      return value
    case .leftParen, .rightParen, .asterisk, .forwardSlash, .plusSign, .hyphen, .endOfLine:
      return nil
    }
  }
  
  var isNumber: Bool {
    number != nil
  }
}

extension Operator {
  init?(token: Token) {
    switch token {
    case .asterisk:
      self = .multiply
    case .forwardSlash:
      self = .divide
    case .plusSign:
      self = .plus
    case .hyphen:
      self = .minus
    case .number, .leftParen, .rightParen, .endOfLine:
      return nil
    }
  }
  
  var isTerm: Bool {
    switch self {
    case .plus, .minus:
      return true
    case .divide, .multiply:
      return false
    }
  }
  
  var isFactor: Bool {
    switch self {
    case .divide, .multiply:
      return true
    case .plus, .minus:
      return false
    }
  }
}
