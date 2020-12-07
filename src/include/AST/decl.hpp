#ifndef __AST_DECL_NODE_H
#define __AST_DECL_NODE_H

#include <string>

#include "AST/ast.hpp"

using std::string;

class DeclNode : public AstNode {
   public:
    // variable declaration
    DeclNode(const uint32_t line, const uint32_t col);
    ~DeclNode() = default;
    void visitedBy(AstNodeVisitor& visitor) const;
};

#endif
