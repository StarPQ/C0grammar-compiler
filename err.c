#include<stdio.h>
#include<string.h>
#include<ctype.h>
#include"lexing.h"
#include"err.h"
int count = 0;
int err(int type){
    count++;
    switch(type){
    case LINELENGTHERR:
        fprintf(erroutput, "%d LINELENGTHERR: l:%d", count, lc);
        break;
    case LINECOUNTERR:
        fprintf(erroutput, "%d LINECOUNTERR", count);
        break;
    case INVALIDCHAR:
        fprintf(erroutput, "%d INVALIDCHAR: l:%d c:%d %c\n", count, lc, cc, ch);
        break;
    case REACHENDOFFILE:
        fprintf(erroutput, "%d REACHENDOFFILE", count);
        break;
    }
    return 0;
}
