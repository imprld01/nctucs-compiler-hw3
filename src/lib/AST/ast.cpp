#include <AST/AstDumper.hpp>
#include <AST/ast.hpp>

AstNode::AstNode(const uint32_t line, const uint32_t col)
    : location(line, col) {}

// prevent the linker from complaining
AstNode::~AstNode() {}

const Location& AstNode::getLocation() const { return location; }

void AstNode::visitChildNodes(AstNodeVisitor& dumper) const {
    for (auto& node : children) dumper.visit(*node);
}

void AstNode::visitedBy(AstNodeVisitor& dumper) const {
    dumper.visit(*this);
}