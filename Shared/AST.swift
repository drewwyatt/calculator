protocol Expression {}

struct Number: Expression {
  let value: Double
}

struct UnaryNegation: Expression {
  let operand: Expression
}

struct Binary: Expression {
  let leftOperand: Expression
  let function: Operator
  let rightOperand: Expression
}
