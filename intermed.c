#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"lexing.h"
#include"err.h"
#include"intermed.h"
#include"table.h"
#include"global.h"
int labelcount = 0;
int varcount = 0;
int listtop = -1;
int lasttemp = 0;
void reset(){
    varcount = 0;
}
void insertMid(char* head, char* var1, char* var2, char* var3){
    if(!genmid) return;
    listtop++;
    if(head == EMPTY){
        codelist[listtop].head[0] = '\0';
    }
    else if(head == ADDTEMP){
        char tmp[10], n[3];
        strcpy(tmp, "t");
        itoa(varcount, n, 10);
        strcat(tmp, n);
        strcpy(codelist[listtop].head, tmp);
        lasttemp = varcount;
        varcount++;
    }
    else if(head == 1){
        char tmp[10], n[3];
        strcpy(tmp, "t");
        itoa(lasttemp, n, 10);
        strcat(tmp, n);
        strcpy(codelist[listtop].head, tmp);
    }
    else{
        strcpy(codelist[listtop].head, head);
    }

    if(var1 == EMPTY){
        codelist[listtop].var1[0] = '\0';
    }
    else if(var1 == ADDTEMP){
        char tmp[10], n[3];
        strcpy(tmp, "t");
        itoa(varcount, n, 10);
        strcat(tmp, n);
        strcpy(codelist[listtop].var1, tmp);
        lasttemp = varcount;
        varcount++;
    }
    else if(var1 == LASTTEMP){
        char tmp[10], n[3];
        strcpy(tmp, "t");
        itoa(lasttemp, n, 10);
        strcat(tmp, n);
        strcpy(codelist[listtop].var1, tmp);
    }
    else{
        strcpy(codelist[listtop].var1,var1);
    }

    if(var2 == EMPTY){
        codelist[listtop].var2[0] = '\0';
    }
    else if(var2 == ADDTEMP){
        char tmp[10], n[3];
        strcpy(tmp, "t");
        itoa(varcount, n, 10);
        strcat(tmp, n);
        strcpy(codelist[listtop].var2, tmp);
        lasttemp = varcount;
        varcount++;
    }
    else if(var2 == LASTTEMP){
        char tmp[10], n[3];
        strcpy(tmp, "t");
        itoa(lasttemp, n, 10);
        strcat(tmp, n);
        strcpy(codelist[listtop].var2, tmp);
    }
    else{
        strcpy(codelist[listtop].var2, var2);
    }

    if(var3 == EMPTY){
        codelist[listtop].var3[0] = '\0';
    }
    else if(var3 == ADDTEMP){
        char tmp[10], n[3];
        strcpy(tmp, "t");
        itoa(varcount, n, 10);
        strcat(tmp, n);
        strcpy(codelist[listtop].var3, tmp);
        lasttemp = varcount;
        varcount++;
    }
    else if(var3 == LASTTEMP){
        char tmp[10], n[3];
        strcpy(tmp, "t");
        itoa(lasttemp, n, 10);
        strcat(tmp, n);
        strcpy(codelist[listtop].var3, tmp);
    }
    else{
        strcpy(codelist[listtop].var3, var3);
    }
}
void printmidlist(){
    int i = 0;
    FILE *midoutput = fopen("middle_code.txt", "w+");
    for(i; i <= listtop; i++){
        printf("%s\t%s\t%s\t%s\n", codelist[i].head, codelist[i].var1, codelist[i].var2, codelist[i].var3);
        fprintf(midoutput, "%s\t%s\t%s\t%s\n", codelist[i].head, codelist[i].var1, codelist[i].var2, codelist[i].var3);
    }
    fclose(midoutput);
}

void midLabel(char *var1){
    if(!genmid) return;
    listtop++;
    char tmp[100] = {'\0'};
    strcpy(tmp, "LABEL_");
    strcat(tmp, var1);
    strcpy(codelist[listtop].head, tmp);
    strcpy(codelist[listtop].var1, ":");
    return;
}

void init(){
    varcount = 0;
    labelcount = 0;
}

char var_gen[20];
char* nextvar(){
    // var_gen = (char*)malloc(sizeof(char) * 20);
    char n[13];
    strcpy(var_gen, "$t");
    itoa(varcount, n, 10);
    strcat(var_gen, n);
    strcat(var_gen, "\0");
    varcount++;
    return var_gen;
}

char* label_gen[20];
char* nextlabel(){
    // var_gen = (char*)malloc(sizeof(char) * 20);
    char n[13];
    strcpy(label_gen, "LABEL_");
    itoa(labelcount, n, 10);
    strcat(label_gen, n);
    strcat(label_gen, "\0");
    labelcount++;
    return label_gen;
}
