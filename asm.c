#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"intermed.h"
#include"asm.h"
#include"err.h"

int listcount = 0; // count midcode
int sp = INITSTACK;
int stacklevel = 0;
int FIFO = 0;
FILE* target;
// apply a reg if the reg pool is full save the earliest reg to stack
// and return that reg number
int applyreg(){
    int i = 0;
    for(i = 0; i<REGNUM; i++){
        if(reglist[i].inuse == 0){
            return i;
        }
    }
    tostack(FIFO);
    reglist[FIFO].inuse = 1;
    FIFO++;
    return FIFO-1;
}
// if this is the last time to use this temp
// 
int reuse(char* name){
    int i = listcount;
    for(i; i<listtop; i++){
        if(strcmp(codelist[i].head, "int") == 0 
            || strcmp(codelist[i].head, "char") == 0
            || strcmp(codelist[i].head, "void") == 0){
            break;
        }
        if(strcmp(codelist[i].head, name) == 0) return 1;
        if(strcmp(codelist[i].var1, name) == 0) return 1;
        if(strcmp(codelist[i].var2, name) == 0) return 1;
        if(strcmp(codelist[i].var3, name) == 0) return 1;
    }
    return 0;
}
// get a reg if this is already in reg pool return reg number
// else apply a reg
int getreg(char* name){
    int i = 0;
    for(i = 0; i<REGNUM; i++){
        if(strcmp(reglist[i].name, name)  == 0){
            reglist[i].inuse = reuse(name);
            return i;
        }
    }
    return applyreg();
}
// get sth named name from stack
void toreg(char* name){

}
void tostack(int i){

}
void tarConstdef(int type){
    int regnum;
    regnum = getreg(codelist[listcount].var1);
    reglist[regnum].inuse = 1;
    strcpy(reglist[regnum].name, codelist[listcount].var1);
    reglist[regnum].level = stacklevel;
    reglist[regnum].type = type;
    fprintf(target, "\t\tli\t%s\t%s\n", reglist[regnum].id, codelist[listcount].var3);
}
void tarFuncdef(){
    return;
}
void tarPara(){
    int regnum;
    regnum = getreg(codelist[listcount].var1);
    reglist[regnum].inuse = 1;
    strcpy(reglist[regnum].name, codelist[listcount].var1);
    reglist[regnum].level = stacklevel;
    reglist[regnum].type = PARA;
}
void tarPush(){int regnum;
    regnum = getreg(codelist[listcount].var1);
    reglist[regnum].inuse = 1;
    // passed para has no name
    // strcpy(reglist[regnum].name, codelist[listcount].var1);
    reglist[regnum].level = stacklevel;
    reglist[regnum].type = PARA;
    fprintf(target, "\t\tli\t%s\t%s\n", reglist[regnum].id, codelist[listcount].var3);
    tostack(regnum);
}
void tarCall(){
    int i;
    for(i; i<REGNUM; i++){
        tostack(i);
    }
    stacklevel++;
}
void targetRET(){

}
void tarReturn(){

}
void tarVardef(){

}
void tarGoto(){

}
void tarBZ(){

}
void tarOperation(){

}
void tarPLUS(){

}
void tarMINUS(){

}
void tarTIMES(){

}
void tarIDIV(){

}
void tarEQL(){

}
void tarNEQ(){

}
void tarGTR(){

}
void tarGEQ(){

}
void tarLSS(){

}
void tarLEQ(){

}
void tarfromList(){

}
void tartolist(){

}
void tarPrint(){

}
void tarScan(){

}
void tarLabel(){
    fprintf(target, "%s\n", codelist[listcount].head);
}
void tarBecome(){
    
}
void genTarCode(){
    int i;
    target = fopen("target.asm", "w+");
    for(i = 0; i<REGNUM; i++){
        reglist[i].inuse = 0;
        reglist[i].type = TEMP;
        itoa(i+8, reglist[i].id, 10);
        memset(reglist[i].name, 0, 200*sizeof(char));
    }
    fprintf(target, "\t.text\n");
    fprintf(target, "\t\tli\t$t9\t0x7fffeffc\t#global stack bottom\n");
    fprintf(target, "\t\tli\t$t8\t0x10010000\t#save word\n");
    for(listcount = 0; listcount <= listtop; listcount++){
        if(strcmp(codelist[listcount].head, "const int") == 0) tarConstdef(CINT);
        else if(strcmp(codelist[listcount].head, "const char") == 0) tarConstdef(CCHAR);
        else if(strcmp(codelist[listcount].head, "int") == 0) tarFuncdef();
        else if(strcmp(codelist[listcount].head, "char") == 0) tarFuncdef();
        else if(strcmp(codelist[listcount].head, "void") == 0) tarFuncdef();
        else if(strcmp(codelist[listcount].head, "para") == 0) tarPara();
        else if(strcmp(codelist[listcount].head, "push") == 0) tarPush();
        else if(strcmp(codelist[listcount].head, "call") == 0) tarCall();
        else if(strcmp(codelist[listcount].head, "var") == 0) tarVardef();
        else if(strcmp(codelist[listcount].head, "goto") == 0) tarGoto();
        else if(strcmp(codelist[listcount].head, "ret") == 0) tarReturn();
        else if(strcmp(codelist[listcount].head, "printf") == 0) tarPrint();
        else if(strcmp(codelist[listcount].head, "scanf") == 0) tarScan();
        else if(strcmp(codelist[listcount].head, "BZ") == 0) tarBZ();
        else if(strcmp(codelist[listcount].var1, ":") == 0) tarLabel();
        else if(strcmp(codelist[listcount].var2, "+") == 0) tarPLUS();
        else if(strcmp(codelist[listcount].var2, "-") == 0) tarMINUS();
        else if(strcmp(codelist[listcount].var2, "*") == 0) tarTIMES();
        else if(strcmp(codelist[listcount].var2, "/") == 0) tarIDIV();
        else if(strcmp(codelist[listcount].var2, "==") == 0) tarEQL();
        else if(strcmp(codelist[listcount].var2, "!=") == 0) tarNEQ();
        else if(strcmp(codelist[listcount].var2, ">") == 0) tarGTR();
        else if(strcmp(codelist[listcount].var2, ">=") == 0) tarGEQ();
        else if(strcmp(codelist[listcount].var2, "<") == 0) tarLSS();
        else if(strcmp(codelist[listcount].var2, "<=") == 0) tarLEQ();
        else if(strcmp(codelist[listcount].var2, "+") == 0) tarPLUS();
        else if(strcmp(codelist[listcount].var2, "=") == 0) tarBecome();
        else if(strcmp(codelist[listcount].var1, "=") == 0) tarBecome();
        else if(strcmp(codelist[listcount].head, "main") == 0) tarFuncdef();
        else err(MID_ERR);
    }
}
