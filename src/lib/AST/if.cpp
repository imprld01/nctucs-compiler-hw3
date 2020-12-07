#include "AST/if.hpp"

IfNode::IfNode(const uint32_t line,
               const uint32_t col,
               ExpressionNode* condition,
               CompoundStatementNode* ifBody,
               CompoundStatementNode* elseBody)
    : AstNode{line, col}, condition(condition), ifBody(ifBody), elseBody(elseBody) {
    append(condition);
    append(ifBody);
    if (elseBody) append(elseBody);
}

void IfNode::visitedBy(AstNodeVisitor& visitor) const {
    visitor.visit(*this);
}

ExpressionNode* IfNode::getCondition() const {
    return condition;
}

CompoundStatementNode* IfNode::getBody() const {
    return ifBody;
}

CompoundStatementNode* IfNode::getElseBody() const {
    return elseBody;
}