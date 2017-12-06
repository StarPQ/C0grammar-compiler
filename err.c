#include<stdio.h>
#include<string.h>
#include<ctype.h>
#include"lexing.h"
#include"err.h"
int count = 0;
int err(int type){
    errdect = 1;
    count++;
    switch(type){
    case LINELENGTHERR:
        fprintf(erroutput, "%d LINELENGTHERR: l:%d", count, lc);
        deal(DONOTHING);
        break;
    case LINECOUNTERR:
        fprintf(erroutput, "%d LINECOUNTERR", count);
        deal(DONOTHING);
        break;
    case INVALIDCHAR:
        fprintf(erroutput, "%d INVALIDCHAR: l:%d c:%d %c\n", count, lc, cc, ch);
        deal(DONOTHING);
        break;
    case REACHENDOFFILE:
        fprintf(erroutput, "%d REACHENDOFFILE", count);
        deal(FATAL);
        break;
    case VARSTATE_ERR:
        fprintf(erroutput, "%d VARSTATE_ERR: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(TOHEAD);
        break;
    case FUNCSTATE_ERR:
        fprintf(erroutput, "%d VARSTATE_ERR: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(DONOTHING);
        break;
    case REDUNDUNT:
        fprintf(erroutput, "%d REDUNDUNT:\n", count);
        deal(DONOTHING);
        break;
    case LACK_MAIN:
        fprintf(erroutput, "%d LACK_MAIN:\n", count);
        deal(DONOTHING);
        break;
    case LACK_SEMICOLON:
        fprintf(erroutput, "%d LACK_SEMICOLON: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(TOHEAD);
        break;
    case DEFTYPE_ERR:
        fprintf(erroutput, "%d DEFTYPE_ERR: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(TOEND);
        break;
    case SYMBOLCONFLICT_ERR:
        fprintf(erroutput, "%d SYMBOLCONFLICT_ERR: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(TOENDMID);
        break;
    case CONSTNOTDEF_ERR:
        fprintf(erroutput, "%d CONSTNOTDEF_ERR: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(TOENDMID);
        break;
    case LACK_NUM:
        fprintf(erroutput, "%d LACK_NUM: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(TOENDMID);
        break;
    case LACK_CHAR:
        fprintf(erroutput, "%d LACK_CHAR: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(TOENDMID);
        break;
    case LACK_RMBRACK:
        fprintf(erroutput, "%d LACK_RMBRACK: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(DONOTHING);
        break;
    case LACK_LBBRACK:
        fprintf(erroutput, "%d LACK_LBBRACK: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(DONOTHING);
        break;
    case LACK_RSBRACK:
        fprintf(erroutput, "%d LACK_RSBRACK: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(DONOTHING);
        break;
    case PARATYPE_ERR:
        fprintf(erroutput, "%d PARATYPE_ERR: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(TOENDMID);
        break;
    case ORDER_ERR:
        fprintf(erroutput, "%d ORDER_ERR: l:%d c:%d\n", count, lc, cc);
        deal(DONOTHING);
        break;
    case LACK_RBBRACK:
        fprintf(erroutput, "%d LACK_RBBRACK: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        //printf("%d LACK_RBBRACK: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(DONOTHING);
        break;
    case NOTDEFINED_ERR:
        fprintf(erroutput, "%d NOTDEFINED_ERR: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(TOHEAD);
        break;
    case LACK_BECOME:
        fprintf(erroutput, "%d LACK_BECOME: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        //printf("%d LACK_BECOME: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(TOHEAD);
        break;
    case SOMETHINGELSE:
        fprintf(erroutput, "%d SOMETHINGELSE: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(TOHEAD);
        break;
    case SENTENCE_ERR:
        fprintf(erroutput, "%d SENTENCE_ERR: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(TOHEAD);
        break;
    case CALLNONRET_ERR:
        fprintf(erroutput, "%d CALLNONRET_ERR: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(TOENDMID);
        break;
    case ILLEGALSYM_ERR:
        fprintf(erroutput, "%d ILLEGALSYM_ERR: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(TOHEAD);
        break;
    case LACK_ELSE:
        fprintf(erroutput, "%d LACK_ELSE: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(DONOTHING);
        break;
    case LACK_LSBRACK:
        fprintf(erroutput, "%d LACK_LSBRACK: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(TOHEAD);
        break;
    case CASE_ERR:
        fprintf(erroutput, "%d CASE_ERR: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(TOEND);
        break;
    case LACK_COLON:
        fprintf(erroutput, "%d LACK_COLON: l:%d c:%d \'%s\'\n", count, lc, cc, buf);
        deal(TOEND);
        break;
    case FUNCDEFINFUNC_ERR:
        fprintf(erroutput, "%d FUNCDEFINFUNC_ERR: l:%d c:%d\n", count, lc, cc, buf);
        deal(DONOTHING);
        break;
    case REDEFINE_ERR:
        fprintf(erroutput, "%d REDEFINE_ERR: l:%d c:%d\n", count, lc, cc);
        deal(DONOTHING);
        break;
    case OUTOFTABLE_ERR:
        fprintf(erroutput, "%d OUTOFTABLE_ERR: l:%d c:%d\n", count, lc, cc, buf);
        deal(DONOTHING);
        break;
    case LACK_LMBRACK:
        fprintf(erroutput, "%d LACK_LMBRACK: l:%d c:%d\n", count, lc, cc, buf);
        deal(TOHEAD);
        break;
    case FACTOR_ERR:
        fprintf(erroutput, "%d FACTOR_ERR: l:%d c:%d\n", count, lc, cc, buf);
        deal(TOENDMID);
        break;
    case MID_ERR:
        fprintf(erroutput, "%d MID_ERR:\n");
        break;
    }
    return 0;
}

void deal(int type){
    switch(type){
    case DONOTHING:
        break;
    case TOHEAD:
        while(symid != CONSTSY && symid != IFSY && symid != ELSESY && symid != SWITCHSY && symid != CASESY
         && symid != DEFAULTSY && symid != RETURNSY && symid != WHILESY && symid != PRINTFSY && symid != SCANFSY
          && symid != INTSY && symid != CHARSY && symid != VOIDSY && symid != LBBRACK && symid != RBBRACK){
            nextsym();
        }
        break;
    case TOEND:
        while(symid != SEMICOLON){
            nextsym();
        }
        break;
    case TOENDMID:
        while(symid != COMMA && symid != RSBRACK && symid != PLUS && symid != MINUS && symid != COLON && symid != SEMICOLON && symid == RMBRACK){
            nextsym();
        }
        break;
    case FATAL:
        exit(0);
    }
}
