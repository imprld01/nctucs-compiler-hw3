#ifndef __AST_FUNCTION_NODE_H
#define __AST_FUNCTION_NODE_H

#include <string>
#include <vector>

#include "AST/ast.hpp"
#include "utils/p_scalar_type.hpp"

class FunctionNode : public AstNode {
   public:
    FunctionNode(const uint32_t line,
                 const uint32_t col,
                 const char* funcName,
                 const std::vector<int>& paramsType,
                 const p_scalar_type retType);
    ~FunctionNode() = default;
    void visitedBy(AstNodeVisitor& visitor) const override;
    
    const std::string& getFunctionName() const;
    const std::vector<int>& getParamsType() const;
    const int getReturnType() const;

   private:
    std::string funcName;
    std::vector<int> paramsType;
    int retType;
};

#endif
