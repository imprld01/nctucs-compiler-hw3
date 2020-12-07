#ifndef __AST_FOR_NODE_H
#define __AST_FOR_NODE_H

#include "AST/CompoundStatement.hpp"
#include "AST/ConstantValue.hpp"
#include "AST/assignment.hpp"
#include "AST/ast.hpp"
#include "AST/decl.hpp"

class ForNode : public AstNode {
   public:
    ForNode(const uint32_t line,
            const uint32_t col,
            DeclNode* declNode,
            AssignmentNode* asgnNode,
            ConstantValueNode* termNode,
            CompoundStatementNode* body,
            int initVal,
            int termVal);
    ~ForNode() = default;

    int getInitVal() const;
    int getTermVal() const;

    void visitedBy(AstNodeVisitor& visitor) const {
        visitor.visit(*this);
    }

   private:
    int initVal, termVal;
};

#endif
