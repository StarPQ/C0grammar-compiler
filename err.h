// HEAD = {const if else switch case default return while printf
// scanf int char void { }
// MID = {, ) + - : }
//  END = {; }

// define error types
// err in lexing.c
#define LINELENGTHERR           1   // (ignore)line too long
#define LINECOUNTERR            2   // (ignore)program too long
#define INVALIDCHAR             3   // (ignore)ivalid char
#define REACHENDOFFILE          4   // (stop)program fatal error

// err in semantic.c
// in Program
#define VARSTATE_ERR            5   // (to HEAD)err when state a variable
#define FUNCSTATE_ERR           6   // (ignore && set as int)err when state a function
#define REDUNDUNT               7   // (ignore) lines afier main()
#define LACK_MAIN               8   // (ignore) lack main()

// in const state
#define LACK_SEMICOLON          9   // (to HEAD) lack ;

// in const def
#define DEFTYPE_ERR             10  // (to END) illegal type
#define SYMBOLCONFLICT_ERR      11  // (to END/MID) identifier illegal
#define CONSTNOTDEF_ERR         12  // (to END/MID) lack =
#define LACK_NUM                13  // (to END/MID) need number
#define LACK_CHAR               14  // (to END/MID) need char

// in state head
// #define SYMBOLCONFLICT_ERR      11  // (to END/MID) identifier illegal

// in var state
#define LACK_RMBRACK            15  // (ignore) array def error
// #define LACK_NUM                13  // (to END/MID) need number

// in var def
// #define SYMBOLCONFLICT_ERR      11  // (to END/MID) identifier illegal
// #define LACK_RMBRACK            28  // (to END/MID) array def error
// #define LACK_NUM                13  // (to END/MID) need number

// in func def
#define LACK_LBBRACK            16  // (ignore)
#define LACK_RSBRACK            17  // (ignore)

// in para list
#define PARATYPE_ERR            18  // (to MID/END) para not int/char
#define ORDER_ERR               19  // (ignore) get
// // in main func
// in sentence list
#define LACK_RBBRACK            20  // (ignore) lack } at end of function
// in sentence
#define NOTDEFINED_ERR          21  // (to HEAD) use a identifier not defined
#define LACK_BECOME             22  // (to HEAD) in become have no =
#define SOMETHINGELSE           23  // (to HEAD) use main as type
#define SENTENCE_ERR            24  // (to HEAD) use illegal head
// in factor
#define CALLNONRET_ERR          25  // (to MID/END)
#define ILLEGALSYM_ERR          26  // (to MID/END)
// in condition sentence
#define LACK_ELSE               27  // (ignore) have no else
#define LACK_LSBRACK            28  // (to HEAD) have no condition
// in loop
// in switch
#define CASE_ERR                29  // (to END)
#define LACK_COLON              30  // (tp END)

// err in table.c
#define FUNCDEFINFUNC_ERR       31
#define REDEFINE_ERR            32
#define OUTOFTABLE_ERR          33


// deal type
#define DONOTHING               0
#define TOHEAD                  1
#define TOEND                   2
#define TOENDMID                3
#define FATAL                   4
int err(int type);
FILE *erroutput;
