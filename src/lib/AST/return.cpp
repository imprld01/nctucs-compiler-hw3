#include "AST/return.hpp"

ReturnNode::ReturnNode(const uint32_t line,
                       const uint32_t col,
                       ExpressionNode* retVal)
    : AstNode{line, col} {
    append(retVal);
}

void ReturnNode::visitedBy(AstNodeVisitor& visitor) const {
    visitor.visit(*this);
}
