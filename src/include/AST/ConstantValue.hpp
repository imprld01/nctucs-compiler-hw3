#ifndef __AST_CONSTANT_VALUE_NODE_H
#define __AST_CONSTANT_VALUE_NODE_H

#include <string>

#include "AST/expression.hpp"

const int T_BOOL = 0;
const int T_STRING = 1;
const int T_INT = 2;
const int T_DOUBLE = 3;

class ConstantValueNode : public ExpressionNode {
   public:
    ConstantValueNode(const uint32_t line, const uint32_t col, int value, int data_type);
    ConstantValueNode(const uint32_t line, const uint32_t col, double value);
    ConstantValueNode(const uint32_t line, const uint32_t col, const char* value);
    ~ConstantValueNode() = default;
    
    void negate();

    void visitedBy(AstNodeVisitor& visitor) const override;

    int getDataType() const;
    int intVal() const;
    double floatVal() const;
    std::string strVal() const;
    bool boolVal() const;

   private:
    int int_value;
    double double_value;
    std::string string_value;
    int data_type;
};

#endif
