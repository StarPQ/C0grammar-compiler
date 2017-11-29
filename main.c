#include<stdio.h>
#include<string.h>
#include"lexing.h"
#include"err.h"
#include"semantic.h"
#include"global.h"

int debug = 1;
int main(int argc,char** argv){
    inputfile = fopen(argv[1], "r");
    erroutput = fopen("_err", "w");
    FILE *outputile = fopen("_result", "w");
    if(debug){
        nextch();  
        wordtest();
        fclose(inputfile);
        inputfile = fopen(argv[1], "r");
    } 
    nextch();
    nextsym();
    Program();
    printf("FINISH!\n");
    return 0;
}