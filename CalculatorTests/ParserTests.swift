@testable import calculator
import XCTest

class ParserTests: XCTestCase {
  func testBasicTermParsesCorrectly() throws {
    // 1 + 2
    let tokens: [Token] = [
      .number(1), .plusSign, .number(2), .endOfLine
    ]
    let result = try Parser().parse(tokens: tokens)
    assertIsEqual(result, Binary(leftOperand: Number(value: 1), function: .plus, rightOperand: Number(value: 2)))
  }

  func testExpressionWithMultipleTermsParsesCorrectly() throws {
    // 1 + 2 - 3
    let tokens: [Token] = [
      .number(1), .plusSign, .number(2), .hyphen, .number(3), .endOfLine
    ]
    let result = try Parser().parse(tokens: tokens)
    assertIsEqual(result, Binary(
      leftOperand: Binary(
        leftOperand: Number(value: 1), function: .plus, rightOperand: Number(value: 2)
      ),
      function: .minus,
      rightOperand: Number(value: 3)
    ))
  }

  // test simple factor

  func testExpressionWithTermPrecedingFactorParsesCorrectly() throws {
    // 1 + 2 * 3
    let tokens: [Token] = [
      .number(1), .plusSign, .number(2), .asterisk, .number(3), .endOfLine
    ]
    let result = try Parser().parse(tokens: tokens)
    assertIsEqual(result, Binary(
      leftOperand: Number(value: 1),
      function: .plus,
      rightOperand: Binary(
        leftOperand: Number(value: 2),
        function: .multiply,
        rightOperand: Number(value: 3)
      )
    ))
  }

  // MARK: - Helper functions

  func assertIsEqual(_ firstExpression: Expression, _ secondExpression: Expression, file: StaticString = #filePath, line: UInt = #line) {
    guard let firstExpression = firstExpression as? ExpressionEquatable else {
      return XCTFail(file: file, line: line)
    }
    XCTAssertTrue(firstExpression.isEqual(to: secondExpression), "Expression\n\n\(firstExpression)\n\ndid not match expected expression \n\n\(secondExpression)", file: file, line: line)
  }
}
