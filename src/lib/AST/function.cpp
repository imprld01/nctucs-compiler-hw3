#include "AST/function.hpp"

#include "AST/decl.hpp"
#include "AST/variable.hpp"

FunctionNode::FunctionNode(const uint32_t line,
                           const uint32_t col,
                           const char* funcName,
                           const p_scalar_type retType)
    : AstNode{line, col}, funcName(funcName), retType(retType) {}

void FunctionNode::addParam(const DeclNode* _declNode) {
    AstNode* declNode = (AstNode*)_declNode;
    for (const AstNode* _varNode : declNode->getChildren()) {
        const VariableNode* varNode = (VariableNode*)_varNode;
        paramsType.push_back(varNode->getVarType());
    }
    append((AstNode*)_declNode);
}

void FunctionNode::visitedBy(AstNodeVisitor& visitor) const {
    visitor.visit(*this);
}

const char* FunctionNode::getFunctionName() const {
    return funcName.c_str();
}

const std::vector<std::string>& FunctionNode::getParamsType() const {
    return paramsType;
}

const p_scalar_type FunctionNode::getReturnType() const {
    return retType;
}
