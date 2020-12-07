#include "AST/while.hpp"

WhileNode::WhileNode(const uint32_t line,
                     const uint32_t col,
                     ExpressionNode* condition,
                     CompoundStatementNode* body)
    : AstNode{line, col}, condition(condition), body(body) {
    append(condition);
    append(body);
}

void WhileNode::visitedBy(AstNodeVisitor& visitor) const {
    visitor.visit(*this);
}

ExpressionNode* WhileNode::getCondition() const {
    return condition;
}

CompoundStatementNode* WhileNode::getBody() const {
    return body;
}
