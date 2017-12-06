#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"intermed.h"
#include"asm.h"
#include"err.h"

int listcount = 0; // count midcode
int sp = INITSTACK;
int stacklevel = 0;
int stackcount = 0;
int stacktop = 0;
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
void reuse(int regnum){
    int i = listcount;
    for(i; i<listtop; i++){
        if(strcmp(codelist[i].head, "int") == 0 
            || strcmp(codelist[i].head, "char") == 0
            || strcmp(codelist[i].head, "void") == 0){
            break;
        }
        if(strcmp(codelist[i].head, reglist[regnum].name) == 0) return;
        if(strcmp(codelist[i].var1, reglist[regnum].name) == 0) return;
        if(strcmp(codelist[i].var2, reglist[regnum].name) == 0) return;
        if(strcmp(codelist[i].var3, reglist[regnum].name) == 0) return;
    }
    reglist[regnum].inuse = 0;
    return;
}
// get a reg if this is already in reg pool return reg number
// else apply a reg
int getreg(char* name){
    int i = 0;
    for(i = 0; i<REGNUM; i++){
        if(strcmp(reglist[i].name, name)  == 0){
            reuse(i);
            return i;
        }
    }
    return applyreg();
}
// get sth named name from stack
int toreg(char* name){
    int i;
    for(i = 0; i<stacktop; i++){
        if(stack[i].level == 0 || stack[i].level == stacklevel){
            if(strcmp(stack[i].name, name) == 0){
                int regnum = getreg()
            }
        }
    }
    //reglist[i].inuse = 1;

}
// find a var named name in reg and stack(move to reg) return the regnum that keep the var
int findvar(char* name){
    int i;
    for(i = 0; i<REGNUM; i++){
        if(strcmp(reglist[i].name, name)  == 0){
            //reglist[i].inuse = 1;
            return i;
        }
    }
    return toreg(name);
    //reglist[i].inuse = 1;

}
void tostack(int i){
    // reglist[regnum].inuse = 0;

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
// ignore this statement is fine
void tarFuncdef(){
    return;
}
// name the para in stack
// get it into reg?
void tarPara(){
    int i;
    for(i = 0; i<stackcount; i++){
        if(stack[i].level == stacklevel && stack[i].type == PARA){
            strcpy(stack[i].name, codelist[listcount].var2);
            if(strcmp(codelist[listcount].var1, "int") == 0)
                stack[i].type = TINT;
            else
                stack[i].type = TCHAR;
        }
    }
    
}
// push $ti
void tarPush(){
    int regnum;
    regnum = getreg(codelist[listcount].var1);
    reglist[regnum].inuse = 1;
    // passed para has no name
    // strcpy(reglist[regnum].name, codelist[listcount].var1);
    reglist[regnum].level = stacklevel;
    reglist[regnum].type = PARA;
    fprintf(target, "\t\tli\t%s\t%s\n", reglist[regnum].id, codelist[listcount].var3);
    tostack(regnum);
}
// save the current reg and stacklevel+1
void tarCall(){
    int i;
    for(i; i<REGNUM; i++){
        tostack(i);
    }
    stacklevel++;
}
// $ti = RET
void targetRET(){
    int regnum = getreg(codelist[listcount].head);
    reglist[regnum].inuse = 1;
    strcpy(reglist[regnum].name, codelist[listcount].head);
    reglist[regnum].level = stacklevel;
    fprintf(target, "\t\tmov\t%s\t$a0\n", reglist[regnum].id);
}
// ret $ti
void tarReturn(){
    int regnum = findvar(codelist[listcount].var1);
    fprintf(target, "\t\tmov\t$a0\t%s\n", reglist[regnum].id);
}
// var int name length
void tarVardef(){

    
}
// goto label
void tarGoto(){
    fprintf(target, "\t\tj\t%s\n", codelist[listcount].var1);
    fprintf(target, "\t\tnop\n");
}
// BZ $ti label
void tarBZ(){
    int regnum;
    regnum = getreg(codelist[listcount].var1);
    fprintf(target, "\t\tbez\t%s\t%s\n", reglist[regnum].id, codelist[listcount].var2);
    fprintf(target, "\t\tnop\n");
}
// $ti  $ti + $ti
void tarPLUS(){
    int reg2 = findvar(codelist[listcount].var1);
    int reg3 = findvar(codelist[listcount].var3);
    reuse(reg2);
    reuse(reg3);
    int reg1 = getreg(codelist[listcount].head);
    fprintf(target, "\t\tadd\t%s\t%s\t%s\n", reglist[reg1].id, reglist[reg2].id, reglist[reg3].id);
}
// $ti  $ti - $ti
void tarMINUS(){
    int reg2 = findvar(codelist[listcount].var1);
    int reg3 = findvar(codelist[listcount].var3);
    reuse(reg2);
    reuse(reg3);
    int reg1 = getreg(codelist[listcount].head);
    fprintf(target, "\t\tsub\t%s\t%s\t%s\n", reglist[reg1].id, reglist[reg2].id, reglist[reg3].id);

}
// $ti  $ti * $ti
void tarTIMES(){
    int reg2 = findvar(codelist[listcount].var1);
    int reg3 = findvar(codelist[listcount].var3);
    reuse(reg2);
    reuse(reg3);
    int reg1 = getreg(codelist[listcount].head);
    fprintf(target, "\t\tmul\t%s\t%s\n", reglist[reg2].id, reglist[reg3].id);
    fprintf(target, "\t\tmflo\t%s\n", reglist[reg1].id);

}
// $ti  $ti / $ti
void tarIDIV(){
    int reg2 = findvar(codelist[listcount].var1);
    int reg3 = findvar(codelist[listcount].var3);
    reuse(reg2);
    reuse(reg3);
    int reg1 = getreg(codelist[listcount].head);
    fprintf(target, "\t\t\t%s\t%s\n", reglist[reg2].id, reglist[reg3].id);
    fprintf(target, "\t\tmflo\t%s\n", reglist[reg1].id);

}
// $ti  $ti == $ti
void tarEQL(){
    int reg2 = findvar(codelist[listcount].var1);
    int reg3 = findvar(codelist[listcount].var3);
    reuse(reg2);
    reuse(reg3);
    int reg1 = getreg(codelist[listcount].head);
    fprintf(target, "\t\tand\t%s\t%s\t%s\n", reglist[reg1].id, reglist[reg2].id, reglist[reg3].id);
}
// $ti  $ti != $ti
void tarNEQ(){

}
// $ti  $ti > $ti
void tarGTR(){

}
// $ti  $ti >= $ti
void tarGEQ(){

}
// $ti  $ti < $ti
void tarLSS(){

}
// $ti  $ti <= $ti
void tarLEQ(){

}
// $ti  = name num
void tarfromList(){

}
// name num = $ti
void tartolist(){

}
// printf type detail
void tarPrint(){

}
// scanf name
void tarScan(){

}
//label :
void tarLabel(){
    fprintf(target, "%s:\n", codelist[listcount].head);
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
        else if(strcmp(codelist[listcount].var2, "RET") == 0) targetRET();
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
        else if(strcmp(codelist[listcount].var2, "=") == 0) tartolist();
        else if(strcmp(codelist[listcount].var1, "=") == 0) tarfromList();
        else if(strcmp(codelist[listcount].head, "main") == 0) tarFuncdef();
        else err(MID_ERR);
    }
}
