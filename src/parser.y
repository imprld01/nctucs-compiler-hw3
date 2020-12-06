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

    /* For yylval */
%union {
    /* basic semantic value */
    int                     int_type;
    double                  float_type;
    char*                   string_type;
    AstNode*                node;
    std::vector<AstNode*>*  node_list;
    std::vector<char*>*     string_list;
};

%type <string_type>   ProgramName ID Type ScalarType ArrType
%type <node_list>     DeclarationList Declarations Declaration FunctionList StatementList
%type <string_list>   IdList
%type <node>          CompoundStatement


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
        for (AstNode* node: *$4) root->append(node);
        root->append($5);
        free($3);
        free($4);
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
    Declaration 
    |
    Declarations Declaration {
        $1->insert($1->end(), $2->begin(), $2->end());
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
        $$ = new vector<char*>();
        $$->push_back(strdup($1));
        free($1);
    }
    |
    IdList COMMA ID {
        $1->push_back(strdup($3));
        $$ = $1;
        free($1);
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
        char* varType = $4;
        $$ = new vector<AstNode*>();
        for (char* varName: *$2) {
            DeclNode* node = new DeclNode(@1.first_line, @1.first_column, varName, varType);
            $$->push_back(node);
            free(varName);
        }
        free($4);
    }
    |
    VAR IdList COLON LiteralConstant SEMICOLON {
        $$ = new vector<AstNode*>();
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
        $$ = (char*) malloc(strlen($2) + 2 + 1);
        strcpy($$, $2);
        strcat($$, "[]");
    }
;

ArrDecl:
    ARRAY INT_LITERAL OF
    |
    ArrDecl ARRAY INT_LITERAL OF
;

LiteralConstant:
    NegOrNot INT_LITERAL
    |
    NegOrNot REAL_LITERAL
    |
    StringAndBoolean
;

NegOrNot:
    Epsilon
    |
    MINUS %prec UNARY_MINUS
;

StringAndBoolean:
    STRING_LITERAL
    |
    TRUE
    |
    FALSE
;

IntegerAndReal:
    INT_LITERAL
    |
    REAL_LITERAL
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
        $$ = (AstNode*) new CompoundStatementNode(@1.first_line, @1.first_column);
        // for (AstNode* node: *$2) $$->append(node);
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
