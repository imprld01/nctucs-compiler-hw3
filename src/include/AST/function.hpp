#ifndef __AST_FUNCTION_NODE_H
#define __AST_FUNCTION_NODE_H

#include <string>
#include <vector>

#include "AST/ast.hpp"
#include "AST/decl.hpp"
#include "utils/p_scalar_type.hpp"

class FunctionNode : public AstNode {
   public:
    FunctionNode(const uint32_t line,
                 const uint32_t col,
                 const char* funcName,
                 const p_scalar_type retType);
    ~FunctionNode() = default;

    void visitedBy(AstNodeVisitor& visitor) const override;
    void addParam(const DeclNode* declNode);

    const char* getFunctionName() const;
    const std::vector<std::string>& getParamsType() const;
    const p_scalar_type getReturnType() const;

   private:
    std::string funcName;
    std::vector<std::string> paramsType;
    p_scalar_type retType;
};

#endif
