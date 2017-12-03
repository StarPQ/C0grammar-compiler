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
    if(find(name) != 0){
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
    if(detail == 1){
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
    symlist[Top].level = Level;
    //if(symlist[Top].type == FUNCTION) symlist[Top].level = 0;
    if(symlist[Top].type == FUNCTION){
        Level++;
    }
    printf("++++%s, %d, %d\n", name, symlist[Top].level, symlist[Top].type);
}

void pop(){
    while(Level == symlist[Top].level){
        Top--;
    }
    Level--;
}

Link find(char *name){
    printf("//Finding %s\n", name);
    Link tmp;
    int i;
    for(i = 0; i <= Top; i++ ){
        if(strcmp(name, symlist[i].name) == 0 && (symlist[i].level == 0 || symlist[i].level == Level)){
            printf("//Found %s\n", name);
            return &symlist[i];
        }
    }
    //err(NOTDEFINED_ERR);
    return 0;
}
