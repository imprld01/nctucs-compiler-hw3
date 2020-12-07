#include "AST/VariableReference.hpp"

// TODO
VariableReferenceNode::VariableReferenceNode(const uint32_t line,
                                             const uint32_t col,
                                             const char* varName)
    : ExpressionNode{line, col}, varName(varName) {}

const char* VariableReferenceNode::getVarName() const {
    return varName.c_str();
}

void VariableReferenceNode::visitedBy(AstNodeVisitor& visitor) const {
    visitor.visit(*this);
}
