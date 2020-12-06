#ifndef __AST_DECL_NODE_H
#define __AST_DECL_NODE_H

#include <string>

#include "AST/ast.hpp"

using std::string;

class DeclNode : public AstNode {
   public:
    // variable declaration
    DeclNode(const uint32_t line, const uint32_t col,
             const char* varName, const char* varType);
    ~DeclNode() = default;
    void visitedBy(AstNodeVisitor& visitor) const;
    const string varName;
    const string varType;
};

#endif
