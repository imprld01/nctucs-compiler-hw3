#include "AST/assignment.hpp"

AssignmentNode::AssignmentNode(const uint32_t line, const uint32_t col)
    : AstNode{line, col} {}

void AssignmentNode::visitedBy(AstNodeVisitor& visitor) const {
    return visitor.visit(*this);
}