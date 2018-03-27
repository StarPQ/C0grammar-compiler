#include<stdio.h>
#include<string.h>
#include"lexing.h"
#include"err.h"
#include"semantic.h"
#include"global.h"
#include"intermed.h"
#include"asm.h"

int debug = 0;
int genmid = 0;
int main(int argc,char** argv){
    //inputfile = fopen(argv[1], "r");
    //inputfile = fopen("c:/Users/41404/OneDrive/test.txt", "r");
    inputfile = fopen(argv[1], "r");
    int optim=0;
    erroutput = fopen("_err", "w");
    FILE *outputile = fopen("_result", "w");
    errdect = 0;
    printf("begin\n");
    printf("start lexing check\n");
    nextch();
    wordtest();
    if(errdect){
        printf("err unsolved\n");
        return 1;
    }
    printf("start semantic check\n");
    nextloop();
    nextch();
    Program();
    if(errdect){
        printf("err unsolved\n");
        return 1;
    }
    printf("start generate midcode\n");
    nextloop();
    genmid = 1;
    init();
    nextch();
    Program();
    printmidlist();
    genTarCode();
    opt();
    printf("FINISH!\n");
    return 0;
}
