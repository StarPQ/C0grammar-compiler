#include<stdio.h>
#include<string.h>
#include<ctype.h>
#include"lexing.h"
#include"err.h"
#include"global.h"

int printdetails = 1;
int cc = 0;             //char count
int lc = 0;             //line count
char ch;                //the character read now
char buf[MAX_sl];
int num = 0;
char sym[10];
int symid = 0;

char word[15][10] = {
    "main", "const", "if", "else", "switch", "case", "default",
    "return", "while", "printf", "scanf",
    "int", "char", "void"
};

char wsym[15][10] = {
    "MAINSY", "CONSTSY", "IFSY", "ELSESY", "SWITCHSY", "CASESY", "DEFAULTSY",
    "RETURNSY", "WHILESY", "PRINTFSY", "SCANFSY",
    "INTCON", "CHARCON", "VOIDCON"
};

// read next character
// as all characters are decoded as ascii so return value is int type
int nextch(){
    ch = fgetc(inputfile);
    //printf("%c\t", ch);
    //ignore ' ' and '\t'
    /*while(ch == ' ' || ch == '\t'){
        ch = fgetc(inputfile);
    }*/
    //if reach the end of the line
    if(ch == '\n'){
        lc++;
        cc = 0;
        if(lc > MAX_lc) err(LINECOUNTERR);
        //ch = fgetc(inputfile);
    }
    else{
        cc++;
        if(cc > MAX_ll) err(LINELENGTHERR);
    }
    if(isupper(ch)) ch = tolower(ch);//ignore upper alpha
    return 0;
}

int isword(){
    int i = 0;
    for(i = 0; i < 14; i++){
        if(strcmp(word[i], buf)==0)
            return i;
    }
    return -1;
}

int nextsym(){
    //nextch();
    int i = 0;
    memset(buf, 0, sizeof(char)*MAX_wl);
    num = 0;
    while(isspace(ch) && ch != EOF){
        nextch();
    }
    if(ch == '\n' || ch == '\r'){
        nextch();
    }
    if(ch == EOF) return 1;
    buf[i] = ch;
    if(isalpha(ch)){
        do{
            if(i < MAX_wl){
                buf[i] = ch;
                i++;
            }
            nextch();
        }while(isalpha(ch) || isdigit(ch) || ch == '_');
        if((i = isword()) >= 0){
            strcpy(sym, wsym[i]);
            symid = i + 10;
        }
        else{
            strcpy(sym, "IDEN");
            symid = IDEN;
        }
    }
    else if(isdigit(ch)){
        do{
            if(i < MAX_wl){
                num = num*10 + ch - '0';
                i++;
            }
            nextch();
        }while(isdigit(ch));
        strcpy(sym, "NUMBER");
        symid = NUMBER;
    }
    else if(ch == '('){
                strcpy(sym, "LSBRACK");
                symid = LSBRACK;
                nextch();
            }
    else if(ch == ')'){
                strcpy(sym, "RSBRACK");
                symid = RSBRACK;
                nextch();
            }
    else if(ch == '['){
                strcpy(sym, "LMBRACK");
                symid = LMBRACK;
                nextch();
            }
    else if(ch == ']'){
                strcpy(sym, "RMBRACK");
                symid = RMBRACK;
                nextch();
            }
    else if(ch == '{'){
                strcpy(sym, "LBBRACK");
                symid = LBBRACK;
                nextch();
            }
    else if(ch == '}'){
                strcpy(sym, "RBBRACK");
                symid = RBBRACK;
                nextch();
            }
    else if(ch == ','){
                strcpy(sym, "COMMA");
                symid = COMMA;
                nextch();
            }
    else if(ch == ';'){
                strcpy(sym, "SEMICOLON");
                symid = SEMICOLON;
                nextch();
            }
    else if(ch == ':'){
                strcpy(sym, "COLON");
                symid = COLON;
                nextch();
            }
    else if(ch == '\''){
                nextch();
                while(ch != '\''){
                    if(isalnum(ch) || ch == '+' || ch == '-' || ch == '*' || ch == '/' )
                        buf[i] = ch;
                    else{
                        err(INVALIDCHAR);
                    }
                    nextch();
                    if(ch == EOF){
                        err(REACHENDOFFILE);
                        return 2;
                    }
                }
                strcpy(sym, "CHAR");
                symid = CHAR;
                nextch();
            }
    else if(ch == '"'){
                nextch();
                do{
                    if(ch == 32 || ch == 33 || (ch >=35 && ch <=126)){
                        if(i < MAX_sl){
                            buf[i] = ch;
                            i++;
                        }
                    }
                    else{
                        err(INVALIDCHAR);
                    }
                    nextch();
                    if(ch == EOF){
                        err(REACHENDOFFILE);
                        return 2;
                    }
                }while(ch != '"');
                strcpy(sym, "STRING");
                symid = STRING;
                nextch();
            }
    else if(ch == '='){
                nextch();
                if(ch == '='){
                    strcpy(sym, "EQL");
                    symid = EQL;
                    buf[i+1] = ch;
                    nextch();
                }
                else{
                    strcpy(sym, "BECOMES");
                    symid = BECOMES;
                }
            }
    else if(ch == '+'){
                strcpy(sym, "PLUS");
                symid = PLUS;
                nextch();
            }
    else if(ch == '-'){
                strcpy(sym, "MINUS");
                symid = MINUS;
                nextch();
            }
    else if(ch == '*'){
                strcpy(sym, "TIMES");
                symid = TIMES;
                nextch();
            }
    else if(ch == '/'){
                strcpy(sym, "IDIV");
                symid = IDIV;
                nextch();
            }
    else if(ch == '<'){
                nextch();
                if(ch == '='){
                    strcpy(sym, "LEQ");
                    symid = LEQ;
                    buf[i+1] = ch;
                    nextch();
                }
                else{
                    strcpy(sym, "LSS");
                    symid = LSS;
                }
            }
    else if(ch == '>'){
                nextch();
                if(ch == '='){
                    strcpy(sym, "GEQ");
                    symid = GEQ;
                    buf[i+1] = ch;
                    nextch();
                }
                else{
                    strcpy(sym, "GTR");
                    symid = GTR;
                }
            }
    else if(ch == '!'){
                nextch();
                if(ch == '='){
                    strcpy(sym, "NEQ");
                    symid = NEQ;
                    buf[i+1] = ch;
                    nextch();
                }
                else
                    err(INVALIDCHAR);
                    nextch();
                    return 2;
            }
    else{
        err(INVALIDCHAR);
        nextch();
        return 2;
    }
    return 0;
}

void wordtest(){
    FILE *outputile = fopen("_result", "w");
    int i;
    int count = 0;
    while((i = nextsym()) != 1){
        if(printdetails && i == 0){
            count++;
            if(symid == INTCON)
                fprintf(outputile, "%d %s\t%d\n", count, sym, num);
            else
                fprintf(outputile, "%d %s\t%s\n",count,  sym, buf);
        }
    };
    fclose(outputile);
    printf("finish word analysis!\n");
}