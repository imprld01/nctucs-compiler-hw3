#ifndef __AST_RETURN_NODE_H
#define __AST_RETURN_NODE_H

#include "AST/ast.hpp"
#include "AST/expression.hpp"

class ReturnNode : public AstNode {
   public:
    ReturnNode(const uint32_t line,
               const uint32_t col,
               ExpressionNode* retVal);
    ~ReturnNode() = default;

    void visitedBy(AstNodeVisitor& visitor) const;

   private:
};

#endif
