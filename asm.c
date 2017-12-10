#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"intermed.h"
#include"asm.h"
#include"err.h"

reg reglist[REGNUM+1];
stacknode mystack[MAX_STACK];
int listcount = 0; // count midcode
int sp = INITSTACK;
int stacklevel = 0;
int stackcount = 0; // global stacknode count
int localstackcount = 0; // stacknode count in current lavel
int LRU[REGNUM];
int lscsave[200];
int datacount = 0;
FILE* target;
void setLRU(int i){
    int tmp = LRU[i];
    for(i; i<REGNUM-1; i++){
        LRU[i] = LRU[i+1];
    }
    LRU[REGNUM-1] = tmp;
}
void printstack(){
    fprintf(erroutput, "%s\t%s\t%s\t%s\n", codelist[listcount].head, codelist[listcount].var1, codelist[listcount].var2, codelist[listcount].var3);
    int i;
    for(i = 0; i<stackcount; i++){
        fprintf(erroutput, "mystack-->%s %d\n", mystack[i].name, mystack[i].level);
    }
}
// apply a reg if the reg pool is full save the earliest reg to mystack
// and return that reg number
int applyreg(){
    int i = 0;
    for(i = 0; i<REGNUM; i++){
        if(reglist[i].inuse == 0){
            reglist[i].inuse = 1;
            reglist[i].type = TEMP;
            reglist[i].level = stacklevel;
            reglist[i].address = INITADDR;
            setLRU(i);
            return i;
        }
    }
    i = LRU[0];
    tostack(i);
    reglist[i].inuse = 1;
    reglist[i].type = TEMP;
    reglist[i].level = stacklevel;
    reglist[i].address = INITADDR;
    setLRU(0);
    return i;
}
// if a var is modified in reg synchronize it with the stack
void sync(int i){
    if(reglist[i].type != TEMP){
        if(reglist[i].level == 0)
            fprintf(target, "\tsw\t%s\t%d($gp)\n", reglist[i].id, reglist[i].address);
        else
            fprintf(target, "\tsw\t%s\t%d($fp)\n", reglist[i].id, reglist[i].address);
    }
    fprintf(erroutput, "sync %s level: %d\n", reglist[i].name, reglist[i].level);
}
// if this is the last time to use this temp
//
void reuse(int regnum){
    if(regnum == REGNUM) return;
    /*int i = listcount;
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
    reglist[regnum].inuse = 0;*/
    return;
}
// get sth named name from mystack
int toreg(char* name){
    int i;
    for(i = 0; i<stackcount; i++){
        if(mystack[i].level == stacklevel && strcmp(mystack[i].name, name) == 0){
            // in current level
            int regnum = applyreg();
            strcpy(reglist[regnum].name, mystack[i].name);
            reglist[regnum].type = mystack[i].type;
            reglist[regnum].level = mystack[i].level;
            reglist[regnum].address = mystack[i].address;
            reglist[regnum].inuse = 1;
            fprintf(target, "\tlw\t%s\t%d($fp)\t#%s-->%d\n", reglist[regnum].id, reglist[regnum].address, mystack[i].name, mystack[i].address);
            return regnum;
        }
        else if(mystack[i].level == 0 && strcmp(mystack[i].name, name) == 0){
            // in global
            int regnum = applyreg();
            strcpy(reglist[regnum].name, mystack[i].name);
            reglist[regnum].type = mystack[i].type;
            reglist[regnum].level = mystack[i].level;
            reglist[regnum].address = mystack[i].address;
            reglist[regnum].inuse = 1;
            fprintf(target, "\tlw\t%s\t%d($gp)\t#%s-->%d\n", reglist[regnum].id, reglist[regnum].address, mystack[i].name, mystack[i].address);
            return regnum;
        }
    }
    //reglist[i].inuse = 1;
    fprintf(erroutput, "%s\t%s\t%s\t%s\n", codelist[listcount].head, codelist[listcount].var1, codelist[listcount].var2, codelist[listcount].var3);
    fprintf(erroutput, "undefined: %s %d\n", name, stacklevel);
    printstack();
}
// find a var named name in reg and mystack(move to reg) return the regnum that keep the var
int findvar(char* name){
    int i;
    for(i = 0; i<REGNUM; i++){
        if(strcmp(reglist[i].name, name)  == 0 && reglist[i].inuse == 1){
            setLRU(i);
            return i;
        }
    }
    return toreg(name);

}
void tostack(int i){
    // reglist[regnum].inuse = 0;
    fprintf(erroutput, "---addr is %d\n", reglist[i].address);
    if(reglist[i].address == INITADDR){
        fprintf(erroutput, "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
        mystack[stackcount].level = reglist[i].level;
        mystack[stackcount].type = reglist[i].type;
        strcpy(mystack[stackcount].name, reglist[i].name);
        mystack[stackcount].address = - 4*localstackcount;
        fprintf(target, "\tsw\t%s\t\t($sp)\t#%s<--%d\n", reglist[i].id, mystack[stackcount].name, mystack[stackcount].address);
        fprintf(erroutput, "store: %s %d\t#%s<--%d\n", reglist[i].id, mystack[stackcount].level, mystack[stackcount].name, mystack[stackcount].address);
        localstackcount++;
        stackcount++;
        fprintf(target, "\tsubi\t$sp\t$sp\t4\n");
    }
    else{
        if(reglist[i].level == 0)
            fprintf(target, "\tsw\t%s\t%d($gp)\t#%s<--%d\n", reglist[i].id, mystack[stackcount].address, mystack[stackcount].name, mystack[stackcount].address);
        else
            fprintf(target, "\tsw\t%s\t%d($fp)\n", reglist[i].id, reglist[i].address);
        fprintf(erroutput, "store: %s %d\t#%s<--%d\n", reglist[i].id, mystack[stackcount].level, mystack[stackcount].name, mystack[stackcount].address);
    }
    reglist[i].inuse = 0;
}

// ignore this statement is fine
void tarFuncdef(){
    // when got funcdef read paras
    stacklevel++;
    localstackcount = 0;
    fprintf(erroutput, "L+%d\n", stacklevel);
}
// name the para in mystack
// get it into reg?
// par int name
void tarPara(){
    /*
    int reg1 = applyreg();
    reglist[reg1].address = - 4*localstackcount;
    strcpy(reglist[reg1].name, codelist[listcount].var2);
    if(strcmp(codelist[listcount].var1, "int") == 0)
        reglist[reg1].type = CINT;
    else
        reglist[reg1].type = CCHAR;
    reglist[reg1].level = stacklevel;
    */
    //tostack(reg1);

    int i = stackcount;// this the bottom of this level
    mystack[i].level = 1;
    strcpy(mystack[i].name, codelist[listcount].var2);
    if(strcmp(codelist[listcount].var1, "int") == 0)
        mystack[i].type = CINT;
    else
        mystack[i].type = CCHAR;
    mystack[i].address = - 4*localstackcount;
    stackcount++;
    localstackcount++;
    printstack();
    //fprintf(target, "\tsubi\t$sp\t$sp\t4\n");
    fprintf(erroutput, "%s\t%s\t%s\t%s\n", codelist[listcount].head, codelist[listcount].var1, codelist[listcount].var2, codelist[listcount].var3);
    fprintf(erroutput, "para: %s %d\n", mystack[i].name, mystack[i].level);
    /*
    int reg1 = applyreg(codelist[listcount].var2);
    reglist[reg1].address = - 4*localstackcount;
    localstackcount++;
    fprintf(target, "\t\tlw\t%s\t%d\t($t8)", reglist[reg1].address);
    */
}
// push $ti
void tarPush(){
    int regnum = findvar(codelist[listcount].var1);
    while(mystack[stackcount].type == TEMP && localstackcount>0){
        localstackcount--;
        stackcount--;
        fprintf(target, "\taddi\t$sp\t$sp\t4\n");
    }
    fprintf(target, "\tsw\t%s\t($sp)\n", reglist[regnum].id);
    fprintf(target, "\tsubi\t$sp\t$sp\t4\n");
    mystack[stackcount].level = 2;
    mystack[stackcount].address = - 4*localstackcount;
    mystack[stackcount].type = PARA;
    strcpy(mystack[stackcount].name, "\0");
    int i;
    for(i = 0; i<REGNUM; i++){
        reglist[i].inuse = 0;
    }
}
// the last para to push
// push and jump
void tarPushJ(){
    int regnum = findvar(codelist[listcount].var1);
    while(mystack[stackcount].type == TEMP && localstackcount>0){
        localstackcount--;
        stackcount--;
        fprintf(target, "\taddi\t$sp\t$sp\t4\n");
    }
    fprintf(target, "\tsw\t%s\t($sp)", reglist[regnum].id);
    mystack[stackcount].level = 2;
    mystack[stackcount].address = - 4*localstackcount;
    mystack[stackcount].type = PARA;
    strcpy(mystack[stackcount].name, "\0");

    // refresh all reg
//    stacklevel++;
}
void tarjal(){
    int i;
    for(i = 0; i<REGNUM; i++){
        reglist[i].inuse = 0;
    }
    stackcount = stackcount - localstackcount;

    //fprintf(target, "\taddi\t$fp\t$sp\t%d\n", 4*localstackcount);
    fprintf(target, "\tjal\t%s\n", codelist[listcount].var1);
    fprintf(target, "\tnop\n");
    //recover sp and $ra
    fprintf(target, "\taddi\t$sp\t$sp\t12\n");
    fprintf(target, "\tlw\t$fp\t-4($sp)\n");
    fprintf(target, "\tlw\t$ra\t-8($sp)\n");
    localstackcount = lscsave[stacklevel];
}
// save the current reg and stacklevel+1
void tarCall(){
    int i;
    //save reg
    for(i; i<REGNUM; i++){
        if(reglist[i].inuse) tostack(i);
    }
    // save old fp
    fprintf(target, "\tsubi\t$sp\t$sp\t12\n");
    fprintf(target, "\tsw\t$fp\t8($sp)\n");
    fprintf(target, "\tsw\t$ra\t4($sp)\n");
    lscsave[stacklevel] = localstackcount;
    // refresh fp
    //fprintf(target, "\tmove\t$fp\t$sp\n");
    localstackcount = 0;
    fprintf(target, "\tmove\t$fp\t$sp\n");
    // when return find and relode ra and jr $ra
}
// $ti = RET
void targetRET(){
    int regnum = applyreg();
    strcpy(reglist[regnum].name, codelist[listcount].head);
    fprintf(target, "\tmove\t%s\t$v0\n", reglist[regnum].id);
}
// ret $ti  / ret
void tarReturn(){
    if(strcmp(codelist[listcount].var1, "\0") == 0){
        // return
    }
    else{
        int regnum = findvar(codelist[listcount].var1);
        fprintf(target, "\tmove\t$v0\t%s\n", reglist[regnum].id);
    }

    fprintf(target, "\tmove\t$sp\t$fp\n", 4*localstackcount);
    fprintf(target, "\tjr\t$ra\n");
    fprintf(target, "\tnop\n");

}
void tarend(){
    stackcount = stackcount - localstackcount;
    localstackcount = 0;
    int i;
    for(i = 0; i<REGNUM; i++){
        reglist[i].inuse = 0;
    }
    stacklevel--;
    fprintf(erroutput, "L-%d\n", stacklevel);
}
void tarConstdef(int type){
    int regnum;
    regnum = applyreg();
    reglist[regnum].inuse = 1;
    strcpy(reglist[regnum].name, codelist[listcount].var1);
    reglist[regnum].type = type;
    fprintf(target, "\tli\t%s\t%s\n", reglist[regnum].id, codelist[listcount].var3);
    tostack(regnum);
}
// var int name length
void tarVardef(){
    if(strcmp(codelist[listcount].var3, "\0") == 0){
        // is a normal var
        int reg1 = applyreg();
        strcpy(reglist[reg1].name, codelist[listcount].var2);
        if(strcmp(codelist[listcount].var1, "int") == 0){
            reglist[reg1].type = CINT;
        }
        else{
            reglist[reg1].type = CCHAR;
        }
        tostack(reg1);
    }
    else{
        // is a array
        int i = 0;
        for(i; i<atoi(codelist[listcount].var3); i++){
            char tmp[200] = {'\0'}, n[3] = {'\0'};
            strcpy(tmp, codelist[listcount].var2);
            strcat(tmp, "#");
            itoa(i, n, 10);
            strcat(tmp, n);
            int reg1 = applyreg();
            strcpy(reglist[reg1].name, tmp);
            if(strcmp(codelist[listcount].var1, "int") == 0){
                reglist[reg1].type = CINT;
            }
            else{
                reglist[reg1].type = CCHAR;
            }
            tostack(reg1);
        }
    }
}
// goto label
void tarGoto(){
    fprintf(target, "\tj\t%s\n", codelist[listcount].var1);
    fprintf(target, "\tnop\n");
}
// BZ $ti label
void tarBZ(){
    int regnum;
    regnum = findvar(codelist[listcount].var1);
    fprintf(target, "\tbeq\t%s\t$0\t%s\n", reglist[regnum].id, codelist[listcount].var2);
    fprintf(target, "\tnop\n");
}
void tarli(){
    int reg1 = applyreg();
    strcpy(reglist[reg1].name, codelist[listcount].var1);
    fprintf(target, "\tli\t%s\t%s\n", reglist[reg1].id, codelist[listcount].var2);
}
// $ti  $ti + $ti
void tarPLUS(){
    int reg2;
    if(strcmp(codelist[listcount].var1, "\0") == 0) reg2 = REGNUM;
    else reg2 = findvar(codelist[listcount].var1);
    int reg3 = findvar(codelist[listcount].var3);
    int reg1 = applyreg();
    strcpy(reglist[reg1].name, codelist[listcount].head);
    reuse(reg2);
    reuse(reg3);
    fprintf(target, "\tadd\t%s\t%s\t%s\n", reglist[reg1].id, reglist[reg2].id, reglist[reg3].id);
}
// $ti  $ti - $ti
void tarMINUS(){
    int reg2;
    if(strcmp(codelist[listcount].var1, "\0") == 0) reg2 = REGNUM;
    else reg2 = findvar(codelist[listcount].var1);
    int reg3 = findvar(codelist[listcount].var3);
    int reg1 = applyreg();
    strcpy(reglist[reg1].name, codelist[listcount].head);
    reuse(reg2);
    reuse(reg3);
    fprintf(target, "\tsub\t%s\t%s\t%s\n", reglist[reg1].id, reglist[reg2].id, reglist[reg3].id);

}
// $ti  $ti * $ti
void tarTIMES(){
    int reg2;
    if(strcmp(codelist[listcount].var1, "\0") == 0) reg2 = REGNUM;
    else reg2 = findvar(codelist[listcount].var1);
    int reg3 = findvar(codelist[listcount].var3);
    int reg1 = applyreg();
    strcpy(reglist[reg1].name, codelist[listcount].head);
    reuse(reg2);
    reuse(reg3);
    fprintf(target, "\tmult\t%s\t%s\n", reglist[reg2].id, reglist[reg3].id);
    fprintf(target, "\tmflo\t%s\n", reglist[reg1].id);

}
// $ti  $ti / $ti
void tarIDIV(){
    int reg2;
    if(strcmp(codelist[listcount].var1, "\0") == 0) reg2 = REGNUM;
    else reg2 = findvar(codelist[listcount].var1);
    int reg3 = findvar(codelist[listcount].var3);
    int reg1 = applyreg();
    strcpy(reglist[reg1].name, codelist[listcount].head);
    reuse(reg2);
    reuse(reg3);
    fprintf(target, "\tdiv\t%s\t%s\n", reglist[reg2].id, reglist[reg3].id);
    fprintf(target, "\tmflo\t%s\n", reglist[reg1].id);

}
// $ti  $ti == $ti  1: ==0 0:!=0
void tarEQL(){
    tarMINUS();
    listcount++;
    int reg1 = findvar(codelist[listcount].var1);
    fprintf(target, "\tbne\t%s\t$0\t%s\n", reglist[reg1].id, codelist[listcount].var2);
}
// $ti  $ti != $ti  1: !=0 0:==0
void tarNEQ(){
    tarMINUS();
    listcount++;
    int reg1 = findvar(codelist[listcount].var1);
    fprintf(target, "\tbeq\t%s\t$0\t%s\n", reglist[reg1].id, codelist[listcount].var2);
}
// $ti  $ti > $ti 1: >0 0: <=0
void tarGTR(){
    tarMINUS();
    listcount++;
    int reg1 = findvar(codelist[listcount].var1);
    fprintf(target, "\tblez\t%s\t%s\n", reglist[reg1].id, codelist[listcount].var2);
}
// $ti  $ti >= $ti  1: >=0 0: <0
void tarGEQ(){
    tarMINUS();
    listcount++;
    int reg1 = findvar(codelist[listcount].var1);
    fprintf(target, "\tbltz\t%s\t%s\n", reglist[reg1].id, codelist[listcount].var2);
}
// $ti  $ti < $ti   1: <0 0: >=0
void tarLSS(){
    tarMINUS();
    listcount++;
    int reg1 = findvar(codelist[listcount].var1);
    fprintf(target, "\tbgez\t%s\t%s\n", reglist[reg1].id, codelist[listcount].var2);
}
// $ti  $ti <= $ti   1: <=0 0: >0
void tarLEQ(){
    tarMINUS();
    listcount++;
    int reg1 = findvar(codelist[listcount].var1);
    fprintf(target, "\tbgtz\t%s\t%s\n", reglist[reg1].id, codelist[listcount].var2);
}
// $ti  = name num / $ti
void tarfromList(){
    char tmp[200];
    int reg2;
    if(strcmp(codelist[listcount].var3, "\0") == 0){
        strcpy(tmp, codelist[listcount].var2);
        reg2 = findvar(tmp);
    }
    else if(codelist[listcount].var3[0] == '$'){
        int placereg = findvar(codelist[listcount].var3);
        int treg = applyreg();
        fprintf(target, "\tli\t%s\t-4\n", reglist[treg].id);
        fprintf(target, "\tmul\t%s\t%s\t%s\n", reglist[treg].id, reglist[placereg].id, reglist[treg].id);// get length to array root
        strcpy(tmp, codelist[listcount].var2);
        strcat(tmp, "#0");
        placereg = findvar(tmp);//array root
        reg2 = applyreg();
        if(reglist[placereg].level == 0){
            fprintf(target, "\tadd\t%s\t%s\t$gp\n", reglist[treg].id, reglist[treg].id);
            fprintf(target, "\tlw\t%s\t%d($gp)\n", reglist[reg2].id, reglist[placereg].address);
        }
        else{
            fprintf(target, "\tadd\t%s\t%s\t$fp\n", reglist[treg].id, reglist[treg].id);
            fprintf(target, "\tlw\t%s\t%d($fp)\n", reglist[reg2].id, reglist[placereg].address);
        }
        reglist[treg].inuse = 0;
        reglist[placereg].inuse = 0;
    }
    else{
        strcpy(tmp, codelist[listcount].var2);
        strcat(tmp, "#");
        strcat(tmp, codelist[listcount].var3);
        reg2 = findvar(tmp);
    }

    int reg1 = applyreg();
    strcpy(reglist[reg2].name, codelist[listcount].head);
    reuse(reg2);
    fprintf(target, "\tmove\t%s\t%s\n", reglist[reg1].id, reglist[reg2].id);
}
// name num = $ti
void tartolist(){
    char tmp[200];
    if(strcmp(codelist[listcount].var1, "\0") == 0){
        strcpy(tmp, codelist[listcount].head);
    }
    else{
        strcpy(tmp, codelist[listcount].head);
        strcat(tmp, "#");
        strcat(tmp, codelist[listcount].var1);
    }

    int reg1 = findvar(tmp);
    int reg2 = findvar(codelist[listcount].var3);
    reuse(reg2);
    fprintf(target, "\tadd\t%s\t%s\t$0\n", reglist[reg1].id, reglist[reg2].id);
    sync(reg1);
}
// printf type detail
void tarPrint(){
    if(strcmp(codelist[listcount].var1, "string") == 0){
        fprintf(target, "\tli\t$v0\t4\n");
        fprintf(target, "\tla\t$a0\tstring%d\n", datacount++);
        fprintf(target, "\tsyscall\n");
    }
    else{
        int reg1 = findvar(codelist[listcount].var2);
        if(reglist[reg1].type == CCHAR){
            fprintf(target, "\tli\t$v0\t11\n");
            fprintf(target, "\tmove\t$a0\t%s\n", reglist[reg1].id);
            fprintf(target, "\tsyscall\n");
        }
        else{
            fprintf(target, "\tli\t$v0\t1\n");
            fprintf(target, "\tmove\t$a0\t%s\n", reglist[reg1].id);
            fprintf(target, "\tsyscall\n");
        }
    }
}
// scanf name
void tarScan(){
    int reg1 = findvar(codelist[listcount].var1);
    if(reglist[reg1].type == CINT){
        fprintf(target, "\tli\t$v0\t5\n");
        fprintf(target, "\tsyscall\n");
        fprintf(target, "\tmove\t%s\t$v0\n", reglist[reg1].id);
    }
    else{
        fprintf(target, "\tli\t$v0\t12\n");
        fprintf(target, "\tsyscall\n");
        fprintf(target, "\tmove\t%s\t$v0\n", reglist[reg1].id);
    }
    sync(reg1);
}
//label :
void tarLabel(){
    fprintf(target, "%s:\n", codelist[listcount].head);
}
void genTarCode(){
    int i;
    target = fopen("target.asm", "w+");
    printf("********************************************************************\n");
    // initialize regs
    for(i = 0; i<REGNUM; i++){LRU[i] = i;reglist[i].inuse = 0;reglist[i].address = INITADDR;reglist[i].type = TEMP;char tmp[5] = {'\0'}, n[3] = {'\0'};strcpy(tmp, "$");itoa(i+8, n, 10);strcat(tmp, n);strcpy(reglist[i].id, tmp);memset(reglist[i].name, 0, 200*sizeof(char));}
    strcpy(reglist[REGNUM].id, "$0");
    //initialize mystack
    /*
    for(i = 0; i<MAX_STACK; i++){
        memset(mystack[i].name, 0, 200*sizeof(char));
        mystack[i].address = INITADDR;
        mystack[i].type = TEMP;
        mystack[i].level = INITADDR;
    }
    */
    //set .data
    fprintf(target, ".data\n");
    for(i = 0; listcount<=listtop;listcount++){if(strcmp(codelist[listcount].head, "printf") == 0){if(strcmp(codelist[listcount].var1, "string") == 0){fprintf(target, "\tstring%d:\t.asciiz\t\"%s\"\n", i++, codelist[listcount].var2);}}}
    listcount = 0;
    fprintf(target, ".text\n");
    fprintf(target, "\tmove\t$fp\t$sp\n");
    fprintf(target, "\tmove\t$gp\t$sp\n");
    listcount = 0;

    // save all global vars and push it into mystack
    while(strcmp(codelist[listcount].head, "const char") == 0
          || strcmp(codelist[listcount].head, "const int") == 0){
            if(strcmp(codelist[listcount].head, "const int") == 0) tarConstdef(CINT);
            else if(strcmp(codelist[listcount].head, "const char") == 0) tarConstdef(CCHAR);
            listcount++;
          }
    while(strcmp(codelist[listcount].head, "var") == 0){
        tarVardef();
        listcount++;
    }
    for(i; i<REGNUM; i++){
        if(reglist[i].inuse) tostack(i);
    }
    // level 0 end save new mystack bottom
    fprintf(target, "\tmove\t$fp\t$sp\n");
    localstackcount = 0;
    //stacklevel++;
    for(; listcount <= listtop; listcount++){
        printf("%s\t%s\t%s\t%s\n", codelist[listcount].head, codelist[listcount].var1, codelist[listcount].var2, codelist[listcount].var3);
        fprintf(target, "\n#%s\t%s\t%s\t%s\n", codelist[listcount].head, codelist[listcount].var1, codelist[listcount].var2, codelist[listcount].var3);
        if(strcmp(codelist[listcount].head, "const int") == 0) tarConstdef(CINT);
        else if(strcmp(codelist[listcount].head, "const char") == 0) tarConstdef(CCHAR);
        else if(strcmp(codelist[listcount].head, "int") == 0) tarFuncdef();
        else if(strcmp(codelist[listcount].head, "char") == 0) tarFuncdef();
        else if(strcmp(codelist[listcount].head, "void") == 0) tarFuncdef();
        else if(strcmp(codelist[listcount].head, "para") == 0) tarPara();
        else if(strcmp(codelist[listcount].head, "push") == 0) tarPush();
        else if(strcmp(codelist[listcount].head, "pushJ") == 0) tarPushJ();
        else if(strcmp(codelist[listcount].head, "call") == 0) tarCall();
        else if(strcmp(codelist[listcount].head, "jal") == 0) tarjal();
        else if(strcmp(codelist[listcount].head, "var") == 0) tarVardef();
        else if(strcmp(codelist[listcount].head, "goto") == 0) tarGoto();
        else if(strcmp(codelist[listcount].head, "ret") == 0) tarReturn();
        else if(strcmp(codelist[listcount].head, "end") == 0) tarend();
        else if(strcmp(codelist[listcount].head, "printf") == 0) tarPrint();
        else if(strcmp(codelist[listcount].head, "scanf") == 0) tarScan();
        else if(strcmp(codelist[listcount].head, "BZ") == 0) tarBZ();
        else if(strcmp(codelist[listcount].head, "li") == 0) tarli();
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
        else {
            err(MID_ERR);
            fprintf(erroutput,"%s\t%s\t%s\t%s\n", codelist[listcount].head, codelist[listcount].var1, codelist[listcount].var2, codelist[listcount].var3);
        }
    }
}
