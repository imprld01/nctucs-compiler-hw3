#include "AST/variable.hpp"

// TODO
VariableNode::VariableNode(const uint32_t line, const uint32_t col,
                           const char* varName, const char* varType)
    : AstNode{line, col}, varName(varName), varType(varType) {}

void VariableNode::visitedBy(AstNodeVisitor& visitor) const {
    visitor.visit(*this);
}

std::string VariableNode::getVarName() const { return varName; }
std::string VariableNode::getVarType() const { return varType; }