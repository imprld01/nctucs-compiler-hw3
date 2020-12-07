#include "AST/read.hpp"

ReadNode::ReadNode(const uint32_t line, const uint32_t col)
    : AstNode{line, col} {}

void ReadNode::visitedBy(AstNodeVisitor& visitor) const {
    visitor.visit(*this);
}