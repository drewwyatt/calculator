enum ParserError: Error {
  case expectedValidOperator(found: Token)
  case expectedNumber(found: Token)
  case expectedToken(Token, found: Token)
  case unexpectedToken(Token)
}

final class Parser {
  private var tokens: [Token] = []
  private var currentTokenIndex: Int = 0
  
  init() {}
  
  /// Parse a provided list of tokens into an expression
  func parse(tokens: [Token]) throws -> Expression {
    precondition(tokens.last == .endOfLine)
    
    self.tokens = tokens
    self.currentTokenIndex = 0
    
    let expression = try parseExpression()
    guard currentToken == .endOfLine else {
      throw ParserError.unexpectedToken(currentToken)
    }
    return expression
  }
  
  // MARK: - Production rules
  
  // 1 + 2 2
  private func parseExpression() throws -> Expression {
    try parseTerm()
  }
  
  private func parseTerm() throws -> Expression {
    var result = try parseFactor()
    
    while match(.hyphen) || match(.plusSign) {
      let function = try validOperator(from: previousToken, isValid: \.isTerm)
      let rightOperand = try parseFactor()
      result = Binary(
        leftOperand: result,
        function: function,
        rightOperand: rightOperand
      )
    }
    
    return result
  }
  
  private func parseFactor() throws -> Expression {
    var result = try parseUnary()
    
    while match(.forwardSlash) || match(.asterisk) {
      let function = try validOperator(from: previousToken, isValid: \.isFactor)
      let rightOperand = try parseUnary()
      result = Binary(
        leftOperand: result,
        function: function,
        rightOperand: rightOperand
      )
    }
    
    return result
  }
  
  private func parseUnary() throws -> Expression {
    if match(.hyphen) {
      return UnaryNegation(
        operand: try parseUnary()
      )
    } else {
      return try parsePrimary()
    }
  }
  
  private func parsePrimary() throws -> Expression {
    if match(.leftParen) {
      let expression = try parseExpression()
      try consume(.rightParen)
      return expression
    } else if match(\.isNumber) {
      let number = try validNumber(from: previousToken)
      return Number(value: number)
    } else {
      throw ParserError.unexpectedToken(currentToken)
    }
  }
  
  // MARK: - Utility functions
  
  private var isAtEnd: Bool {
    tokens[currentTokenIndex] == .endOfLine
  }
  
  private var previousToken: Token {
    tokens[currentTokenIndex - 1]
  }
  
  private var currentToken: Token {
    tokens[currentTokenIndex]
  }
  
  private func match(_ isValid: (Token) -> Bool) -> Bool {
    guard !isAtEnd && isValid(currentToken) else {
      return false
    }
    
    currentTokenIndex += 1
    return true
  }
  
  private func match(_ token: Token) -> Bool {
    match { $0 == token }
  }
  
  @discardableResult
  private func consume(_ token: Token) throws -> Token {
    guard match(token) else {
      throw ParserError.expectedToken(token, found: currentToken)
    }
    return previousToken
  }
  
  private func validOperator(from token: Token, isValid: (Operator) -> Bool) throws -> Operator {
    guard
      let function = Operator(token: token),
      isValid(function)
    else {
      throw ParserError.expectedValidOperator(found: previousToken)
    }
    return function
  }
  
  private func validNumber(from token: Token) throws -> Double {
    guard let number = token.number else {
      throw ParserError.expectedNumber(found: token)
    }
    return number
  }
}
