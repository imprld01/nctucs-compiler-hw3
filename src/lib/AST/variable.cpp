#include "AST/variable.hpp"

// TODO
VariableNode::VariableNode(const uint32_t line, const uint32_t col,
                           const char* varName, const char* varType)
    : AstNode{line, col}, varName(varName), varType(varType) {}

VariableNode::VariableNode(const uint32_t line, const uint32_t col,
                           const char* varName, const p_scalar_type vt)
    : AstNode{line, col}, varName(varName) {
        if (vt == P_BOOLEAN) varType = "boolean";
        else if (vt == P_INT) varType = "integer";
        else if (vt == P_REAL) varType = "real";
        else if (vt == P_STRING) varType = "string";
        else varType = "unknown";
    }   

void VariableNode::visitedBy(AstNodeVisitor& visitor) const {
    visitor.visit(*this);
}

const char* VariableNode::getVarName() const { return varName.c_str(); }
const char* VariableNode::getVarType() const { return varType.c_str(); }