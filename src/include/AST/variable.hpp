#ifndef __AST_VARIABLE_NODE_H
#define __AST_VARIABLE_NODE_H

#include <string>

#include "AST/ast.hpp"

class VariableNode : public AstNode {
   public:
    VariableNode(const uint32_t line, const uint32_t col,
                 const char* varName, const char* varType);
    ~VariableNode() = default;
    void visitedBy(AstNodeVisitor& visitor) const override;
    std::string getVarName() const;
    std::string getVarType() const;

   private:
    std::string varName, varType;
};

#endif
