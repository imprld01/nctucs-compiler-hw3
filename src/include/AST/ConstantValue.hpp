#ifndef __AST_CONSTANT_VALUE_NODE_H
#define __AST_CONSTANT_VALUE_NODE_H

#include <string>

#include "AST/expression.hpp"
#include "utils/p_scalar_type.hpp"

class ConstantValueNode : public ExpressionNode {
   public:
    ConstantValueNode(const uint32_t line,
                      const uint32_t col,
                      const int value,
                      const p_scalar_type data_type);
    ConstantValueNode(const uint32_t line,
                      const uint32_t col,
                      const double value,
                      const p_scalar_type data_type = P_REAL);
    ConstantValueNode(const uint32_t line,
                      const uint32_t col,
                      const char* value,
                      const p_scalar_type datatype = P_STRING);
    ~ConstantValueNode() = default;

    void visitedBy(AstNodeVisitor& visitor) const override;

    p_scalar_type getDataType() const;
    int intVal() const;
    double floatVal() const;
    const char* strVal() const;
    bool boolVal() const;

   private:
    int int_value;
    double double_value;
    std::string string_value;
    p_scalar_type data_type;
};

#endif
