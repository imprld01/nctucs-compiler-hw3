%{
#include "AST/ast.hpp"
#include "AST/program.hpp"
#include "AST/decl.hpp"
#include "AST/variable.hpp"
#include "AST/ConstantValue.hpp"
#include "AST/function.hpp"
#include "AST/CompoundStatement.hpp"
#include "AST/print.hpp"
#include "AST/expression.hpp"
#include "AST/BinaryOperator.hpp"
#include "AST/UnaryOperator.hpp"
#include "AST/FunctionInvocation.hpp"
#include "AST/VariableReference.hpp"
#include "AST/assignment.hpp"
#include "AST/read.hpp"
#include "AST/if.hpp"
#include "AST/while.hpp"
#include "AST/for.hpp"
#include "AST/return.hpp"
#include "AST/AstDumper.hpp"

#include <cassert>
#include <cstdlib>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <string>
#include <vector>
#define YYLTYPE yyltype

using std::vector;
using std::string;

typedef struct YYLTYPE {
    uint32_t first_line;
    uint32_t first_column;
    uint32_t last_line;
    uint32_t last_column;
} yyltype;

/* Declared by scanner.l */
extern uint32_t line_num;
extern char buffer[512];
extern FILE *yyin;
extern char *yytext;
/* End */

static AstNode *root;
static AstDumper dumper;

extern "C" int yylex(void);
static void yyerror(const char *msg);
extern int yylex_destroy(void);
%}

%code requires { #include "AST/ast.hpp" }
%code requires { #include "AST/program.hpp" }
%code requires { #include "AST/decl.hpp" }
%code requires { #include "AST/variable.hpp" }
%code requires { #include "AST/ConstantValue.hpp" }
%code requires { #include "AST/function.hpp" }
%code requires { #include "AST/CompoundStatement.hpp" }
%code requires { #include "AST/print.hpp" }
%code requires { #include "AST/expression.hpp" }
%code requires { #include "AST/BinaryOperator.hpp" }
%code requires { #include "AST/UnaryOperator.hpp" }
%code requires { #include "AST/FunctionInvocation.hpp" }
%code requires { #include "AST/VariableReference.hpp" }
%code requires { #include "AST/assignment.hpp" }
%code requires { #include "AST/read.hpp" }
%code requires { #include "AST/if.hpp" }
%code requires { #include "AST/while.hpp" }
%code requires { #include "AST/for.hpp" }
%code requires { #include "AST/return.hpp" }
%code requires { #include "AST/AstDumper.hpp" }
%code requires { 
    struct idlocation {
        uint32_t first_line;
        uint32_t first_column;
        char* id;
    };
}

    /* For yylval */
%union {
    /* basic semantic value */
    int                         int_type;
    double                      float_type;
    char*                       string_type;
    
    std::vector<char*>*         string_list;
    std::vector<idlocation>*    id_list;
    std::vector<AstNode*>*      node_list;

    AstNode*                    node;
    CompoundStatementNode*      comp_stmt_node;
    ConstantValueNode*          const_val_node;
    DeclNode*                   decl_node;
};

%type <int_type>        NegOrNot INT_LITERAL
%type <float_type>      REAL_LITERAL
%type <string_type>     ProgramName ID Type ScalarType STRING_LITERAL TRUE FALSE ArrDecl ArrType

%type <comp_stmt_node>  CompoundStatement
%type <const_val_node>  LiteralConstant IntegerAndReal StringAndBoolean
%type <decl_node>       Declaration

%type <id_list>         IdList
%type <node_list>       DeclarationList Declarations FunctionList StatementList


    /* Delimiter */
%token COMMA SEMICOLON COLON
%token L_PARENTHESIS R_PARENTHESIS
%token L_BRACKET R_BRACKET

    /* Operator */
%token ASSIGN
%left OR
%left AND
%right NOT
%left LESS LESS_OR_EQUAL EQUAL GREATER GREATER_OR_EQUAL NOT_EQUAL
%left PLUS MINUS
%left MULTIPLY DIVIDE MOD
%right UNARY_MINUS

    /* Keyword */
%token ARRAY BOOLEAN INTEGER REAL STRING
%token END BEGIN_ /* Use BEGIN_ since BEGIN is a keyword in lex */
%token DO ELSE FOR IF THEN WHILE
%token DEF OF TO RETURN VAR
%token FALSE TRUE
%token PRINT READ

    /* Identifier */
%token ID

    /* Literal */
%token INT_LITERAL
%token REAL_LITERAL
%token STRING_LITERAL

%%
    /*
       Program Units
                     */

Program:
    ProgramName SEMICOLON
    /* ProgramBody */
    DeclarationList FunctionList CompoundStatement
    /* End of ProgramBody */
    END {
        root = new ProgramNode(@1.first_line, @1.first_column, $1);
        
        for (AstNode* node: *$3) root->append(node);
        free($3);
        
        // for (AstNode* node: *$4) root->append(node);
        root->append($5);
        
        //free($4);
    }
;

ProgramName:
    ID { 
        $$ = strdup($1); 
        free($1);
    }
;

DeclarationList:
    Epsilon { $$ = new vector<AstNode*>(); }
    |
    Declarations
;

Declarations:
    Declaration {
        $$ = new vector<AstNode*>();
        $$->push_back($1);
    }
    |
    Declarations Declaration {
        $1->push_back($2);
        $$ = $1;
    }
;

FunctionList:
    Epsilon {
        $$ = new vector<AstNode*>();
    }
    |
    Functions {
        $$ = new vector<AstNode*>();
    }
;

Functions:
    Function
    |
    Functions Function
;

Function:
    FunctionDeclaration
    |
    FunctionDefinition
;

FunctionDeclaration:
    FunctionName L_PARENTHESIS FormalArgList R_PARENTHESIS ReturnType SEMICOLON
;

FunctionDefinition:
    FunctionName L_PARENTHESIS FormalArgList R_PARENTHESIS ReturnType
    CompoundStatement
    END
;

FunctionName:
    ID
;

FormalArgList:
    Epsilon
    |
    FormalArgs
;

FormalArgs:
    FormalArg
    |
    FormalArgs SEMICOLON FormalArg
;

FormalArg:
    IdList COLON Type
;

IdList:
    ID {
        $$ = new vector<idlocation>();
        $$->push_back({@1.first_line, @1.first_column, strdup($1)});
        free($1);
    }
    |
    IdList COMMA ID {
        $1->push_back({@3.first_line, @3.first_column, strdup($3)});
        $$ = $1;
        free($3);
    }
;

ReturnType:
    COLON ScalarType
    |
    Epsilon
;

    /*
       Data Types and Declarations
                                   */

Declaration:
    VAR IdList COLON Type SEMICOLON {
        $$ = new DeclNode(@1.first_line, @1.first_column);
        for (const idlocation& p: *$2) {
            $$->append(new VariableNode(p.first_line, p.first_column, p.id, $4));
        }
        free($4);
    }
    |
    VAR IdList COLON LiteralConstant SEMICOLON {
        $$ = new DeclNode(@1.first_line, @1.first_column);
        for (const idlocation& p: *$2) {
            char* varType;
            switch ($4->getDataType()) {
            case T_BOOL:   varType = strdup("boolean"); break;
            case T_INT:    varType = strdup("integer"); break;
            case T_DOUBLE: varType = strdup("real");    break;
            case T_STRING: varType = strdup("string");  break;
            }
            VariableNode* varNode = new VariableNode(p.first_line, 
                                                     p.first_column, 
                                                     p.id, 
                                                     varType);
            varNode->append($4);
            $$->append(varNode);
            free(varType);
        }
    }
;

Type:
    ScalarType
    |
    ArrType
;

ScalarType:
    INTEGER { $$ = strdup("integer"); }
    |
    REAL    { $$ = strdup("real");    }
    |
    STRING  { $$ = strdup("string");  }
    |
    BOOLEAN { $$ = strdup("boolean"); }
;

ArrType:
    ArrDecl ScalarType {
        char* ret = (char*) malloc(strlen($2) + 1 + strlen($1) + 1);
        sprintf(ret, "%s %s", $2, $1);
        free($1);
        free($2);
        $$ = ret;
    }
;

ArrDecl:
    ARRAY INT_LITERAL OF {
        char* ret = (char*) malloc(64);
        sprintf(ret, "[%d]", $2);
        $$ = ret;
    }
    |
    ArrDecl ARRAY INT_LITERAL OF {
        char* ret = (char*) malloc(sizeof($1) + 64);
        sprintf(ret, "%s[%d]", $1, $3);
        free($1);
        $$ = ret;
    }
;

LiteralConstant:
    NegOrNot INT_LITERAL {
        if ($1) {
            $$ = new ConstantValueNode(@1.first_line, @1.first_column, -$2, T_INT);
        }
        else {
            $$ = new ConstantValueNode(@2.first_line, @2.first_column, $2, T_INT);
        }
    }
    |
    NegOrNot REAL_LITERAL {
        if ($1) {
            $$ = new ConstantValueNode(@1.first_line, @1.first_column, -$2);
        }
        else {
            $$ = new ConstantValueNode(@2.first_line, @2.first_column, $2);
        }
    }
    |
    StringAndBoolean
;

NegOrNot:
    Epsilon {
        $$ = 0;
    }
    |
    MINUS %prec UNARY_MINUS {
        $$ = 1;
    }
;

StringAndBoolean:
    STRING_LITERAL {
        // remove quotes
        char* str = strdup($1);
        str[strlen(str) - 1] = '\0';
        $$ = new ConstantValueNode(@1.first_line, @1.first_column, str + 1);
        free($1);
        free(str);
    }
    |
    TRUE {
        $$ = new ConstantValueNode(@1.first_line, @1.first_column, 1, T_BOOL);
    }
    |
    FALSE {
        $$ = new ConstantValueNode(@1.first_line, @1.first_column, 0, T_BOOL);
    }
;

IntegerAndReal:
    INT_LITERAL {
        $$ = new ConstantValueNode(@1.first_line, @1.first_column, $1, T_INT);
    }
    |
    REAL_LITERAL {
        $$ = new ConstantValueNode(@1.first_line, @1.first_column, $1);
    }
;

    /*
       Statements
                  */

Statement:
    CompoundStatement
    |
    Simple
    |
    Condition
    |
    While
    |
    For
    |
    Return
    |
    FunctionCall
;

CompoundStatement:
    BEGIN_
    DeclarationList
    StatementList
    END {
        $$ = new CompoundStatementNode(@1.first_line, @1.first_column);
        for (AstNode* node: *$2) $$->append(node);
        // for (AstNode* node: *$3) $$->append(node);
    }
;

Simple:
    VariableReference ASSIGN Expression SEMICOLON
    |
    PRINT Expression SEMICOLON
    |
    READ VariableReference SEMICOLON
;

VariableReference:
    ID ArrRefList
;

ArrRefList:
    Epsilon
    |
    ArrRefs
;

ArrRefs:
    L_BRACKET Expression R_BRACKET
    |
    ArrRefs L_BRACKET Expression R_BRACKET
;

Condition:
    IF Expression THEN
    CompoundStatement
    ElseOrNot
    END IF
;

ElseOrNot:
    ELSE
    CompoundStatement
    |
    Epsilon
;

While:
    WHILE Expression DO
    CompoundStatement
    END DO
;

For:
    FOR ID ASSIGN INT_LITERAL TO INT_LITERAL DO
    CompoundStatement
    END DO
;

Return:
    RETURN Expression SEMICOLON
;

FunctionCall:
    FunctionInvocation SEMICOLON
;

FunctionInvocation:
    ID L_PARENTHESIS ExpressionList R_PARENTHESIS
;

ExpressionList:
    Epsilon
    |
    Expressions
;

Expressions:
    Expression
    |
    Expressions COMMA Expression
;

StatementList:
    Epsilon
    |
    Statements
;

Statements:
    Statement
    |
    Statements Statement
;

Expression:
    L_PARENTHESIS Expression R_PARENTHESIS
    |
    MINUS Expression %prec UNARY_MINUS
    |
    Expression MULTIPLY Expression
    |
    Expression DIVIDE Expression
    |
    Expression MOD Expression
    |
    Expression PLUS Expression
    |
    Expression MINUS Expression
    |
    Expression LESS Expression
    |
    Expression LESS_OR_EQUAL Expression
    |
    Expression GREATER Expression
    |
    Expression GREATER_OR_EQUAL Expression
    |
    Expression EQUAL Expression
    |
    Expression NOT_EQUAL Expression
    |
    NOT Expression
    |
    Expression AND Expression
    |
    Expression OR Expression
    |
    IntegerAndReal
    |
    StringAndBoolean
    |
    VariableReference
    |
    FunctionInvocation
;

    /*
       misc
            */
Epsilon:
;
%%

void yyerror(const char *msg) {
    fprintf(stderr,
            "\n"
            "|-----------------------------------------------------------------"
            "---------\n"
            "| Error found in Line #%d: %s\n"
            "|\n"
            "| Unmatched token: %s\n"
            "|-----------------------------------------------------------------"
            "---------\n",
            line_num, buffer, yytext);
    exit(-1);
}

int main(int argc, const char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: ./parser <filename> [--dump-ast]\n");
        exit(-1);
    }

    yyin = fopen(argv[1], "r");
    assert(yyin != NULL && "fopen() fails.");
    
    yyparse();

    if (argc >= 3 && strcmp(argv[2], "--dump-ast") == 0) {
        dumper.visit(*root);
    }

    printf("\n"
           "|--------------------------------|\n"
           "|  There is no syntactic error!  |\n"
           "|--------------------------------|\n");

    // delete root;
    fclose(yyin);
    yylex_destroy();
    return 0;
}
