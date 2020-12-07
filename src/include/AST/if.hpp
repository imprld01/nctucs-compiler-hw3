#ifndef __AST_IF_NODE_H
#define __AST_IF_NODE_H

#include "AST/CompoundStatement.hpp"
#include "AST/ast.hpp"
#include "AST/expression.hpp"

class IfNode : public AstNode {
   public:
    IfNode(const uint32_t line,
           const uint32_t col,
           ExpressionNode* condition,
           CompoundStatementNode* ifBody,
           CompoundStatementNode* elseBody = NULL);
    ~IfNode() = default;
    
    void visitedBy(AstNodeVisitor& visitor) const;

    ExpressionNode* getCondition() const;
    CompoundStatementNode* getBody() const;
    CompoundStatementNode* getElseBody() const;

   private:
    ExpressionNode* condition;
    CompoundStatementNode* ifBody;
    CompoundStatementNode* elseBody;
};

#endif
