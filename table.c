#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"err.h"
#include"global.h"
#include"table.h"


void enterTable(char *name, int type, int detail, int value, int paranum){
    if(type == FUNCTION && Level > 0){
        err(FUNCDEFINFUNC_ERR);
        return;
    }
    if(deffind(name) != 0){
        fprintf(erroutput, "--%s--", name);
        err(REDEFINE_ERR);
        return;
    }
    Top++;
    if(Top >= MAX_tl){
        err(OUTOFTABLE_ERR);
        return;
    }
    strcpy(symlist[Top].name, name);
    symlist[Top].type = type;
    symlist[Top].value = value;
    symlist[Top].paranum = paranum;
    if(detail == 0){
        symlist[Top].isarray = 0;
        symlist[Top].isconst = 0;
        symlist[Top].isreturn = 0;
    }
    else if(detail == 1){
        symlist[Top].isarray = 0;
        symlist[Top].isconst = 1;
        symlist[Top].isreturn = 0;
    }
    else if(detail == 2){
        symlist[Top].isarray = 1;
        symlist[Top].isconst = 0;
        symlist[Top].isreturn = 0;
    }
    else if(detail == 3){
        symlist[Top].isarray = 0;
        symlist[Top].isconst = 0;
        symlist[Top].isreturn = 1;
    }
    else if(detail == 4){
        symlist[Top].isarray = 0;
        symlist[Top].isconst = 0;
        symlist[Top].isreturn = 0;
    }
    symlist[Top].level = Level;
    //if(symlist[Top].type == FUNCTION) symlist[Top].level = 0;
    if(symlist[Top].type == FUNCTION){
        Level++;
    }
    if(debug) printf("++++%s, %d, %d\n", name, symlist[Top].level, symlist[Top].type);
}

void pop(){
    while(Level == symlist[Top].level){
        Top--;
    }
    Level--;
}

Link deffind(char *name){
    if(debug) printf("//Finding %s\n", name);
    Link tmp;
    int i;
    //for(i = 0; i <= Top; i++ ){
    for(i = Top; i >= 0; i-- ){
        if(strcmp(name, symlist[i].name) == 0 && symlist[i].level == Level){
            if(debug) printf("//Found %s\n", name);
            return &symlist[i];
        }
    }
    //err(NOTDEFINED_ERR);
    return 0;
}

Link find(char *name){
    if(debug) printf("//Finding %s\n", name);
    Link tmp;
    int i;
    //for(i = 0; i <= Top; i++ ){
    for(i = Top; i >= 0; i-- ){
        if(strcmp(name, symlist[i].name) == 0 && (symlist[i].level == 0 || symlist[i].level == Level)){
            if(debug) printf("//Found %s\n", name);
            return &symlist[i];
        }
    }
    //err(NOTDEFINED_ERR);
    return 0;
}
