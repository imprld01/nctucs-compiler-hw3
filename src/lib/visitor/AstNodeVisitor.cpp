#include <AST/ast.hpp>
#include <visitor/AstNodeVisitor.hpp>

// prevent the linker from complaining
AstNodeVisitor::~AstNodeVisitor() {}

void AstNodeVisitor::visit(const AstNode& node) { node.visitedBy(*this); }