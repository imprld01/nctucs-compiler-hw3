#ifndef __AST_VARIABLE_REFERENCE_NODE_H
#define __AST_VARIABLE_REFERENCE_NODE_H

#include "AST/expression.hpp"

class VariableReferenceNode : public ExpressionNode {
   public:
    // normal reference
    VariableReferenceNode(const uint32_t line,
                          const uint32_t col,
                          const char* varName);
    ~VariableReferenceNode() = default;
    const char* getVarName() const;
    void visitedBy(AstNodeVisitor& visitor) const;

   private:
    std::string varName;
};

#endif
