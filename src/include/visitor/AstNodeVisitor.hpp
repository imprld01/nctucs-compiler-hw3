#ifndef __VISITOR_H
#define __VISITOR_H

// Forward declaration of AST nodes
class ProgramNode;
class DeclNode;
class VariableNode;
class ConstantValueNode;
class FunctionNode;
class CompoundStatementNode;
class PrintNode;
class BinaryOperatorNode;
class UnaryOperatorNode;
class FunctionInvocationNode;
class VariableReferenceNode;
class AssignmentNode;
class ReadNode;
class IfNode;
class WhileNode;
class ForNode;
class ReturnNode;

class AstNodeVisitor {
   public:
    virtual ~AstNodeVisitor() = 0;

    void visit(const AstNode &node);
    virtual void visit(const ProgramNode &p_program) {}
    virtual void visit(const DeclNode &p_decl) {}
    virtual void visit(const VariableNode &p_variable) {}
    virtual void visit(const ConstantValueNode &p_constant_value) {}
    virtual void visit(const FunctionNode &p_function) {}
    virtual void visit(const CompoundStatementNode &p_compound_statement) {}
    virtual void visit(const PrintNode &p_print) {}
    virtual void visit(const BinaryOperatorNode &p_bin_op) {}
    virtual void visit(const UnaryOperatorNode &p_un_op) {}
    virtual void visit(const FunctionInvocationNode &p_func_invocation) {}
    virtual void visit(const VariableReferenceNode &p_variable_ref) {}
    virtual void visit(const AssignmentNode &p_assignment) {}
    virtual void visit(const ReadNode &p_read) {}
    virtual void visit(const IfNode &p_if) {}
    virtual void visit(const WhileNode &p_while) {}
    virtual void visit(const ForNode &p_for) {}
    virtual void visit(const ReturnNode &p_return) {}
};

#endif
