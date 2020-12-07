#include "utils/p_scalar_type.hpp"

const char* ptoa(p_scalar_type t) {
    switch (t) {
    case P_BOOLEAN: return "boolean"; break;
    case P_INT:     return "integer"; break;
    case P_REAL:    return "real";    break;
    case P_STRING:  return "string";  break;
    case P_VOID:    return "void";    break;
    default:        return "unknown"; break;
    }
}