#ifndef __AST_ASSIGNMENT_NODE_H
#define __AST_ASSIGNMENT_NODE_H

#include "AST/ast.hpp"

class AssignmentNode : public AstNode {
   public:
    AssignmentNode(const uint32_t line, const uint32_t col);
    ~AssignmentNode() = default;
    void visitedBy(AstNodeVisitor& visitor) const;

   private:
    // TODO: variable reference, expression
};

#endif
