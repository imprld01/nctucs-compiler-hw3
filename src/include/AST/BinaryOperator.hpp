#ifndef __AST_BINARY_OPERATOR_NODE_H
#define __AST_BINARY_OPERATOR_NODE_H

#include "AST/expression.hpp"
#include "utils/p_operator.hpp"

class BinaryOperatorNode : public ExpressionNode {
   public:
    BinaryOperatorNode(const uint32_t line,
                       const uint32_t co,
                       p_binary_operator op,
                       ExpressionNode* operand_a,
                       ExpressionNode* operand_b);
    ~BinaryOperatorNode() = default;

    const ExpressionNode& getFirstOperand() const;
    const ExpressionNode& getSecondOperand() const;
    p_binary_operator getOperator() const;

    void visitedBy(AstNodeVisitor& visitor) const override;

   private:
    p_binary_operator op;
    ExpressionNode* opnd_a;
    ExpressionNode* opnd_b;
};

#endif
