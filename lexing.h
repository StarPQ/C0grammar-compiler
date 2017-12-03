// basic
#define PLUS        0       // +
#define MINUS       1       // -
#define TIMES       2       // *
#define IDIV        3       // /
#define EQL         4       // ==
#define NEQ         5       // !=
#define GTR         6       // >
#define GEQ         7       // >=
#define LSS         8       // <
#define LEQ         9       // <=

// symbols
#define MAINSY      10
#define CONSTSY     11
#define IFSY        12
#define ELSESY      13
#define SWITCHSY    14
#define CASESY      15
#define DEFAULTSY   16
#define RETURNSY    17
#define WHILESY     18
#define PRINTFSY    19
#define SCANFSY     20
// types
#define INTSY       21
#define CHARSY      22
#define VOIDSY      23

#define LSBRACK     24       // (
#define RSBRACK     25       // )
#define LMBRACK     26       // [
#define RMBRACK     27       // ]
#define LBBRACK     28       // {
#define RBBRACK     29       // }
#define COMMA       30       // ,
#define SEMICOLON   31       // ;
#define COLON       32       // :
//#define QUOTE       33       // '
//#define QUOTES      34       // "
#define BECOMES     33       // =
// identifier
#define IDEN        34
#define NUMBER      35
#define STRING      36
#define CHAR        37

#define MAX_wl      50       // max word length
#define MAX_nl      10       // max number length
#define MAX_ll      500      // max line length
#define MAX_lc      200      // max line count
#define MAX_sl      100      // max string length

extern char word[15][10];
extern int wsym[15];
extern char buf[MAX_sl];
extern int num;
extern char sym[10];
extern int symid;
extern int cc;             //char count
extern int lc;             //line count
extern char ch;

int nextsym();
int nextch();
int isword();
void wordtest();
