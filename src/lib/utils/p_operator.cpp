#include "utils/p_operator.hpp"

const char* poptoa(p_binary_operator op) {
    switch (op) {
    case P_AND:   return "and"; break;
    case P_OR:    return "or";  break;
    case P_PLUS:  return "+";   break;
    case P_MINUS: return "-";   break;
    case P_MUL:   return "*";   break;
    case P_DIV:   return "/";   break;
    case P_MOD:   return "mod"; break;
    case P_EQ:    return "=";   break;
    case P_NE:    return "<>";  break;
    case P_LT:    return "<";   break;
    case P_LE:    return "<=";  break;
    case P_GT:    return ">";   break;
    case P_GE:    return ">=";  break;
    default:      return "unknown";
    }
}

const char* poptoa(p_unary_operator op) {
    switch (op) {
    case P_NOT:   return "not"; break;
    case P_NEG:   return "neg"; break;
    default:      return "unknown";
    }
}