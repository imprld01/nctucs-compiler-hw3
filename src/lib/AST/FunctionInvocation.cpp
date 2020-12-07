#include "AST/FunctionInvocation.hpp"

FunctionInvocationNode::FunctionInvocationNode(const uint32_t line,
                                               const uint32_t col,
                                               const char* funcName)
    : ExpressionNode{line, col}, funcName(funcName) {}

void FunctionInvocationNode::visitedBy(AstNodeVisitor& visitor) const {
    visitor.visit(*this);
}

const char* FunctionInvocationNode::getFunctionName() const {
    return funcName.c_str();
}
