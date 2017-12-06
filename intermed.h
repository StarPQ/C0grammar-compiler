#define MAXMIDCODE          1000
#define EMPTY               -1
#define ADDTEMP             0
#define LASTTEMP            1

void insertMid(char* head, char* var1, char* var2, char* var3);
void printmidlist();
void reset();
void midLabel(char* var1);
char* nextvar();
char* nextlabel();
void init();

typedef struct{
    char head[ 200 ];
    char var1[ 100 ];
    char var2[ 100 ];
    char var3[ 100 ];
}midcode;

midcode codelist[MAXMIDCODE];
extern int listtop;
