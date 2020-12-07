#include "utils/p_scalar_type.hpp"

char* ptoa(p_scalar_type t) {
    switch (t) {
    case P_BOOLEAN: return strdup("boolean"); break;
    case P_INT:     return strdup("integer"); break;
    case P_REAL:    return strdup("real");    break;
    case P_STRING:  return strdup("string");  break;
    default: return strdup("unknwon");
    }
}