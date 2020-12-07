#ifndef __AST_VARIABLE_NODE_H
#define __AST_VARIABLE_NODE_H

#include <string>

#include "AST/ast.hpp"
#include "utils/p_scalar_type.hpp"

class VariableNode : public AstNode {
   public:
    VariableNode(const uint32_t line, const uint32_t col,
                 const char* varName, const char* varType);
    VariableNode(const uint32_t line, const uint32_t col,
                 const char* varName, const p_scalar_type vt);
    ~VariableNode() = default;
    void visitedBy(AstNodeVisitor& visitor) const override;
    const char* getVarName() const;
    const char* getVarType() const;

   private:
    std::string varName, varType;
};

#endif
