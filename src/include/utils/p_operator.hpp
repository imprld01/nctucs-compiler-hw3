#ifndef hp_p_operator
#define hp_p_operator

enum p_binary_operator {
    P_AND,
    P_OR,
    P_EQ,
    P_NE,
    P_LT,
    P_LE,
    P_GT,
    P_GE,
    P_PLUS,
    P_MINUS,
    P_MUL,
    P_DIV,
    P_MOD,
    P_BINARY_UNKNOWN
};

enum p_unary_operator {
    P_NEG,
    P_NOT,
    P_UNARY_UNKNOWN
};

const char* poptoa(p_binary_operator);
const char* poptoa(p_unary_operator);

#endif