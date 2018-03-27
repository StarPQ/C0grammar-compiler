#define INITSTACK   0x7fffeffc
#define INITDATA    0x10010000
#define REGNUM      16
#define MAX_STACK   100000

#define INITADDR 1

#define CINT        0
#define CCHAR       1
#define TEMP        2
#define PARA        3
#define AINT        4
#define TCHAR       5
#define $SP         6
#define $RA         7

typedef struct{
    char id[5];
    char name[200];
    int type;
    int level;
    int inuse;
    int address;
}reg;
extern reg reglist[REGNUM+1];

typedef struct{
    char name[200];
    int type;
    int address;
    int level;
}stacknode;
extern stacknode mystack[MAX_STACK];

void genTarCode();
void opt();
