#ifndef __AST_DUMPER_H
#define __AST_DUMPER_H

#include "visitor/AstNodeVisitor.hpp"

#include <cstdint>

class AstDumper : public AstNodeVisitor {
  public:
    AstDumper() = default;
    ~AstDumper() = default;

    void visit(const ProgramNode &p_program) override;
    void visit(const DeclNode &p_decl) override;
    void visit(const VariableNode &p_variable) override;
    void visit(const ConstantValueNode &p_constant_value) override;
    void visit(const FunctionNode &p_function) override;
    void visit(const CompoundStatementNode &p_compound_statement) override;
    void visit(const PrintNode &p_print) override;
    void visit(const BinaryOperatorNode &p_bin_op) override;
    void visit(const UnaryOperatorNode &p_un_op) override;
    void visit(const FunctionInvocationNode &p_func_invocation) override;
    void visit(const VariableReferenceNode &p_variable_ref) override;
    void visit(const AssignmentNode &p_assignment) override;
    void visit(const ReadNode &p_read) override;
    void visit(const IfNode &p_if) override;
    void visit(const WhileNode &p_while) override;
    void visit(const ForNode &p_for) override;
    void visit(const ReturnNode &p_return) override;

  private:
    void incrementIndentation();
    void decrementIndentation();

  private:
    const uint32_t m_indentation_stride = 2u;
    uint32_t m_indentation = 0u;
};

#endif
