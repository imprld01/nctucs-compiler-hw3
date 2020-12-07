#ifndef hy_p_scalar_type
#define hy_p_scalar_type
#include <cstring>

enum p_scalar_type {
    P_BOOLEAN,
    P_INT,
    P_REAL,
    P_STRING,
    P_UNKNOWN
};

char* ptoa(p_scalar_type t);

#endif
