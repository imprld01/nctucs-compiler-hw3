#include "AST/print.hpp"

PrintNode::PrintNode(const uint32_t line, const uint32_t col)
    : AstNode{line, col} {}

void PrintNode::visitedBy(AstNodeVisitor& visitor) const {
    visitor.visit(*this);
}