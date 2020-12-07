#ifndef __AST_WHILE_NODE_H
#define __AST_WHILE_NODE_H

#include "AST/CompoundStatement.hpp"
#include "AST/ast.hpp"
#include "AST/expression.hpp"

class WhileNode : public AstNode {
   public:
    WhileNode(const uint32_t line,
              const uint32_t col,
              ExpressionNode* condition,
              CompoundStatementNode* body);
    ~WhileNode() = default;

    void visitedBy(AstNodeVisitor& visitor) const;
    ExpressionNode* getCondition() const;
    CompoundStatementNode* getBody() const;

   private:
    ExpressionNode* condition;
    CompoundStatementNode* body;
};

#endif
