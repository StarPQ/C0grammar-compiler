#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include"intermed.h"

//midcode codelist[MAXMIDCODE];
typedef struct block{
    int begin;
    int end;
    int count;
}block, *blockLink;
block blocklist[1000];

typedef struct node{
    char *components[50];
    struct node *left, *right, *father;
    int name;
}node, *treeLink;

int genblock(){
    int i=0, j=0, count=0;
    blocklist[j].begin = i;
    for(;i <= listtop; i++){
        if(strcmp(codelist[i].head, "%goto") == 0||
            strcmp(codelist[i].head, "%ret") == 0||
            strcmp(codelist[i].head, "%end") == 0||
            strcmp(codelist[i].head, "BZ") == 0||
            strcmp(codelist[i].head, "%jal") == 0){
                blocklist[j].end = i;
                blocklist[j].count = count;
                j++;
                count=0;
                blocklist[j].begin = i+1;
            }
        count++;
    }
    return j;
}

void makedag(int j){
    int i=0;
    for(;i<=blocklist[j].count; i++){
        if(strcmp(codelist[i].var2, "+") == 0);
        else if(strcmp(codelist[i].var2, "-") == 0);
        else if(strcmp(codelist[i].var2, "*") == 0);
        else if(strcmp(codelist[i].var2, "/") == 0);
        else if(strcmp(codelist[i].var2, "=") == 0);
        else if(strcmp(codelist[i].var1, "=") == 0);

    }
}

void optim(int k){
    int blockcount = genblock();
    int i;
    for(i=0; i<blockcount; i++){
        makedag(i);
    }
}

#include"asm.h"
#include"err.h"

reg reglist[REGNUM+1];
stacknode mystack[MAX_STACK];
int oplistcount = 0; // count midcode
int opstacklevel = 0;
int opstackcount = 0; // global stacknode count
int oplocalstackcount = 0; // stacknode count in current lavel
int opLRU[REGNUM];
int oplscsave[200];
int opparac[10];
int opparalevel = -1;
int opdatacount = 0;
FILE* target;
void opsetLRU(int i){
    int tmp = opLRU[i];
    for(i; i<REGNUM-1; i++){
        opLRU[i] = opLRU[i+1];
    }
    opLRU[REGNUM-1] = tmp;
}
void opprintstack(){
    printf("%s\t%s\t%s\t%s\n", codelist[oplistcount].head, codelist[oplistcount].var1, codelist[oplistcount].var2, codelist[oplistcount].var3);
    int i;
    for(i = opstackcount-1; i>0; i--){
        printf("mystack-->%s %s %d\n", mystack[i].type, mystack[i].name, mystack[i].level);
    }
}
// apply a reg if the reg pool is full save the earliest reg to mystack
// and return that reg number
int opapplyreg(){
    int i = 0;
    for(i = 0; i<REGNUM; i++){
        if(reglist[i].inuse == 0){
            reglist[i].inuse = 1;
            reglist[i].type = TEMP;
            reglist[i].level = opstacklevel;
            reglist[i].address = INITADDR;
            opsetLRU(i);
            return i;
        }
    }
    i = opLRU[0];
    optostack(i);
    reglist[i].inuse = 1;
    reglist[i].type = TEMP;
    reglist[i].level = opstacklevel;
    reglist[i].address = INITADDR;
    opsetLRU(0);
    return i;
}
// if a var is modified in reg opsynchronize it with the stack
void opsync(int i){
    if(reglist[i].type != TEMP){
        if(reglist[i].level == 0)
            fprintf(target, "\tsw\t%s\t%d($gp)\n", reglist[i].id, reglist[i].address);
        else
            fprintf(target, "\tsw\t%s\t%d($fp)\n", reglist[i].id, reglist[i].address);
    }
    fprintf(erroutput, "opsync %s level: %d\n", reglist[i].name, reglist[i].level);
    //reglist[i].inuse = 0;
}
// if this is the last time to use this temp
//
void opreuse(int regnum){
    if(regnum == REGNUM) return;
    if(reglist[regnum].inuse==0) return;
    int i = oplistcount;
    for(i; i<listtop; i++){
        if(strcmp(codelist[i].head, "int") == 0
            || strcmp(codelist[i].head, "char") == 0
            || strcmp(codelist[i].head, "void") == 0
            ||strcmp(codelist[i].head, "%end") == 0){
            break;
        }
        if(strcmp(codelist[i].head, reglist[regnum].name) == 0) return;
        if(strcmp(codelist[i].var1, reglist[regnum].name) == 0) return;
        if(strcmp(codelist[i].var2, reglist[regnum].name) == 0) return;
        if(strcmp(codelist[i].var3, reglist[regnum].name) == 0) return;
    }
    reglist[regnum].inuse = 0;
    //optostack(regnum);
    return;
}
// get sth named name from mystack
int optoreg(char* name){
    int i;
    //for(i = 0; i<opstackcount; i++){
    //printf("find %s\n", name);
    for(i = opstackcount - 1; i>=0; i--){
        if(mystack[i].level == opstacklevel && strcmp(mystack[i].name, name) == 0){
            // in current level
            int regnum = opapplyreg();
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
            int regnum = opapplyreg();
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
    fprintf(erroutput, "%s\t%s\t%s\t%s\n", codelist[oplistcount].head, codelist[oplistcount].var1, codelist[oplistcount].var2, codelist[oplistcount].var3);
    printf("undefined: %s %d\n", name, opstacklevel);
    opprintstack();
}
// find a var named name in reg and mystack(move to reg) return the regnum that keep the var
int opfindvar(char* name){
    int i;
    for(i = 0; i<REGNUM; i++){
        if(strcmp(reglist[i].name, name)  == 0 && reglist[i].inuse == 1){
            fprintf(erroutput, "@@@found %s with addr=%d\n", reglist[i].name, reglist[i].address);
            opsetLRU(i);
            return i;
        }
    }
    return optoreg(name);

}
void optostack(int i){
    // reglist[regnum].inuse = 0;
    //fprintf(erroutput, "---addr is %d\n", reglist[i].address);
    if(reglist[i].address == INITADDR){
        //fprintf(erroutput, "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
        mystack[opstackcount].level = reglist[i].level;
        mystack[opstackcount].type = reglist[i].type;
        strcpy(mystack[opstackcount].name, reglist[i].name);
        mystack[opstackcount].address = - 4*oplocalstackcount;
        fprintf(target, "\tsw\t%s\t\t($sp)\t#%s<--%d\n", reglist[i].id, mystack[opstackcount].name, mystack[opstackcount].address);
        fprintf(erroutput, "store: %s %d\t#%s<--%d\n", reglist[i].id, mystack[opstackcount].level, mystack[opstackcount].name, mystack[opstackcount].address);
        oplocalstackcount++;
        opstackcount++;
        fprintf(target, "\tsubi\t$sp\t$sp\t4\n");
    }
    else{
        if(reglist[i].level == 0)
            fprintf(target, "\tsw\t%s\t%d($gp)\t#%s<--%d\n", reglist[i].id, reglist[i].address, reglist[i].name, reglist[i].address);
        else
            fprintf(target, "\tsw\t%s\t%d($fp)\n", reglist[i].id, reglist[i].address);
        fprintf(erroutput, "store: %s %d\t#%s<--%d\n", reglist[i].id, mystack[opstackcount].level, mystack[opstackcount].name, mystack[opstackcount].address);
    }
    reglist[i].inuse = 0;
}

void opallocspace(int i){
    mystack[opstackcount].level = reglist[i].level;
    mystack[opstackcount].type = reglist[i].type;
    strcpy(mystack[opstackcount].name, reglist[i].name);
    mystack[opstackcount].address = - 4*oplocalstackcount;
    reglist[i].address = - 4*oplocalstackcount;
    //fprintf(target, "\tsw\t%s\t\t($sp)\t#%s<--%d\n", reglist[i].id, mystack[opstackcount].name, mystack[opstackcount].address);
    fprintf(erroutput, "alloc: %s %d\t#%s<--%d\n", reglist[i].id, mystack[opstackcount].level, mystack[opstackcount].name, mystack[opstackcount].address);
    oplocalstackcount++;
    opstackcount++;
}
//
void optarFuncdef(){
    // when got funcdef read paras
    int i;
    for(i = 0; i<REGNUM; i++){
        reglist[i].inuse = 0;
    }
    opstacklevel++;
    oplocalstackcount = 0;
    printf("L+%d\n", opstacklevel);
}
// name the para in mystack
// get it into reg?
// par int name
void optarPara(){
    int i = opstackcount;// this the bottom of this level
    mystack[i].level = 1;
    strcpy(mystack[i].name, codelist[oplistcount].var2);
    if(strcmp(codelist[oplistcount].var1, "int") == 0)
        mystack[i].type = CINT;
    else
        mystack[i].type = CCHAR;
    mystack[i].address = - 4*oplocalstackcount;
    opstackcount++;
    oplocalstackcount++;
    //opprintstack();
    fprintf(erroutput, "%s\t%s\t%s\t%s\n", codelist[oplistcount].head, codelist[oplistcount].var1, codelist[oplistcount].var2, codelist[oplistcount].var3);
    fprintf(erroutput, "para: %s %d\n", mystack[i].name, mystack[i].level);
}
// push $ti
void optarPush(){
    int regnum = opfindvar(codelist[oplistcount].var1);
    while(mystack[opstackcount].type != PARA && oplocalstackcount>0){
        oplocalstackcount--;
        opstackcount--;
        fprintf(target, "\taddi\t$sp\t$sp\t4\n");
    }
    fprintf(target, "\tsw\t%s\t($sp)\n", reglist[regnum].id);
    fprintf(target, "\tsubi\t$sp\t$sp\t4\n");
    mystack[opstackcount].level = 2;
    mystack[opstackcount].address = - 4*oplocalstackcount;
    mystack[opstackcount].type = PARA;
    strcpy(mystack[opstackcount].name, "\0");
    int i;
    for(i = 0; i<REGNUM; i++){
        reglist[i].inuse = 0;
    }
}
// the last para to push
// push and jump
void optarPushJ(){
    int regnum = opfindvar(codelist[oplistcount].var1);
    while(mystack[opstackcount].type == TEMP && oplocalstackcount>0){
        oplocalstackcount--;
        opstackcount--;
        fprintf(target, "\taddi\t$sp\t$sp\t4\n");
    }
    fprintf(target, "\tsw\t%s\t($sp)", reglist[regnum].id);
    mystack[opstackcount].level = 2;
    mystack[opstackcount].address = - 4*oplocalstackcount;
    mystack[opstackcount].type = PARA;
    strcpy(mystack[opstackcount].name, "\0");
}
void optarjal(){
    //opparalevel--;
    int i;
    for(i = 0; i<REGNUM; i++){
        reglist[i].inuse = 0;
    }
    opstackcount = opstackcount - oplocalstackcount;

    //fprintf(target, "\taddi\t$fp\t$sp\t%d\n", 4*oplocalstackcount);
    fprintf(target, "\tmove\t$fp\t$k0\n");
    fprintf(target, "\tmove\t$sp\t$k0\n");
    fprintf(target, "\tjal\t%s\n", codelist[oplistcount].var1);
    fprintf(target, "\tnop\n");
    //recover sp and $ra
    fprintf(target, "\taddi\t$sp\t$sp\t12\n");
    fprintf(target, "\tlw\t$k0\t($sp)\n");
    fprintf(target, "\tlw\t$fp\t-4($sp)\n");
    fprintf(target, "\tlw\t$ra\t-8($sp)\n");
    oplocalstackcount = oplscsave[opstacklevel];
    fprintf(erroutput, "lcount = %d   sc = %d\n", oplocalstackcount, opstackcount);
    //opprintstack();
}
// save the current reg and opstacklevel+1
void optarCall(){
    int i;
    //save reg
    for(i=0; i<REGNUM; i++){
        if(reglist[i].inuse) optostack(i);
    }
    // save old fp
    fprintf(target, "\tsubi\t$sp\t$sp\t12\n");
    fprintf(target, "\tsw\t$k0\t12($sp)\n");
    fprintf(target, "\tsw\t$fp\t8($sp)\n");
    fprintf(target, "\tsw\t$ra\t4($sp)\n");
    oplscsave[opstacklevel] = oplocalstackcount;
    fprintf(erroutput, "lcount = %d   sc = %d\n", oplocalstackcount, opstackcount);
    //opprintstack();
    // refresh fp
    //fprintf(target, "\tmove\t$fp\t$sp\n");
    oplocalstackcount = 0;
    fprintf(target, "\tmove\t$k0\t$sp\n");
    // when return find and relode ra and jr $ra
}
// $ti = RET
void optargetRET(){
    int regnum = opapplyreg();
    strcpy(reglist[regnum].name, codelist[oplistcount].head);
    fprintf(target, "\tmove\t%s\t$v0\n", reglist[regnum].id);
    //optostack(regnum);
}
// ret $ti  / ret
void optarReturn(){
    if(strcmp(codelist[oplistcount].var1, "\0") == 0){
        // return
    }
    else{
        int regnum = opfindvar(codelist[oplistcount].var1);
        fprintf(target, "\tmove\t$v0\t%s\n", reglist[regnum].id);
        //reglist[regnum].inuse=0;
    }

    fprintf(target, "\tmove\t$sp\t$fp\n", 4*oplocalstackcount);
    fprintf(target, "\tjr\t$ra\n");
    fprintf(target, "\tnop\n");

}
void optarend(){
    opstackcount = opstackcount - oplocalstackcount;
    oplocalstackcount = 0;
    int i;
    for(i = 0; i<REGNUM; i++){
        reglist[i].inuse = 0;
    }
    opstacklevel--;
    fprintf(erroutput, "L-%d\n", opstacklevel);
}
void optarConstdef(int type){
    int regnum;
    regnum = opapplyreg();
    reglist[regnum].inuse = 1;
    strcpy(reglist[regnum].name, codelist[oplistcount].var1);
    reglist[regnum].type = type;
    fprintf(target, "\tli\t%s\t%s\n", reglist[regnum].id, codelist[oplistcount].var3);
    opallocspace(regnum);
}
// var int name length
void optarVardef(){
    if(strcmp(codelist[oplistcount].var3, "\0") == 0){
        // is a normal var
        int reg1 = opapplyreg();
        strcpy(reglist[reg1].name, codelist[oplistcount].var2);
        if(strcmp(codelist[oplistcount].var1, "int") == 0){
            reglist[reg1].type = CINT;
        }
        else{
            reglist[reg1].type = CCHAR;
        }
        opallocspace(reg1);
    }
    else{
        // is a array
        int i = 0;
        for(i; i<atoi(codelist[oplistcount].var3); i++){
            char tmp[200] = {'\0'}, n[3] = {'\0'};
            strcpy(tmp, codelist[oplistcount].var2);
            strcat(tmp, "#");
            itoa(i, n, 10);
            strcat(tmp, n);
            int reg1 = opapplyreg();
            strcpy(reglist[reg1].name, tmp);
            if(strcmp(codelist[oplistcount].var1, "int") == 0){
                reglist[reg1].type = CINT;
            }
            else{
                reglist[reg1].type = CCHAR;
            }
            opallocspace(reg1);
        }
    }
}
// goto label
void optarGoto(){
    int i, j;
    for(i=listtop; i>0;i--){
        if(strcmp(codelist[i].head, "%end")==0)break;
        else if(strcmp(codelist[i].head, codelist[oplistcount].head)==0){
            for(j=0; j<REGNUM; j++){
                if(reglist[j].inuse) optostack(j);
                break;
            }
        }
    }
    fprintf(target, "\tj\t%s\n", codelist[oplistcount].var1);
    fprintf(target, "\tnop\n");
}
// BZ $ti label
void optarBZ(){
    int regnum;
    regnum = opfindvar(codelist[oplistcount].var1);
    fprintf(target, "\tbeq\t%s\t$0\t%s\n", reglist[regnum].id, codelist[oplistcount].var2);
    fprintf(target, "\tnop\n");
}
void optarli(){
    int reg1 = opapplyreg();
    strcpy(reglist[reg1].name, codelist[oplistcount].var1);
    fprintf(target, "\tli\t%s\t%s\n", reglist[reg1].id, codelist[oplistcount].var2);
}
// $ti  $ti + $ti
void optarPLUS(){
    int reg2;
    if(strcmp(codelist[oplistcount].var1, "\0") == 0) reg2 = REGNUM;
    else reg2 = opfindvar(codelist[oplistcount].var1);
    int reg3 = opfindvar(codelist[oplistcount].var3);
    int reg1 = opapplyreg();
    strcpy(reglist[reg1].name, codelist[oplistcount].head);
    opreuse(reg2);
    opreuse(reg3);
    fprintf(target, "\tadd\t%s\t%s\t%s\n", reglist[reg1].id, reglist[reg2].id, reglist[reg3].id);
}
// $ti  $ti - $ti
void optarMINUS(){
    int reg2;
    if(strcmp(codelist[oplistcount].var1, "\0") == 0) reg2 = REGNUM;
    else reg2 = opfindvar(codelist[oplistcount].var1);
    int reg3 = opfindvar(codelist[oplistcount].var3);
    int reg1 = opapplyreg();
    strcpy(reglist[reg1].name, codelist[oplistcount].head);
    opreuse(reg2);
    opreuse(reg3);
    fprintf(target, "\tsub\t%s\t%s\t%s\n", reglist[reg1].id, reglist[reg2].id, reglist[reg3].id);

}
// $ti  $ti * $ti
void optarTIMES(){
    int reg2;
    if(strcmp(codelist[oplistcount].var1, "\0") == 0) reg2 = REGNUM;
    else reg2 = opfindvar(codelist[oplistcount].var1);
    int reg3 = opfindvar(codelist[oplistcount].var3);
    int reg1 = opapplyreg();
    strcpy(reglist[reg1].name, codelist[oplistcount].head);
    opreuse(reg2);
    opreuse(reg3);
    fprintf(target, "\tmult\t%s\t%s\n", reglist[reg2].id, reglist[reg3].id);
    fprintf(target, "\tmflo\t%s\n", reglist[reg1].id);

}
// $ti  $ti / $ti
void optarIDIV(){
    int reg2;
    if(strcmp(codelist[oplistcount].var1, "\0") == 0) reg2 = REGNUM;
    else reg2 = opfindvar(codelist[oplistcount].var1);
    int reg3 = opfindvar(codelist[oplistcount].var3);
    int reg1 = opapplyreg();
    strcpy(reglist[reg1].name, codelist[oplistcount].head);
    opreuse(reg2);
    opreuse(reg3);
    fprintf(target, "\tdiv\t%s\t%s\n", reglist[reg2].id, reglist[reg3].id);
    fprintf(target, "\tmflo\t%s\n", reglist[reg1].id);

}
// $ti  $ti == $ti  1: ==0 0:!=0
void optarEQL(){
    optarMINUS();
    oplistcount++;
    int reg1 = opfindvar(codelist[oplistcount].var1);
    opreuse(reg1);

    int i=0;
    for(i; i<REGNUM; i++){
        if(reglist[i].level!=0)opreuse(i);
        if(reglist[i].inuse) optostack(i);
    }

    fprintf(target, "\tbne\t%s\t$0\t%s\n", reglist[reg1].id, codelist[oplistcount].var2);
}
// $ti  $ti != $ti  1: !=0 0:==0
void optarNEQ(){
    optarMINUS();
    oplistcount++;
    int reg1 = opfindvar(codelist[oplistcount].var1);
    opreuse(reg1);

    int i=0;
    for(i; i<REGNUM; i++){
        if(reglist[i].level!=0)opreuse(i);
        if(reglist[i].inuse) optostack(i);
    }

    fprintf(target, "\tbeq\t%s\t$0\t%s\n", reglist[reg1].id, codelist[oplistcount].var2);
}
// $ti  $ti > $ti 1: >0 0: <=0
void optarGTR(){
    optarMINUS();
    oplistcount++;
    int reg1 = opfindvar(codelist[oplistcount].var1);
    opreuse(reg1);

    int i=0;
    for(i; i<REGNUM; i++){
        if(reglist[i].level!=0)opreuse(i);
        if(reglist[i].inuse) optostack(i);
    }

    fprintf(target, "\tblez\t%s\t%s\n", reglist[reg1].id, codelist[oplistcount].var2);
}
// $ti  $ti >= $ti  1: >=0 0: <0
void optarGEQ(){
    optarMINUS();
    oplistcount++;
    int reg1 = opfindvar(codelist[oplistcount].var1);
    opreuse(reg1);

    int i=0;
    for(i; i<REGNUM; i++){
        if(reglist[i].level!=0)opreuse(i);
        if(reglist[i].inuse) optostack(i);
    }

    fprintf(target, "\tbltz\t%s\t%s\n", reglist[reg1].id, codelist[oplistcount].var2);
}
// $ti  $ti < $ti   1: <0 0: >=0
void optarLSS(){
    optarMINUS();
    oplistcount++;
    int reg1 = opfindvar(codelist[oplistcount].var1);
    opreuse(reg1);

    int i=0;
    for(i; i<REGNUM; i++){
        if(reglist[i].level!=0)opreuse(i);
        if(reglist[i].inuse) optostack(i);
    }

    fprintf(target, "\tbgez\t%s\t%s\n", reglist[reg1].id, codelist[oplistcount].var2);
}
// $ti  $ti <= $ti   1: <=0 0: >0
void optarLEQ(){
    optarMINUS();
    oplistcount++;
    int reg1 = opfindvar(codelist[oplistcount].var1);
    opreuse(reg1);

    int i=0;
    for(i; i<REGNUM; i++){
        if(reglist[i].level!=0)opreuse(i);
        if(reglist[i].inuse) optostack(i);
    }

    fprintf(target, "\tbgtz\t%s\t%s\n", reglist[reg1].id, codelist[oplistcount].var2);
}
// $ti  = name num / $ti
void optarfromList(){
    char tmp[200];
    int reg2;
    int reg1;
    if(strcmp(codelist[oplistcount].var3, "\0") == 0){
        strcpy(tmp, codelist[oplistcount].var2);
        reg2 = opfindvar(tmp);
    }
    else if(codelist[oplistcount].var3[0] >= '0' && codelist[oplistcount].var3[0] <= '9'){
        strcpy(tmp, codelist[oplistcount].var2);
        strcat(tmp, "#");
        strcat(tmp, codelist[oplistcount].var3);
        reg2 = opfindvar(tmp);
    }
    else{ //if(codelist[oplistcount].var3[0] == '$'){
        int placereg = opfindvar(codelist[oplistcount].var3); // get num
        int treg = opapplyreg();
        strcpy(reglist[treg].name, "#listtmp");
        fprintf(target, "\tli\t%s\t-4\n", reglist[treg].id); // size of one word
        fprintf(target, "\tmul\t%s\t%s\t%s\n", reglist[treg].id, reglist[placereg].id, reglist[treg].id);// get distance to array root
        strcpy(tmp, codelist[oplistcount].var2);
        strcat(tmp, "#0");
        reglist[placereg].inuse = 0;
        placereg = opfindvar(tmp);// get array root
        reg2 = opapplyreg();
        if(reglist[placereg].level == 0){
            fprintf(target, "\tadd\t%s\t%s\t$gp\n", reglist[treg].id, reglist[treg].id); // gp + 4*NUM
            fprintf(target, "\tlw\t%s\t%d(%s)\n", reglist[reg2].id, reglist[placereg].address, reglist[treg].id); // GP + ROOT + 4*NUM
        }
        else{
            fprintf(target, "\tadd\t%s\t%s\t$fp\n", reglist[treg].id, reglist[treg].id);
            fprintf(target, "\tlw\t%s\t%d(%s)\n", reglist[reg2].id, reglist[placereg].address, reglist[treg].id);
        }
        reglist[treg].inuse = 0;
        reg1 = opapplyreg();
        if(reglist[placereg].type == CCHAR) reglist[reg1].type=TCHAR;
        reglist[placereg].inuse = 0;
        reglist[reg2].inuse = 0;
        strcpy(reglist[reg1].name, codelist[oplistcount].head);
        fprintf(target, "\tmove\t%s\t%s\n", reglist[reg1].id, reglist[reg2].id);
        return;
    }

    reg1 = opapplyreg();
    strcpy(reglist[reg1].name, codelist[oplistcount].head);
    if(reglist[reg2].type == CCHAR) reglist[reg1].type=TCHAR;
    opreuse(reg2);
    fprintf(target, "\tmove\t%s\t%s\n", reglist[reg1].id, reglist[reg2].id);
}
// name num/$t = $ti
void optartolist(){
    char tmp[200];
    int reg1;
    int reg2 = opfindvar(codelist[oplistcount].var3);
    if(strcmp(codelist[oplistcount].var1, "\0") == 0){
        strcpy(tmp, codelist[oplistcount].head);
        reg1 = opfindvar(tmp);
    }
    else if(codelist[oplistcount].var1[0] >= '0' && codelist[oplistcount].var1[0] <= '9'){
        strcpy(tmp, codelist[oplistcount].head);
        strcat(tmp, "#");
        strcat(tmp, codelist[oplistcount].var1);
        reg1 = opfindvar(tmp);
    }
    else{ //if(codelist[oplistcount].var1[0] == '$'){ // p--v0 t--v1
        int placereg = opfindvar(codelist[oplistcount].var1);
        int treg = opapplyreg();
        strcpy(reglist[treg].name, "#listtmp");
        fprintf(target, "\tli\t%s\t-4\n", reglist[treg].id);
        fprintf(target, "\tmul\t%s\t%s\t%s\n", reglist[treg].id, reglist[placereg].id, reglist[treg].id);// get length to array root
        strcpy(tmp, codelist[oplistcount].head);
        strcat(tmp, "#0");
        reglist[placereg].inuse = 0;
        placereg = opfindvar(tmp);//array root
        //reg1 = opapplyreg();
        if(reglist[placereg].level == 0){
            fprintf(target, "\tadd\t%s\t%s\t$gp\n", reglist[treg].id, reglist[treg].id);
            fprintf(target, "\tsw\t%s\t%d(%s)\n", reglist[reg2].id, reglist[placereg].address, reglist[treg].id);
        }
        else{
            fprintf(target, "\tadd\t%s\t%s\t$fp\n", reglist[treg].id, reglist[treg].id);
            fprintf(target, "\tsw\t%s\t%d(%s)\n", reglist[reg2].id, reglist[placereg].address, reglist[treg].id);
        }
        reglist[treg].inuse = 0;
        reglist[placereg].inuse = 0;
        return;
    }

    opreuse(reg2);
    fprintf(target, "\tadd\t%s\t%s\t$0\n", reglist[reg1].id, reglist[reg2].id);
    opsync(reg1);
}
// printf type detail
void optarPrint(){
    if(strcmp(codelist[oplistcount].var1, "string") == 0){
        fprintf(target, "\tli\t$v0\t4\n");
        fprintf(target, "\tla\t$a0\tstring%d\n", opdatacount++);
        fprintf(target, "\tsyscall\n");
    }
    else{
        int reg1 = opfindvar(codelist[oplistcount].var2);
        if(reglist[reg1].type == CCHAR || reglist[reg1].type == TCHAR){
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
void optarScan(){
    int reg1 = opfindvar(codelist[oplistcount].var1);
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
    opsync(reg1);
}
//label :
void optarLabel(){
    int i=0;
    for(i; i<REGNUM; i++){
        if(reglist[i].level!=0)opreuse(i);
        if(reglist[i].inuse) optostack(i);
    }
    fprintf(target, "%s:\n", codelist[oplistcount].head);
}
void opt(){
    int i;
    target = fopen("target-op.asm", "w+");
    printf("********************************************************************\n");
    // initialize regs
    for(i = 0; i<REGNUM; i++){opLRU[i] = i;reglist[i].inuse = 0;reglist[i].address = INITADDR;reglist[i].type = TEMP;char tmp[5] = {'\0'}, n[3] = {'\0'};strcpy(tmp, "$");itoa(i+8, n, 10);strcat(tmp, n);strcpy(reglist[i].id, tmp);memset(reglist[i].name, 0, 200*sizeof(char));}
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
    for(i = 0; oplistcount<=listtop;oplistcount++){if(strcmp(codelist[oplistcount].head, "%printf") == 0){if(strcmp(codelist[oplistcount].var1, "string") == 0){fprintf(target, "\tstring%d:\t.asciiz\t\"%s\"\n", i++, codelist[oplistcount].var2);}}}
    oplistcount = 0;
    fprintf(target, ".text\n");
    fprintf(target, "\tmove\t$fp\t$sp\n");
    fprintf(target, "\tmove\t$gp\t$sp\n");
    oplistcount = 0;

    // save all global vars and push it into mystack
    while(strcmp(codelist[oplistcount].head, "const char") == 0
          || strcmp(codelist[oplistcount].head, "const int") == 0){
            if(strcmp(codelist[oplistcount].head, "const int") == 0) optarConstdef(CINT);
            else if(strcmp(codelist[oplistcount].head, "const char") == 0) optarConstdef(CCHAR);
            oplistcount++;
          }
    while(strcmp(codelist[oplistcount].head, "%var") == 0){
        optarVardef();
        oplistcount++;
    }
    for(i; i<REGNUM; i++){
        if(reglist[i].inuse) optostack(i);
    }
    // level 0 end save new mystack bottom
    fprintf(target, "\tsubi\t$sp\t$sp\t%d\n", 4*oplocalstackcount);
    fprintf(target, "\tmove\t$fp\t$sp\n");
    oplocalstackcount = 0;
    //opstacklevel++;
    for(; oplistcount <= listtop; oplistcount++){
        printf("%s\t%s\t%s\t%s\n", codelist[oplistcount].head, codelist[oplistcount].var1, codelist[oplistcount].var2, codelist[oplistcount].var3);
        fprintf(target, "\n#%s\t%s\t%s\t%s\n", codelist[oplistcount].head, codelist[oplistcount].var1, codelist[oplistcount].var2, codelist[oplistcount].var3);
        if(strcmp(codelist[oplistcount].head, "const int") == 0) optarConstdef(CINT);
        else if(strcmp(codelist[oplistcount].head, "const char") == 0) optarConstdef(CCHAR);
        else if(strcmp(codelist[oplistcount].head, "int") == 0) optarFuncdef();
        else if(strcmp(codelist[oplistcount].head, "char") == 0) optarFuncdef();
        else if(strcmp(codelist[oplistcount].head, "void") == 0) optarFuncdef();
        else if(strcmp(codelist[oplistcount].head, "%para") == 0) optarPara();
        else if(strcmp(codelist[oplistcount].head, "%push") == 0) optarPush();
        else if(strcmp(codelist[oplistcount].head, "%call") == 0) optarCall();
        else if(strcmp(codelist[oplistcount].head, "%jal") == 0) optarjal();
        else if(strcmp(codelist[oplistcount].head, "%var") == 0) optarVardef();
        else if(strcmp(codelist[oplistcount].head, "%goto") == 0) optarGoto();
        else if(strcmp(codelist[oplistcount].head, "%ret") == 0) optarReturn();
        else if(strcmp(codelist[oplistcount].head, "%end") == 0) optarend();
        else if(strcmp(codelist[oplistcount].head, "%printf") == 0) optarPrint();
        else if(strcmp(codelist[oplistcount].head, "%scanf") == 0) optarScan();
        else if(strcmp(codelist[oplistcount].head, "BZ") == 0) optarBZ();
        else if(strcmp(codelist[oplistcount].head, "%li") == 0) optarli();
        else if(strcmp(codelist[oplistcount].var2, "RET") == 0) optargetRET();
        else if(strcmp(codelist[oplistcount].var1, ":") == 0) optarLabel();
        else if(strcmp(codelist[oplistcount].var2, "+") == 0) optarPLUS();
        else if(strcmp(codelist[oplistcount].var2, "-") == 0) optarMINUS();
        else if(strcmp(codelist[oplistcount].var2, "*") == 0) optarTIMES();
        else if(strcmp(codelist[oplistcount].var2, "/") == 0) optarIDIV();
        else if(strcmp(codelist[oplistcount].var2, "==") == 0) optarEQL();
        else if(strcmp(codelist[oplistcount].var2, "!=") == 0) optarNEQ();
        else if(strcmp(codelist[oplistcount].var2, ">") == 0) optarGTR();
        else if(strcmp(codelist[oplistcount].var2, ">=") == 0) optarGEQ();
        else if(strcmp(codelist[oplistcount].var2, "<") == 0) optarLSS();
        else if(strcmp(codelist[oplistcount].var2, "<=") == 0) optarLEQ();
        else if(strcmp(codelist[oplistcount].var2, "+") == 0) optarPLUS();
        else if(strcmp(codelist[oplistcount].var2, "=") == 0) optartolist();
        else if(strcmp(codelist[oplistcount].var1, "=") == 0) optarfromList();
        else if(strcmp(codelist[oplistcount].head, "%main") == 0) optarFuncdef();
        else if(strcmp(codelist[oplistcount].head, "%endvardef") == 0){
            fprintf(target, "\tsubi\t$sp\t$sp\t%d\n", 4*oplocalstackcount);
        }
        else {
            err(MID_ERR);
            fprintf(erroutput,"%s\t%s\t%s\t%s\n", codelist[oplistcount].head, codelist[oplistcount].var1, codelist[oplistcount].var2, codelist[oplistcount].var3);
        }
    }
}
