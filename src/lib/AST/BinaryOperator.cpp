#include "AST/BinaryOperator.hpp"

BinaryOperatorNode::BinaryOperatorNode(const uint32_t line,
                                       const uint32_t col,
                                       p_binary_operator op,
                                       ExpressionNode* operand_a,
                                       ExpressionNode* operand_b)
    : ExpressionNode{line, col}, op(op), opnd_a(operand_a), opnd_b(operand_b) {
    append((AstNode*)operand_a);
    append((AstNode*)operand_b);
}

p_binary_operator BinaryOperatorNode::getOperator() const {
    return op;
}

const ExpressionNode& BinaryOperatorNode::getFirstOperand() const {
    return *opnd_a;
}

const ExpressionNode& BinaryOperatorNode::getSecondOperand() const {
    return *opnd_b;
}

void BinaryOperatorNode::visitedBy(AstNodeVisitor& visitor) const {
    visitor.visit(*this);
}
