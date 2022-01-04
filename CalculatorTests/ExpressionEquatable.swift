@testable import calculator

protocol ExpressionEquatable {
  func isEqual(to expression: Expression) -> Bool
}

extension Number: ExpressionEquatable {
  func isEqual(to expression: Expression) -> Bool {
    guard let expression = expression as? Number else { return false }
    return self.value == expression.value
  }
}

extension UnaryNegation: ExpressionEquatable {
  func isEqual(to expression: Expression) -> Bool {
    guard
      let expression = expression as? UnaryNegation,
      let firstOperand = operand as? ExpressionEquatable
    else { return false }
    return firstOperand.isEqual(to: expression.operand)
  }
}

extension Binary: ExpressionEquatable {
  func isEqual(to expression: Expression) -> Bool {
    guard
      let expression = expression as? Binary,
      let leftOperand = leftOperand as? ExpressionEquatable,
      let rightOperand = rightOperand as? ExpressionEquatable
    else { return false }

    return leftOperand.isEqual(to: expression.leftOperand) &&
    rightOperand.isEqual(to: expression.rightOperand) &&
    function == expression.function
  }
}
