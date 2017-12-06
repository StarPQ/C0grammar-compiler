#define INITSTACK   0x7fffeffc
#define INITDATA    0x10010000
#define REGNUM      16
#define MAX_STACK   10000

#define CINT        0
#define CCHAR       1
#define TEMP        2
#define PARA        3
#define ADDR        4

typedef struct{
    char id[2];
    char name[200];
    int type;
    int level;
    int inuse;
}reg;
reg reglist[REGNUM];

typedef struct{
    char name[20];
    int type;
    int address;
    int level;
}stacknode;
stacknode stack[MAX_STACK];