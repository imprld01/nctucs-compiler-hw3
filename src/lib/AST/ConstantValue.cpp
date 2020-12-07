#include "AST/ConstantValue.hpp"

#include <string>

ConstantValueNode::ConstantValueNode(const uint32_t line,
                                     const uint32_t col,
                                     const int value,
                                     const p_scalar_type data_type)
    : ExpressionNode{line, col}, int_value(value), data_type(data_type) {}

ConstantValueNode::ConstantValueNode(const uint32_t line,
                                     const uint32_t col,
                                     const double value,
                                     const p_scalar_type data_type)
    : ExpressionNode{line, col}, double_value(value), data_type(data_type) {}

ConstantValueNode::ConstantValueNode(const uint32_t line,
                                     const uint32_t col,
                                     const char* value,
                                     const p_scalar_type data_type)
    : ExpressionNode{line, col}, string_value(value), data_type(data_type) {}

void ConstantValueNode::visitedBy(AstNodeVisitor& visitor) const {
    visitor.visit(*this);
}

p_scalar_type ConstantValueNode::getDataType() const { return data_type; }
bool ConstantValueNode::boolVal() const { return int_value; }
int ConstantValueNode::intVal() const { return int_value; }
double ConstantValueNode::floatVal() const { return double_value; }
std::string ConstantValueNode::strVal() const { return string_value; }