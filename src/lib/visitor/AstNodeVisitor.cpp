#include <AST/ast.hpp>
#include <visitor/AstNodeVisitor.hpp>

// prevent the linker from complaining
AstNodeVisitor::~AstNodeVisitor() {}

void AstNodeVisitor::visit(AstNode& node) { node.visitedBy(*this); }