#include "AST/UnaryOperator.hpp"

UnaryOperatorNode::UnaryOperatorNode(const uint32_t line,
                                     const uint32_t col,
                                     p_unary_operator op,
                                     ExpressionNode* operand)
    : ExpressionNode{line, col}, op(op), opnd(operand) {
    append((AstNode*)opnd);
}

p_unary_operator UnaryOperatorNode::getOperator() const {
    return op;
}

const ExpressionNode& UnaryOperatorNode::getOperand() const {
    return *opnd;
}

void UnaryOperatorNode::visitedBy(AstNodeVisitor& visitor) const {
    visitor.visit(*this);
}
