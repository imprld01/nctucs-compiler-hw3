#ifndef __AST_UNARY_OPERATOR_NODE_H
#define __AST_UNARY_OPERATOR_NODE_H

#include "AST/expression.hpp"
#include "utils/p_operator.hpp"

class UnaryOperatorNode : public ExpressionNode {
   public:
    UnaryOperatorNode(const uint32_t line,
                      const uint32_t col,
                      p_unary_operator op,
                      ExpressionNode* operand);
    ~UnaryOperatorNode() = default;

    void visitedBy(AstNodeVisitor& visitor) const override;
    const ExpressionNode& getOperand() const;
    p_unary_operator getOperator() const;

   private:
    p_unary_operator op;
    ExpressionNode* opnd;
};

#endif
