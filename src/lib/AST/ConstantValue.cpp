#include "AST/ConstantValue.hpp"

#include <string>

ConstantValueNode::ConstantValueNode(const uint32_t line,
                                     const uint32_t col,
                                     int value,
                                     int data_type)
    : ExpressionNode{line, col}, int_value(value), data_type(data_type) {}

ConstantValueNode::ConstantValueNode(const uint32_t line,
                                     const uint32_t col,
                                     double value)
    : ExpressionNode{line, col}, double_value(value), data_type(T_DOUBLE) {}

ConstantValueNode::ConstantValueNode(const uint32_t line,
                                     const uint32_t col,
                                     const char* value)
    : ExpressionNode{line, col}, string_value(value), data_type(T_STRING) {}

void ConstantValueNode::negate() {
    if (data_type == T_INT)
        int_value = -int_value;
    else if (data_type == T_DOUBLE)
        double_value = -double_value;
}

void ConstantValueNode::visitedBy(AstNodeVisitor& visitor) const {
    visitor.visit(*this);
}

int ConstantValueNode::getDataType() const { return data_type; }
bool ConstantValueNode::boolVal() const { return int_value; }
int ConstantValueNode::intVal() const { return int_value; }
double ConstantValueNode::floatVal() const { return double_value; }
std::string ConstantValueNode::strVal() const { return string_value; }