#ifndef __AST_FUNCTION_INVOCATION_NODE_H
#define __AST_FUNCTION_INVOCATION_NODE_H

#include "AST/expression.hpp"

class FunctionInvocationNode : public ExpressionNode {
   public:
    FunctionInvocationNode(const uint32_t line,
                           const uint32_t col,
                           const char* funcName);
    ~FunctionInvocationNode() = default;

    const char* getFunctionName() const;
    void visitedBy(AstNodeVisitor& visitor) const override;

   private:
    std::string funcName;
};

#endif
