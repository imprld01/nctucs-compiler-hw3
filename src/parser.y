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
#include "utils/p_scalar_type.hpp"

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
%code requires { #include "utils/location.hpp" }
%code requires { #include "utils/p_scalar_type.hpp" }

%code requires { 
    struct var_info {
        Location        loc;
        char*           varName;
        p_scalar_type   varType;
    };
}

    /* For yylval */
%union {
    /* basic semantic value */
    int                         int_type;
    double                      float_type;
    char*                       string_type;
    p_scalar_type               data_type;
    
    std::vector<int>*           int_list;
    std::vector<char*>*         string_list;
    std::vector<var_info>*      id_list;
    std::vector<AstNode*>*      node_list;

    AstNode*                    node;
    CompoundStatementNode*      comp_stmt_node;
    ConstantValueNode*          const_val_node;
    DeclNode*                   decl_node;
    ExpressionNode*             expr_node;
    FunctionNode*               func_node;
    FunctionInvocationNode*     invo_node;
    VariableNode*               var_node;
};

%type <data_type>       ScalarType          
                        ReturnType
%type <int_type>        NegOrNot            
                        INT_LITERAL
%type <float_type>      REAL_LITERAL
%type <string_type>     ID                  
                        ProgramName         
                        FunctionName        
                        STRING_LITERAL      
                        TRUE                
                        FALSE               
                        Type                
                        ArrDecl             
                        ArrType             

%type <comp_stmt_node>  CompoundStatement
                        ElseOrNot
%type <const_val_node>  LiteralConstant     
                        IntegerAndReal      
                        StringAndBoolean
%type <decl_node>       Declaration         
                        FormalArg;
%type <expr_node>       Expression               
                        VariableReference
%type <func_node>       Function            
                        FunctionDeclaration 
                        FunctionDefinition       
%type <invo_node>       FunctionInvocation     
%type <node>            Statement                
                        Simple
                        Condition
                        While
                        For            
                        Return       

%type <id_list>         IdList
%type <node_list>       DeclarationList    
                        Declarations       
                        FunctionList       
                        Functions          
                        StatementList      
                        Statements         
                        FormalArgs         
                        FormalArgList      
                        ArrRefList         
                        ArrRefs
                        ExpressionList
                        Expressions

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
        
        for (AstNode* node: *$4) root->append(node);
        free($4);

        root->append($5);
    }
;

ProgramName:
    ID
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
    Functions 
;

Functions:
    Function {
        $$ = new vector<AstNode*>();
        $$->push_back($1);
    }
    |
    Functions Function {
        $1->push_back($2);
        $$ = $1;
    }
;

Function:
    FunctionDeclaration
    |
    FunctionDefinition
;

FunctionDeclaration:
    FunctionName L_PARENTHESIS FormalArgList R_PARENTHESIS ReturnType SEMICOLON {
        $$ = new FunctionNode(@1.first_line, @1.first_column, $1, $5);
        for (const AstNode* declNode: *$3) $$->addParam((const DeclNode*) declNode);
    }
;

FunctionDefinition:
    FunctionName L_PARENTHESIS FormalArgList R_PARENTHESIS ReturnType
    CompoundStatement
    END {
        $$ = new FunctionNode(@1.first_line, @1.first_column, $1, $5);
        for (const AstNode* declNode: *$3) $$->addParam((const DeclNode*) declNode);
        $$->append($6);
    }
;

FunctionName:
    ID
;

FormalArgList:
    Epsilon { $$ = new vector<AstNode*>(); }
    |
    FormalArgs
;

FormalArgs:
    FormalArg {
        $$ = new vector<AstNode*>();
        $$->push_back($1);
    }
    |
    FormalArgs SEMICOLON FormalArg {
        $1->push_back($3);
    }
;

FormalArg:
    IdList COLON Type {
        $$ = new DeclNode(@1.first_line, @1.first_column);
        for (var_info& v: *$1) {
            $$->append(new VariableNode(v.loc.line, v.loc.col, v.varName, $3));
        }
        free($1);
    }
;

IdList:
    ID {
        $$ = new vector<var_info>();
        $$->push_back({{@1.first_line, @1.first_column}, strdup($1), P_UNKNOWN});
        free($1);
    }
    |
    IdList COMMA ID {
        $1->push_back({{@3.first_line, @3.first_column}, strdup($3), P_UNKNOWN});
        $$ = $1;
        free($3);
    }
;

ReturnType:
    COLON ScalarType { $$ = $2; }
    |
    Epsilon { $$ = P_VOID; }
;

    /*
       Data Types and Declarations
                                   */

Declaration:
    VAR IdList COLON Type SEMICOLON {
        $$ = new DeclNode(@1.first_line, @1.first_column);
        for (const var_info& v: *$2) {
            VariableNode* varNode = new VariableNode(v.loc.line, 
                                                     v.loc.col,
                                                     v.varName,
                                                     $4);
            $$->append(varNode);
            free(v.varName);
        }
        free($2);
        free($4);
    }
    |
    VAR IdList COLON LiteralConstant SEMICOLON {
        $$ = new DeclNode(@1.first_line, @1.first_column);
        for (const var_info& v: *$2) {
            VariableNode* varNode = new VariableNode(v.loc.line, 
                                                     v.loc.col, 
                                                     v.varName, 
                                                     $4->getDataType());
            varNode->append($4);
            $$->append(varNode);
            free(v.varName);
        }
        free($2);
    }
;

Type:
    ScalarType { $$ = strdup(ptptoa($1)); }
    |
    ArrType
;

ScalarType:
    INTEGER { $$ = P_INT; }
    |
    REAL    { $$ = P_REAL; }
    |
    STRING  { $$ = P_STRING; }
    |
    BOOLEAN { $$ = P_BOOLEAN; }
;

ArrType:
    ArrDecl ScalarType {
        char* ret = (char*) malloc(10 + 1 + strlen($1) + 1);
        sprintf(ret, "%s %s", ptptoa($2), $1);
        free($1);
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
            $$ = new ConstantValueNode(@1.first_line, @1.first_column, -$2, P_INT);
        }
        else {
            $$ = new ConstantValueNode(@2.first_line, @2.first_column, $2, P_INT);
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
    Epsilon { $$ = 0; }
    |
    MINUS %prec UNARY_MINUS { $$ = 1; }
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
        $$ = new ConstantValueNode(@1.first_line, @1.first_column, 1, P_BOOLEAN);
    }
    |
    FALSE {
        $$ = new ConstantValueNode(@1.first_line, @1.first_column, 0, P_BOOLEAN);
    }
;

IntegerAndReal:
    INT_LITERAL {
        $$ = new ConstantValueNode(@1.first_line, @1.first_column, $1, P_INT);
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
    FunctionCall { $$ = NULL; } // TODO
;

CompoundStatement:
    BEGIN_
    DeclarationList
    StatementList
    END {
        $$ = new CompoundStatementNode(@1.first_line, @1.first_column);
        for (AstNode* node: *$2) $$->append(node);
        for (AstNode* node: *$3) if (node) $$->append(node); // TODO
    }
;

Simple:
    VariableReference ASSIGN Expression SEMICOLON {
        $$ = new AssignmentNode(@2.first_line, @2.first_column);
        if ($1) $$->append($1); // TODO
        if ($3) $$->append($3); // TODO
    }
    |
    PRINT Expression SEMICOLON {
        $$ = new PrintNode(@1.first_line, @1.first_column);
        if ($2) $$->append($2); // TODO
    }
    |
    READ VariableReference SEMICOLON {
        $$ = new ReadNode(@1.first_line, @1.first_column);
        if ($2) $$->append($2); // TODO
    }
;

VariableReference:
    ID ArrRefList { 
        $$ = new VariableReferenceNode(@1.first_line, @1.first_column, $1);
        for (AstNode* exprNode: *$2) $$->append(exprNode);
        free($1);
        free($2);
    }
;

ArrRefList:
    Epsilon { $$ = new vector<AstNode*>(); }
    |
    ArrRefs
;

ArrRefs:
    L_BRACKET Expression R_BRACKET {
        $$ = new vector<AstNode*>();
        if ($2) $$->push_back((AstNode*) $2); // TODO
    }
    |
    ArrRefs L_BRACKET Expression R_BRACKET {
        if ($3) $1->push_back((AstNode*) $3); // TODO
        $$ = $1;
    }
;

Condition:
    IF Expression THEN
    CompoundStatement
    ElseOrNot
    END IF { $$ = new IfNode(@1.first_line, @1.first_column, $2, $4, $5); }
;

ElseOrNot:
    ELSE
    CompoundStatement { $$ = $2; }
    |
    Epsilon { $$ = NULL; }
;

While:
    WHILE Expression DO
    CompoundStatement
    END DO {
        $$ = new WhileNode(@1.first_line, @1.first_column, $2, $4);
    }
;

For:
    FOR ID ASSIGN INT_LITERAL TO INT_LITERAL DO
    CompoundStatement
    END DO {
        VariableNode* varNode = new VariableNode(@2.first_line, 
                                                 @2.first_column,
                                                 $2,
                                                 P_INT);
        DeclNode* declNode = new DeclNode(@2.first_line,
                                          @2.first_column);
        declNode->append(varNode);

        VariableReferenceNode* varRefNode = new VariableReferenceNode(@2.first_line,
                                                                      @2.first_column,
                                                                      $2);
        ConstantValueNode* initConstVal = new ConstantValueNode(@4.first_line,
                                                                @4.first_column,
                                                                $4,
                                                                P_INT);
        AssignmentNode *asgnNode = new AssignmentNode(@3.first_line,  
                                                      @3.first_column);
        asgnNode->append(varRefNode);
        asgnNode->append(initConstVal);

        ConstantValueNode* termConstVal = new ConstantValueNode(@6.first_line,
                                                                @6.first_column,
                                                                $6,
                                                                P_INT);

        $$ = new ForNode(@1.first_line,
                         @1.first_column, 
                         declNode, 
                         asgnNode, 
                         termConstVal, 
                         $8,
                         $4,
                         $6);
        free($2);
    }
;

Return:
    RETURN Expression SEMICOLON {
        $$ = new ReturnNode(@1.first_line, @1.first_column, $2);
    }
;

FunctionCall:
    FunctionInvocation SEMICOLON
;

FunctionInvocation:
    ID L_PARENTHESIS ExpressionList R_PARENTHESIS {
        $$ = new FunctionInvocationNode(@1.first_line, @1.first_column, $1);
        for (AstNode* exprNode: *$3) $$->append(exprNode);
        free($3);
        free($1);
    }
;

ExpressionList:
    Epsilon { $$ = new vector<AstNode*>(); }
    |
    Expressions
;

Expressions:
    Expression {
        $$ = new vector<AstNode*>();
        $$->push_back((AstNode*) $1);
    }
    |
    Expressions COMMA Expression {
        $1->push_back((AstNode*) $3);
        $$ = $1;
    }
;

StatementList:
    Epsilon { $$ = new vector<AstNode*>(); }
    |
    Statements
;

Statements:
    Statement {
        $$ = new vector<AstNode*>();
        $$->push_back($1);
    }
    |
    Statements Statement {
        $1->push_back($2);
        $$ = $1;
    }
;

Expression:
    L_PARENTHESIS Expression R_PARENTHESIS { 
        $$ = $2; 
    }
    |
    MINUS Expression %prec UNARY_MINUS { 
        $$ = new UnaryOperatorNode(@1.first_line, @1.first_column, P_NEG, $2);
    }
    |
    Expression MULTIPLY Expression { 
        $$ = new BinaryOperatorNode(@2.first_line,
                                    @2.first_column,
                                    P_MUL,
                                    $1,
                                    $3);
    }
    |
    Expression DIVIDE Expression { 
        $$ = new BinaryOperatorNode(@2.first_line,
                                    @2.first_column,
                                    P_DIV,
                                    $1,
                                    $3);
    }
    |
    Expression MOD Expression { 
        $$ = new BinaryOperatorNode(@2.first_line,
                                    @2.first_column,
                                    P_MOD,
                                    $1,
                                    $3);
    }
    |
    Expression PLUS Expression { 
        $$ = new BinaryOperatorNode(@2.first_line,
                                    @2.first_column,
                                    P_PLUS,
                                    $1,
                                    $3);
    }
    |
    Expression MINUS Expression { 
        $$ = new BinaryOperatorNode(@2.first_line,
                                    @2.first_column,
                                    P_MINUS,
                                    $1,
                                    $3);
    }
    |
    Expression LESS Expression { 
        $$ = new BinaryOperatorNode(@2.first_line,
                                    @2.first_column,
                                    P_LT,
                                    $1,
                                    $3);
    }
    |
    Expression LESS_OR_EQUAL Expression { 
        $$ = new BinaryOperatorNode(@2.first_line,
                                    @2.first_column,
                                    P_LE,
                                    $1,
                                    $3);
    }
    |
    Expression GREATER Expression { 
        $$ = new BinaryOperatorNode(@2.first_line,
                                    @2.first_column,
                                    P_GT,
                                    $1,
                                    $3);
    }
    |
    Expression GREATER_OR_EQUAL Expression { 
        $$ = new BinaryOperatorNode(@2.first_line,
                                    @2.first_column,
                                    P_GE,
                                    $1,
                                    $3);
    }
    |
    Expression EQUAL Expression { 
        $$ = new BinaryOperatorNode(@2.first_line,
                                    @2.first_column,
                                    P_EQ,
                                    $1,
                                    $3);
    }
    |
    Expression NOT_EQUAL Expression { 
        $$ = new BinaryOperatorNode(@2.first_line,
                                    @2.first_column,
                                    P_NE,
                                    $1,
                                    $3);
    }
    |
    NOT Expression { 
        $$ = new UnaryOperatorNode(@1.first_line, @1.first_column, P_NOT, $2);
    }
    |
    Expression AND Expression { 
        $$ = new BinaryOperatorNode(@2.first_line,
                                    @2.first_column,
                                    P_AND,
                                    $1,
                                    $3);
    }
    |
    Expression OR Expression { 
        $$ = new BinaryOperatorNode(@2.first_line,
                                    @2.first_column,
                                    P_OR,
                                    $1,
                                    $3);
    }
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
