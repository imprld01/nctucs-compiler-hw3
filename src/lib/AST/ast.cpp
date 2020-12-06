#include <stdio.h>

#include <AST/AstDumper.hpp>
#include <AST/ast.hpp>

AstNode::AstNode(const uint32_t line, const uint32_t col)
    : location(line, col) {}

// prevent the linker from complaining
AstNode::~AstNode() {}

Location AstNode::getLocation() const { return location; }

void AstNode::visitChildNodes(AstNodeVisitor& dumper) const {
    for (AstNode* node : children) {
        dumper.visit(*node);
    }
}

void AstNode::append(AstNode* node) {
    children.push_back(node);
}