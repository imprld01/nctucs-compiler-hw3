#include "AST/program.hpp"

#include <string>
using std::string;

ProgramNode::ProgramNode(const uint32_t line,
                         const uint32_t col,
                         const char* p_name)
    : AstNode{line, col}, name(p_name) {}

const char* ProgramNode::getProgramName() const { return name.c_str(); }

void ProgramNode::visitedBy(AstNodeVisitor& visitor) const {
    visitor.visit(*this);
}