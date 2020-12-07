#include "AST/for.hpp"

ForNode::ForNode(const uint32_t line,
                 const uint32_t col,
                 DeclNode* declNode,
                 AssignmentNode* asgnNode,
                 ConstantValueNode* termNode,
                 CompoundStatementNode* body,
                 int initVal,
                 int termVal)
    : AstNode{line, col}, initVal(initVal), termVal(termVal) {
    append(declNode);
    append(asgnNode);
    append(termNode);
    append(body);
}
