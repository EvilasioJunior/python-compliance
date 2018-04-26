// Generated by transforming |cwd:///work-in-progress/menhir/conflict-free-ebnf/3.5.0.mly| on 2018-01-13 at 10:33:17.762+00:00
%{
	int yylex (void);
	extern int yylineno;
	extern char *yytext;
	void yyerror (char const *);
%}

// 89 tokens, in alphabetical order:
%token AMPEREQUAL AMPERSAND AND ARROW AS ASSERT ASYNC AT ATEQ AWAIT BAR
%token BREAK CIRCUMFLEX CIRCUMFLEXEQUAL CLASS COLON COMMA CONTINUE DEDENT
%token DEF DEL DOT DOUBLESLASH DOUBLESLASHEQUAL DOUBLESTAR DOUBLESTAREQUAL
%token ELIF ELSE ENDMARKER EQEQUAL EQUAL EXCEPT FALSE FINALLY FOR FROM GLOBAL
%token GREATER GREATEREQUAL GRLT IF IMPORT IN INDENT IS LAMBDA LBRACE LEFTSHIFT
%token LEFTSHIFTEQUAL LESS LESSEQUAL LPAR LSQB MINEQUAL MINUS NAME NEWLINE
%token NONE NONLOCAL NOT NOTEQUAL NUMBER OR PASS PERCENT PERCENTEQUAL PLUS
%token PLUSEQUAL RAISE RBRACE RETURN RIGHTSHIFT RIGHTSHIFTEQUAL RPAR RSQB
%token SEMI SLASH SLASHEQUAL STAR STAREQUAL STRING THREE_DOTS TILDE TRUE
%token TRY VBAREQUAL WHILE WITH YIELD

%locations


%start start


%%

start
	: file_input
	;
file_input // Used in: start
	: star_NEWLINE_stmt ENDMARKER
	;
decorator // Used in: plus_decorator
	: AT dotted_name LPAR arglist RPAR NEWLINE
	| AT dotted_name LPAR RPAR NEWLINE
	| AT dotted_name NEWLINE
	;
decorators // Used in: decorated
	: plus_decorator
	;
decorated // Used in: compound_stmt
	: decorators classdef
	| decorators funcdef
	| decorators async_funcdef
	;
async_funcdef // Used in: decorated
	: ASYNC funcdef
	;
funcdef // Used in: decorated, async_funcdef, compound_stmt, async_stmt
	: DEF NAME parameters ARROW test COLON suite
	| DEF NAME parameters COLON suite
	;
parameters // Used in: funcdef
	: LPAR typedargslist RPAR
	| LPAR RPAR
	;
typedargslist // Used in: parameters
	: tfpdef EQUAL test star_001 COMMA STAR tfpdef star_001 COMMA DOUBLESTAR tfpdef
	| tfpdef EQUAL test star_001 COMMA STAR tfpdef star_001
	| tfpdef EQUAL test star_001 COMMA STAR star_001 COMMA DOUBLESTAR tfpdef
	| tfpdef EQUAL test star_001 COMMA STAR star_001
	| tfpdef EQUAL test star_001 COMMA DOUBLESTAR tfpdef
	| tfpdef EQUAL test star_001 COMMA
	| tfpdef EQUAL test star_001
	| tfpdef star_001 COMMA STAR tfpdef star_001 COMMA DOUBLESTAR tfpdef
	| tfpdef star_001 COMMA STAR tfpdef star_001
	| tfpdef star_001 COMMA STAR star_001 COMMA DOUBLESTAR tfpdef
	| tfpdef star_001 COMMA STAR star_001
	| tfpdef star_001 COMMA DOUBLESTAR tfpdef
	| tfpdef star_001 COMMA
	| tfpdef star_001
	| STAR tfpdef star_001 COMMA DOUBLESTAR tfpdef
	| STAR tfpdef star_001
	| STAR star_001 COMMA DOUBLESTAR tfpdef
	| STAR star_001
	| DOUBLESTAR tfpdef
	;
tfpdef // Used in: typedargslist, star_001
	: NAME COLON test
	| NAME
	;
varargslist // Used in: lambdef, lambdef_nocond
	: vfpdef EQUAL test star_002 COMMA STAR vfpdef star_002 COMMA DOUBLESTAR vfpdef
	| vfpdef EQUAL test star_002 COMMA STAR vfpdef star_002
	| vfpdef EQUAL test star_002 COMMA STAR star_002 COMMA DOUBLESTAR vfpdef
	| vfpdef EQUAL test star_002 COMMA STAR star_002
	| vfpdef EQUAL test star_002 COMMA DOUBLESTAR vfpdef
	| vfpdef EQUAL test star_002 COMMA
	| vfpdef EQUAL test star_002
	| vfpdef star_002 COMMA STAR vfpdef star_002 COMMA DOUBLESTAR vfpdef
	| vfpdef star_002 COMMA STAR vfpdef star_002
	| vfpdef star_002 COMMA STAR star_002 COMMA DOUBLESTAR vfpdef
	| vfpdef star_002 COMMA STAR star_002
	| vfpdef star_002 COMMA DOUBLESTAR vfpdef
	| vfpdef star_002 COMMA
	| vfpdef star_002
	| STAR vfpdef star_002 COMMA DOUBLESTAR vfpdef
	| STAR vfpdef star_002
	| STAR star_002 COMMA DOUBLESTAR vfpdef
	| STAR star_002
	| DOUBLESTAR vfpdef
	;
vfpdef // Used in: varargslist, star_002
	: NAME
	;
stmt // Used in: star_NEWLINE_stmt, plus_stmt
	: simple_stmt
	| compound_stmt
	;
simple_stmt // Used in: stmt, suite
	: small_stmt star_SEMI_small_stmt SEMI NEWLINE
	| small_stmt star_SEMI_small_stmt NEWLINE
	;
small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: expr_stmt
	| del_stmt
	| pass_stmt
	| flow_stmt
	| import_stmt
	| global_stmt
	| nonlocal_stmt
	| assert_stmt
	;
expr_stmt // Used in: small_stmt
	: testlist_star_expr augassign yield_expr
	| testlist_star_expr augassign testlist
	| testlist_star_expr star_003
	;
testlist_star_expr // Used in: expr_stmt, star_003
	: test star_004 COMMA
	| test star_004
	| star_expr star_004 COMMA
	| star_expr star_004
	;
augassign // Used in: expr_stmt
	: PLUSEQUAL
	| MINEQUAL
	| STAREQUAL
	| ATEQ
	| SLASHEQUAL
	| PERCENTEQUAL
	| AMPEREQUAL
	| VBAREQUAL
	| CIRCUMFLEXEQUAL
	| LEFTSHIFTEQUAL
	| RIGHTSHIFTEQUAL
	| DOUBLESTAREQUAL
	| DOUBLESLASHEQUAL
	;
del_stmt // Used in: small_stmt
	: DEL exprlist
	;
pass_stmt // Used in: small_stmt
	: PASS
	;
flow_stmt // Used in: small_stmt
	: break_stmt
	| continue_stmt
	| return_stmt
	| raise_stmt
	| yield_stmt
	;
break_stmt // Used in: flow_stmt
	: BREAK
	;
continue_stmt // Used in: flow_stmt
	: CONTINUE
	;
return_stmt // Used in: flow_stmt
	: RETURN testlist
	| RETURN
	;
yield_stmt // Used in: flow_stmt
	: yield_expr
	;
raise_stmt // Used in: flow_stmt
	: RAISE test FROM test
	| RAISE test
	| RAISE
	;
import_stmt // Used in: small_stmt
	: import_name
	| import_from
	;
import_name // Used in: import_stmt
	: IMPORT dotted_as_names
	;
import_from // Used in: import_stmt
	: FROM star_DOT_THREE_DOTS dotted_name IMPORT STAR
	| FROM star_DOT_THREE_DOTS dotted_name IMPORT LPAR import_as_names RPAR
	| FROM star_DOT_THREE_DOTS dotted_name IMPORT import_as_names
	| FROM star_DOT_THREE_DOTS DOT IMPORT STAR
	| FROM star_DOT_THREE_DOTS DOT IMPORT LPAR import_as_names RPAR
	| FROM star_DOT_THREE_DOTS DOT IMPORT import_as_names
	| FROM star_DOT_THREE_DOTS THREE_DOTS IMPORT STAR
	| FROM star_DOT_THREE_DOTS THREE_DOTS IMPORT LPAR import_as_names RPAR
	| FROM star_DOT_THREE_DOTS THREE_DOTS IMPORT import_as_names
	;
import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: NAME AS NAME
	| NAME
	;
dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: dotted_name AS NAME
	| dotted_name
	;
import_as_names // Used in: import_from
	: import_as_name star_COMMA_import_as_name COMMA
	| import_as_name star_COMMA_import_as_name
	;
dotted_as_names // Used in: import_name
	: dotted_as_name star_COMMA_dotted_as_name
	;
dotted_name // Used in: decorator, import_from, dotted_as_name
	: NAME star_DOT_NAME
	;
global_stmt // Used in: small_stmt
	: GLOBAL NAME star_COMMA_NAME
	;
nonlocal_stmt // Used in: small_stmt
	: NONLOCAL NAME star_COMMA_NAME
	;
assert_stmt // Used in: small_stmt
	: ASSERT test COMMA test
	| ASSERT test
	;
compound_stmt // Used in: stmt
	: if_stmt
	| while_stmt
	| for_stmt
	| try_stmt
	| with_stmt
	| funcdef
	| classdef
	| decorated
	| async_stmt
	;
async_stmt // Used in: compound_stmt
	: ASYNC funcdef
	| ASYNC with_stmt
	| ASYNC for_stmt
	;
if_stmt // Used in: compound_stmt
	: IF test COLON suite star_ELIF ELSE COLON suite
	| IF test COLON suite star_ELIF
	;
while_stmt // Used in: compound_stmt
	: WHILE test COLON suite ELSE COLON suite
	| WHILE test COLON suite
	;
for_stmt // Used in: compound_stmt, async_stmt
	: FOR exprlist IN testlist COLON suite ELSE COLON suite
	| FOR exprlist IN testlist COLON suite
	;
try_stmt // Used in: compound_stmt
	: TRY COLON suite plus_except ELSE COLON suite FINALLY COLON suite
	| TRY COLON suite plus_except ELSE COLON suite
	| TRY COLON suite plus_except FINALLY COLON suite
	| TRY COLON suite plus_except
	| TRY COLON suite FINALLY COLON suite
	;
with_stmt // Used in: compound_stmt, async_stmt
	: WITH with_item star_COMMA_with_item COLON suite
	;
with_item // Used in: with_stmt, star_COMMA_with_item
	: test AS expr
	| test
	;
except_clause // Used in: plus_except
	: EXCEPT test AS NAME
	| EXCEPT test
	| EXCEPT
	;
suite // Used in: funcdef, if_stmt, while_stmt, for_stmt, try_stmt, with_stmt, classdef, star_ELIF, plus_except
	: simple_stmt
	| NEWLINE INDENT plus_stmt DEDENT
	;
test // Used in: funcdef, typedargslist, tfpdef, varargslist, testlist_star_expr, raise_stmt, assert_stmt, if_stmt, while_stmt, with_item, except_clause, test, lambdef, testlist_comp, subscript, sliceop, testlist, dictorsetmaker, argument, yield_arg, star_001, star_002, star_004, star_ELIF, star_COMMA_test, star_009
	: or_test IF or_test ELSE test
	| or_test
	| lambdef
	;
test_nocond // Used in: lambdef_nocond, comp_if
	: or_test
	| lambdef_nocond
	;
lambdef // Used in: test
	: LAMBDA varargslist COLON test
	| LAMBDA COLON test
	;
lambdef_nocond // Used in: test_nocond
	: LAMBDA varargslist COLON test_nocond
	| LAMBDA COLON test_nocond
	;
or_test // Used in: test, test_nocond, comp_for
	: and_test star_OR_and_test
	;
and_test // Used in: or_test, star_OR_and_test
	: not_test star_AND_not_test
	;
not_test // Used in: and_test, not_test, star_AND_not_test
	: NOT not_test
	| comparison
	;
comparison // Used in: not_test
	: expr star_comp_op_expr
	;
comp_op // Used in: star_comp_op_expr
	: LESS
	| GREATER
	| EQEQUAL
	| GREATEREQUAL
	| LESSEQUAL
	| GRLT
	| NOTEQUAL
	| IN
	| NOT IN
	| IS
	| IS NOT
	;
star_expr // Used in: testlist_star_expr, testlist_comp, exprlist, dictorsetmaker, star_004, star_008
	: STAR expr
	;
expr // Used in: with_item, comparison, star_expr, exprlist, dictorsetmaker, star_comp_op_expr, star_008, star_009
	: xor_expr star_BAR_xor_expr
	;
xor_expr // Used in: expr, star_BAR_xor_expr
	: and_expr star_CIRCUMFLEX_and_expr
	;
and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: shift_expr star_AMPERSAND_shift_expr
	;
shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: arith_expr star_005
	;
arith_expr // Used in: shift_expr, star_005
	: term star_006
	;
term // Used in: arith_expr, star_006
	: factor star_007
	;
factor // Used in: term, factor, power, star_007
	: PLUS factor
	| MINUS factor
	| TILDE factor
	| power
	;
power // Used in: factor
	: atom_expr DOUBLESTAR factor
	| atom_expr
	;
atom_expr // Used in: power
	: AWAIT atom star_trailer
	| atom star_trailer
	;
atom // Used in: atom_expr
	: LPAR yield_expr RPAR
	| LPAR testlist_comp RPAR
	| LPAR RPAR
	| LSQB testlist_comp RSQB
	| LSQB RSQB
	| LBRACE dictorsetmaker RBRACE
	| LBRACE RBRACE
	| NAME
	| NUMBER
	| plus_STRING
	| THREE_DOTS
	| NONE
	| TRUE
	| FALSE
	;
testlist_comp // Used in: atom
	: test comp_for
	| test star_004 COMMA
	| test star_004
	| star_expr comp_for
	| star_expr star_004 COMMA
	| star_expr star_004
	;
trailer // Used in: star_trailer
	: LPAR arglist RPAR
	| LPAR RPAR
	| LSQB subscriptlist RSQB
	| DOT NAME
	;
subscriptlist // Used in: trailer
	: subscript star_COMMA_subscript COMMA
	| subscript star_COMMA_subscript
	;
subscript // Used in: subscriptlist, star_COMMA_subscript
	: test
	| test COLON test sliceop
	| test COLON test
	| test COLON sliceop
	| test COLON
	| COLON test sliceop
	| COLON test
	| COLON sliceop
	| COLON
	;
sliceop // Used in: subscript
	: COLON test
	| COLON
	;
exprlist // Used in: del_stmt, for_stmt, comp_for
	: expr star_008 COMMA
	| expr star_008
	| star_expr star_008 COMMA
	| star_expr star_008
	;
testlist // Used in: expr_stmt, return_stmt, for_stmt, yield_arg
	: test star_COMMA_test COMMA
	| test star_COMMA_test
	;
dictorsetmaker // Used in: atom
	: test COLON test comp_for
	| test COLON test star_009 COMMA
	| test COLON test star_009
	| DOUBLESTAR expr comp_for
	| DOUBLESTAR expr star_009 COMMA
	| DOUBLESTAR expr star_009
	| test comp_for
	| test star_004 COMMA
	| test star_004
	| star_expr comp_for
	| star_expr star_004 COMMA
	| star_expr star_004
	;
classdef // Used in: decorated, compound_stmt
	: CLASS NAME LPAR arglist RPAR COLON suite
	| CLASS NAME LPAR RPAR COLON suite
	| CLASS NAME COLON suite
	;
arglist // Used in: decorator, trailer, classdef
	: argument star_COMMA_argument COMMA
	| argument star_COMMA_argument
	;
argument // Used in: arglist, star_COMMA_argument
	: test comp_for
	| test
	| test EQUAL test
	| DOUBLESTAR test
	| STAR test
	;
comp_iter // Used in: comp_for, comp_if
	: comp_for
	| comp_if
	;
comp_for // Used in: testlist_comp, dictorsetmaker, argument, comp_iter
	: FOR exprlist IN or_test comp_iter
	| FOR exprlist IN or_test
	;
comp_if // Used in: comp_iter
	: IF test_nocond comp_iter
	| IF test_nocond
	;
yield_expr // Used in: expr_stmt, yield_stmt, atom, star_003
	: YIELD yield_arg
	| YIELD
	;
yield_arg // Used in: yield_expr
	: FROM test
	| testlist
	;
star_NEWLINE_stmt // Used in: file_input, star_NEWLINE_stmt
	: star_NEWLINE_stmt NEWLINE
	| star_NEWLINE_stmt stmt
	| %empty
	;
plus_decorator // Used in: decorators, plus_decorator
	: plus_decorator decorator
	| decorator
	;
star_001 // Used in: typedargslist, star_001
	: star_001 COMMA tfpdef EQUAL test
	| star_001 COMMA tfpdef
	| %empty
	;
star_002 // Used in: varargslist, star_002
	: star_002 COMMA vfpdef EQUAL test
	| star_002 COMMA vfpdef
	| %empty
	;
star_SEMI_small_stmt // Used in: simple_stmt, star_SEMI_small_stmt
	: star_SEMI_small_stmt SEMI small_stmt
	| %empty
	;
star_003 // Used in: expr_stmt, star_003
	: star_003 EQUAL yield_expr
	| star_003 EQUAL testlist_star_expr
	| %empty
	;
star_004 // Used in: testlist_star_expr, testlist_comp, dictorsetmaker, star_004
	: star_004 COMMA test
	| star_004 COMMA star_expr
	| %empty
	;
star_COMMA_import_as_name // Used in: import_as_names, star_COMMA_import_as_name
	: star_COMMA_import_as_name COMMA import_as_name
	| %empty
	;
star_COMMA_dotted_as_name // Used in: dotted_as_names, star_COMMA_dotted_as_name
	: star_COMMA_dotted_as_name COMMA dotted_as_name
	| %empty
	;
star_DOT_NAME // Used in: dotted_name, star_DOT_NAME
	: star_DOT_NAME DOT NAME
	| %empty
	;
star_COMMA_NAME // Used in: global_stmt, nonlocal_stmt, star_COMMA_NAME
	: star_COMMA_NAME COMMA NAME
	| %empty
	;
star_ELIF // Used in: if_stmt, star_ELIF
	: star_ELIF ELIF test COLON suite
	| %empty
	;
plus_except // Used in: try_stmt, plus_except
	: plus_except except_clause COLON suite
	| except_clause COLON suite
	;
star_COMMA_with_item // Used in: with_stmt, star_COMMA_with_item
	: star_COMMA_with_item COMMA with_item
	| %empty
	;
plus_stmt // Used in: suite, plus_stmt
	: plus_stmt stmt
	| stmt
	;
star_OR_and_test // Used in: or_test, star_OR_and_test
	: star_OR_and_test OR and_test
	| %empty
	;
star_AND_not_test // Used in: and_test, star_AND_not_test
	: star_AND_not_test AND not_test
	| %empty
	;
star_comp_op_expr // Used in: comparison, star_comp_op_expr
	: star_comp_op_expr comp_op expr
	| %empty
	;
star_BAR_xor_expr // Used in: expr, star_BAR_xor_expr
	: star_BAR_xor_expr BAR xor_expr
	| %empty
	;
star_CIRCUMFLEX_and_expr // Used in: xor_expr, star_CIRCUMFLEX_and_expr
	: star_CIRCUMFLEX_and_expr CIRCUMFLEX and_expr
	| %empty
	;
star_AMPERSAND_shift_expr // Used in: and_expr, star_AMPERSAND_shift_expr
	: star_AMPERSAND_shift_expr AMPERSAND shift_expr
	| %empty
	;
star_005 // Used in: shift_expr, star_005
	: star_005 LEFTSHIFT arith_expr
	| star_005 RIGHTSHIFT arith_expr
	| %empty
	;
star_006 // Used in: arith_expr, star_006
	: star_006 PLUS term
	| star_006 MINUS term
	| %empty
	;
star_007 // Used in: term, star_007
	: star_007 STAR factor
	| star_007 AT factor
	| star_007 SLASH factor
	| star_007 PERCENT factor
	| star_007 DOUBLESLASH factor
	| %empty
	;
star_trailer // Used in: atom_expr, star_trailer
	: star_trailer trailer
	| %empty
	;
plus_STRING // Used in: atom, plus_STRING
	: plus_STRING STRING
	| STRING
	;
star_COMMA_subscript // Used in: subscriptlist, star_COMMA_subscript
	: star_COMMA_subscript COMMA subscript
	| %empty
	;
star_008 // Used in: exprlist, star_008
	: star_008 COMMA expr
	| star_008 COMMA star_expr
	| %empty
	;
star_COMMA_test // Used in: testlist, star_COMMA_test
	: star_COMMA_test COMMA test
	| %empty
	;
star_009 // Used in: dictorsetmaker, star_009
	: star_009 COMMA test COLON test
	| star_009 COMMA DOUBLESTAR expr
	| %empty
	;
star_COMMA_argument // Used in: arglist, star_COMMA_argument
	: star_COMMA_argument COMMA argument
	| %empty
	;
star_DOT_THREE_DOTS // Used in: import_from, star_DOT_THREE_DOTS
	: star_DOT_THREE_DOTS DOT
	| star_DOT_THREE_DOTS THREE_DOTS
	| %empty
	;

%%

#include <stdio.h>
void yyerror (char const *s)
{
	fprintf (stderr, "%d: %s with [%s]\n", yylineno, s, yytext);
}
