#ifndef __AST_PROGRAM_NODE_H
#define __AST_PROGRAM_NODE_H

#include <string>

#include "AST/ast.hpp"
using std::string;

class ProgramNode : public AstNode {
   public:
    ProgramNode(const uint32_t line, const uint32_t col, const char* p_name);
    ~ProgramNode() = default;
    const char* getProgramName() const;
    void visitedBy(AstNodeVisitor& visitor) const override;

   private:
    const std::string name;
};

#endif
