#include "AST/decl.hpp"

DeclNode::DeclNode(const uint32_t line, const uint32_t col)
    : AstNode{line, col} {}

void DeclNode::visitedBy(AstNodeVisitor& visitor) const {
    visitor.visit(*this);
}