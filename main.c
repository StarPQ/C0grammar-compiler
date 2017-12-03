#include<stdio.h>
#include<string.h>
#include"lexing.h"
#include"err.h"
#include"semantic.h"
#include"global.h"

int debug = 1;
int main(int argc,char** argv){
    //inputfile = fopen(argv[1], "r");
    inputfile = fopen("c:/Users/41404/OneDrive/15061036_test.txt", "r");
    //inputfile = fopen("c:/Users/41404/OneDrive/test.txt", "r");
    erroutput = fopen("_err", "w");
    FILE *outputile = fopen("_result", "w");
    printf("begin\n");
    if(0){
        nextch();
        printf("%c", ch);
        wordtest();
        fclose(inputfile);
        inputfile = fopen(argv[1], "r");
    }
    nextch();
    Program();
    printf("FINISH!\n");
    return 0;
}
