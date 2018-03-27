#define FUNCTION            0
#define MAINFUNCTION        1
#define INTTYPE             2
#define CHARTYPE            3
#define VARIABLE            4

#define NON                 0
#define CONST               1
#define ARRAY               2
#define RETURN              3
#define PARAMETER           4

#define MAX_tl              200
typedef struct{
    char name[50];
    int type;
    int isconst;
    int isarray;
    int isreturn;
    int value;
    int paranum;
    int level;
}symbol, *Link;

symbol symlist[MAX_tl];
int Top;
int Level;
void enterTable(char *name, int type, int detail, int value, int paranum);
void pop();
Link find(char *name);
Link deffind(char *name);
//there should have a type of error that define function
// not on level 0. reject that operation
