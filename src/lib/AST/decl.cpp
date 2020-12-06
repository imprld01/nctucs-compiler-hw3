#include "AST/decl.hpp"

DeclNode::DeclNode(const uint32_t line, const uint32_t col, 
                   const char* varName, const char* varType)
    : AstNode{line, col}, varName(varName), varType(varType) {}

void DeclNode::visitedBy(AstNodeVisitor& visitor) const {
    visitor.visit(*this);
}