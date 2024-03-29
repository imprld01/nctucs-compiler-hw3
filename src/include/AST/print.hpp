#ifndef __AST_PRINT_NODE_H
#define __AST_PRINT_NODE_H

#include "AST/ast.hpp"

class PrintNode : public AstNode {
   public:
    PrintNode(const uint32_t line, const uint32_t col);
    ~PrintNode() = default;
    void visitedBy(AstNodeVisitor& visitor) const override;

   private:
    // TODO: expression
};

#endif
