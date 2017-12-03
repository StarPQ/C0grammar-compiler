#include<stdio.h>
#include<string.h>
#include"intermed.h"
#include"err.h"
#include"semantic.h"
#include"global.h"
#include"table.h"
#include"lexing.h"

void Returnsentence(){
    //when coming in: buf --> 'return'
    if(debug) printf("This is a return sentence!\n");
    nextsym();
    if(symid == LSBRACK){
        nextsym();
        Expression();
        if(symid == RSBRACK){
            nextsym();
        }
        else{
            err(LACK_RBBRACK);
        }
    }
    //TODO: check isreturn
    midRet();
    if(symid != SEMICOLON) err(LACK_SEMICOLON);
    else nextsym();
    // if this function is returnable midRet();else err
}

void Printfsentence(){
    //when coming in: buf --> 'printf'
    if(debug) printf("This is a printf sentence!\n");
    nextsym();
    if(symid == LSBRACK){
        nextsym();
        if(symid == STRING){
            //midPrintf();
            nextsym();
            if(symid == COMMA){
                nextsym();
                Expression();
                //midPrintf();
            }
        }
        else{
            Expression();
            //midPrintf();
        }
        if(symid != RSBRACK) err(LACK_RSBRACK);
        else nextsym();
    }
    else{
        err(LACK_LSBRACK);
        return;
    }
    if(symid != SEMICOLON) err(LACK_SEMICOLON);
    else nextsym();
    return;
}

void Scanfsentence(){
    //when coming in: buf --> 'scanf'
    if(debug) printf("This is a scanf sentence!\n");
    Link var;
    nextsym();
    if(symid == LSBRACK){
        do{
            nextsym();
            if(symid == IDEN){
                var = find(buf);
                if(var == 0){
                    err(NOTDEFINED_ERR);
                }
                // TODO: modify list??
                //midScanf();
                nextsym();
            }
            else{
                err(SENTENCE_ERR);
            }
        }while(symid == COMMA);
        if(symid != RSBRACK) err(LACK_RSBRACK);
        else nextsym();
    }
    else{
        err(LACK_LSBRACK);
        return;
    }
    if(symid != SEMICOLON) err(LACK_SEMICOLON);
    else nextsym();
    //midScanf();
    return;
}

void Paralist2pass(int paranum){
    // when coming in: buf --> first sym
    if(debug) printf("This is a paralist2pass!\n");
    int i = 1;
    Expression();
    while(symid == COMMA){
        nextsym();
        Expression();
        if(i < paranum){
            midPush();
            i++;
        }
    }
    return;
}

void Callfunc(){
    // when coming in: buf --> identifier
    if(debug) printf("This is a call of function!\n");
    Link func;
    func = find(buf);
    nextsym();
    if(func->paranum > 0){
        if(symid == LSBRACK){
            nextsym();
            Paralist2pass(func->paranum);
            if(symid != RSBRACK) err(LACK_RSBRACK);
            else nextsym();
        }
        else{
            err(LACK_LSBRACK);
            return;
        }
    }
    midCall();
    return;
}
void Default(){
    //when coming in: buf --> defsult
    if(debug) printf("This is a default!");
    nextsym();
    if(symid == COLON){
        nextsym();
        Sentence();
    }
    else{
        err(LACK_COLON);
        return;
    }
    return;
}
void Case(){
    //when coming in: buf --> 'case'
    if(debug) printf("This is a case!\n");
    nextsym();
    midLabel();
    if(symid == PLUS || symid == MINUS){
        nextsym();
        if(symid == NUMBER){
            midBZ();
        }
        else{
            err(CASE_ERR);
            return;
        }
    }
    else if(symid == CHAR || symid == NUMBER){
        midBZ();
    }
    else{
        err(ILLEGALSYM_ERR);
        return;
    }
    nextsym();
    if(symid == COLON){
        nextsym();
        Sentence();
    }
    else{
        err(LACK_COLON);
        return;
    }
    return;
}
void Caselist(){
    //when coming in: buf --> first aym
    if(debug) printf("This is a caselist!\n");
    if(symid == CASESY){
        Case();
    }
    else{
        err(SENTENCE_ERR);
    }
    while(symid == CASESY){
        Case();
    }
    return;
}
void Switch(){
    //when coming in: buf --> 'switch'
    if(debug) printf("This is a switch sentence!\n");
    nextsym();
    if(symid == LSBRACK){
        nextsym();
        Expression();
        if(symid != RSBRACK){
            err(LACK_RSBRACK);
        }
        else nextsym();
    }
    else{
        err(LACK_LSBRACK);
    }
    if(symid == LBBRACK){
        nextsym();
        Caselist();
        if(symid == DEFAULTSY){
            Default();
        }
        if(symid != RBBRACK){
            err(LACK_RBBRACK);
        }
        else{
            nextsym();
        }
    }
    else {
        err(LACK_LBBRACK);
    }
    return;
}
void Loop(){
    //when coming in: buf --> 'while'
    if(debug) printf("This is a while{} sentence!\n");
    nextsym();
    if(symid == LSBRACK){
        nextsym();
        Condition();
        if(symid != RSBRACK){
            err(LACK_RSBRACK);
        }
        else{
            nextsym();
        }
        midBZ();
    }
    else{
        err(LACK_LSBRACK);
        return;
    }
    midLabel();
    Sentence();
    midLabel();
    return;
}
void Condition(){
    //when coming in: buf --> first sym
    if(debug) printf("This is a condition!\n");
    Expression();
    if(symid >= EQL && symid <= LEQ){
        int id = symid;
        nextsym();
        Expression();
        midOperation();
        midBNZ();
        return;
    }
    midBZ();
    return;
}
void Conditionsentence(){
    //when coming in: buf --> 'if'
    if(debug) printf("This is a condition sentence!\n");
    nextsym();
    if(symid == LSBRACK){
        nextsym();
        Condition();
        if(symid != RSBRACK){
            err(LACK_RSBRACK);
        }
        else{
            nextsym();
        }
    }
    else{
        err(LACK_LSBRACK);
        return;
    }
    midLabel();
    Sentence();
    midGOTO();
    if(symid == ELSESY){
        midLabel();
        nextsym();
        Sentence();
    }
    else err(LACK_ELSE);
    return;
}
void Becomes(Link tmp){
    //when coming in: buf --> '= | ['
    if(debug) printf("This is a become sentence!\n");
    int place = 0;
    if(tmp->isarray){
        if(symid == LMBRACK){
            nextsym();
            if(symid == NUMBER){
                place = num;
            }
            else{
                err(LACK_NUM);
                return;
            }
            nextsym();
            if(symid == RMBRACK){
                nextsym();
            }
            else{
                err(LACK_RMBRACK);
            }
        }
        else{
            err(LACK_LMBRACK);
            return;
        }
    }
    if(symid == BECOMES){
        nextsym();
        Expression();
    }
    else{
        err(LACK_BECOME);
        return;
    }
    if(symid == SEMICOLON){
        nextsym();
    }
    else err(LACK_SEMICOLON);
}
void Factor(){
    //when coming in: buf --> * / / / + / -
    if(debug) printf("This is a factor!\n");
    if(symid <= IDIV) nextsym();
    if(symid ==IDEN){
        Link tmp = find(buf);
        if(tmp == 0){
            err(NOTDEFINED_ERR);
            return;
        }
        if(tmp->type == INTTYPE || tmp->type == CHARTYPE){
            if(tmp->isarray){
                nextsym();
                if(symid == LMBRACK){
                    nextsym();
                    Expression();
                    if(symid != RMBRACK){
                        err(LACK_RMBRACK);
                    }
                }
                midArray_get();
                midOperation();
            }
            else{
                midOperation();
            }
        }
        else if(tmp->type == FUNCTION){
            if(tmp->isreturn){
                Callfunc();
                return;
            }
            else{
                err(CALLNONRET_ERR);
            }
        }
    }
    else if(symid == PLUS || symid == MINUS){
        nextsym();
        if(symid == NUMBER){
            midOperation();
        }
        else{
            err(LACK_NUM);
            return;
        }
    }
    else if(symid == NUMBER){
        midOperation();
    }
    else if(symid == CHAR){
        midOperation();
    }
    else if(symid == LSBRACK){
        nextsym();
        Expression();
    }
    else{
        err(FACTOR_ERR);
    }
    nextsym();
}
void Item(int op){
    //when coming in: buf --> +/-
    if(debug) printf("This is a item!\n");
    if(symid <= IDIV) nextsym();
    Factor();
    while(symid == TIMES || symid == IDIV){
        Factor();
    }
    midOperation();
    return;
}
void Expression(){
    //when coming in: buf --> first sym
    if(debug) printf("This is a expression!\n");
    if(symid == PLUS || symid == MINUS){
        Item(symid);
    }
    else Item(PLUS);
    while(symid == PLUS || symid == MINUS){
        Item(symid);
    }
    return;
}
int Sentence(){
    //when coming in: buf --> first sym
    if(debug) printf("This is a sentence!\n");
    if(0) printf("-->%s\n", buf);
    if(symid == IFSY){
        Conditionsentence();
    }
    else if(symid == WHILESY){
        Loop();
    }
    else if(symid == IDEN){
        Link tmp = find(buf);
        if(tmp == 0){
            err(NOTDEFINED_ERR);
            return 0;
        }
        if(tmp->type == FUNCTION){
            Callfunc(tmp);
            if(symid != SEMICOLON) err(LACK_SEMICOLON);
            else nextsym();
        }
        else if(tmp->type == INTTYPE || tmp->type == CHARTYPE){
            nextsym();
            Becomes(tmp);
        }
        else{
            err(SOMETHINGELSE);
        }
    }
    else if(symid == SWITCHSY){
        Switch();
    }
    else if(symid == LBBRACK){
        nextsym();
        Sentencelist();
    }
    else if(symid == SCANFSY){
        Scanfsentence();
    }
    else if(symid == PRINTFSY){
        Printfsentence();
    }
    else if(symid == RETURNSY){
        Returnsentence();
    }
    else if(symid == SEMICOLON){
        nextsym();
    }
    else if(symid == RBBRACK){
        return 0;
    }
    else if(symid == INTSY || symid == CHARSY || symid == VOIDSY){
        return 1;
    }
    else{
        err(SENTENCE_ERR);
    }
    return 0;
}
void Sentencelist(){
    //when coming in: buf --> first word
    if(debug) printf("This is a sentencelist!\n");
    while(symid != RBBRACK){
        if(Sentence() == 1){
            err(LACK_RBBRACK);//if get funcdef in sentencelist. means lack }
            return;
        }
    }
    nextsym();
    return;
}
void Compound(){
    //when coming in: buf --> first word
    if(debug) printf("This is a compound!\n");
    while(symid == CONSTSY){
        Conststate();
    }
    // variable state
    while(1){
        if(symid == INTSY || symid == CHARSY){
            int id = symid;
            nextsym();
            Statehead(id);
        }
        else{
            break;
        }
    }
    Sentencelist();
    return;
}
void Mainfunc(){
    //when coming in: buf --> '('
    if(debug) printf("This is a mainfunction!\n");
    if(symid == LSBRACK){
        nextsym();
        if(symid != RSBRACK)
            err(LACK_RSBRACK);
        else nextsym();
    }
    else err(LACK_LSBRACK);
    if(symid != LBBRACK){
        err(LACK_LBBRACK);
    }
    else nextsym();
    char identifier[5];
    strcpy(identifier, "main");
    enterTable(identifier, MAINFUNCTION, NON, 0, 0);
    Compound();
    return;
}
int Paralist(){
    //when coming in: buf --> '('
    if(debug) printf("This is a paralist!\n");
    int type;
    int paracount = 0;
    char identifier[MAX_wl] = {'\0'};
    do{
        nextsym();
        if(symid == INTSY){
            type = INTTYPE;
            nextsym();
            if(symid == IDEN){
                strcpy(identifier, buf);
            }
            else{
                err(SYMBOLCONFLICT_ERR);
                continue;
            }
            nextsym();
            enterTable(identifier, type, PARAMETER, 0, 0);
        }
        else if(symid == CHARSY){
            type = CHARTYPE;
                    nextsym();
            if(symid == IDEN){
                strcpy(identifier, buf);
            }
            else{
                err(SYMBOLCONFLICT_ERR);
                continue;
            }
            nextsym();
            enterTable(identifier, type, PARAMETER, 0, 0);
        }
        else{
            err(PARATYPE_ERR);
            return;
        }
        paracount++;
    }while(symid == COMMA);
    return paracount;
}
void Funcdef(int type, char *identifier, int ret){
    //when coming in: buf --> '( | {'
    if(debug) printf("This is a function definition!\n");
    enterTable(identifier, FUNCTION, ret, 0, 0);
    int paracount = 0;
    if(symid == LSBRACK){
        paracount = Paralist();
        Link tmp = find(identifier);
        if(tmp == 0){
            err(NOTDEFINED_ERR);
            pop();
            return;
        }
        tmp->paranum = paracount;
        if(symid != RSBRACK){
            err(LACK_RSBRACK);
        }
        else nextsym();
    }

    if(symid != LBBRACK){
        err(LACK_LBBRACK);
    }
    else nextsym();
    Compound();
    // } in compound
    pop();
    return;
}
void Vardef(int type){
    // when coming in: buf --> identifier
    if(debug) printf("This is a variable definition!\n");
    int value;
    int detail = 0;
    int paranum = 0;
    char identifier[MAX_wl] = {'\0'};
    if(symid == IDEN){
        strcpy(identifier, buf);
    }
    else{
        err(SYMBOLCONFLICT_ERR);
        return;
    }
    nextsym();
    if(symid == LMBRACK){
        nextsym();
        if(symid != NUMBER){
            err(LACK_NUM);
            return;
        }
        else{
            detail = ARRAY;
            paranum = num;
        }
        nextsym();
        if(symid != RMBRACK){
            err(LACK_RMBRACK);
            return;
        }
        else nextsym();
    }
    enterTable(identifier, type, detail, 0, paranum);
    return;
}
void Varstate(int type, char *identifier){
    // when coming in: buf --> ', | ; | ['
    if(debug) printf("This is a variable statement!\n");
    if(debug) printf("This is a variable definition!\n");
    int paranum = 0;
    int detail = 0;
    // whether it is array
    if(symid == LMBRACK){
        nextsym();
        if(symid == NUMBER){
            paranum = num;
            detail = ARRAY;
            nextsym();
            if(symid == RMBRACK){
                enterTable(identifier, type, detail, 0, paranum);
                nextsym();
            }
            else{
                err(LACK_RMBRACK);
            }
        }
        else{
            err(LACK_NUM);
        }
    }
    else enterTable(identifier, type, detail, 0, paranum);// put the first variable into table
    while(symid == COMMA){
        nextsym();
        Vardef(type);
    };
    if(symid != SEMICOLON){
        err(LACK_SEMICOLON);
    }
    else nextsym();
    return;
}
int Statehead(int type){
    //when coming in: buf --> identifier
    if(debug)printf("This is a Statehead!\n");
    int errflag = 0;
    int statetype = VARIABLE;
    int ret = 0;
    char identifier[MAX_wl] = {'\0'};
    // if it's return type is void
    if(type == VOIDSY){
        // it is main()
        if(symid == MAINSY){
            statetype = MAINFUNCTION;
            mainflag = 1; // found main()
            nextsym();
        }
        else{
            statetype = FUNCTION; // normal function
            if(symid == IDEN){
                strcpy(identifier, buf);
            }
            else{
                err(SYMBOLCONFLICT_ERR);
                return;
            }
            nextsym();
        }
    }
    else{
        if(type == INTSY) type = INTTYPE;
        if(type == CHARSY) type = CHARTYPE;
        if(symid == IDEN){
            strcpy(identifier, buf);
        }
        else{
            err(SYMBOLCONFLICT_ERR);
            return;
        }
        nextsym();
        if(symid == LSBRACK || symid == LBBRACK){
            statetype = FUNCTION; // normal function
            ret = 3;
        }
    }
    if(statetype == VARIABLE){
        Varstate(type, identifier);
        return VARIABLE;
    }
    else if(statetype == FUNCTION){
        Funcdef(type, identifier, ret);
        return FUNCTION;
    }
    else if(statetype == MAINFUNCTION){
        Mainfunc();
        return MAINFUNCTION;
    }
}
void Constdef(int type){
    // when coming in: buf --> identifier
    if(debug) printf("This is a constant definition!\n");
    int value;
    char identifier[MAX_wl] = {'\0'};
    if(type == INTSY){
        type = INTTYPE;
        if(symid == IDEN){
            strcpy(identifier, buf);
        }
        else{
            err(SYMBOLCONFLICT_ERR);
            return;
        }
        nextsym();
        if(symid != BECOMES){
            err(CONSTNOTDEF_ERR);
            return;
        }
        nextsym();
        if(symid == PLUS || symid == MINUS){
            nextsym();
            if(symid == NUMBER){
                value = num;
            }
            else{
                err(LACK_NUM);
                return;
            }
        }
        else if(symid == NUMBER){
            value = num;
        }
        else{
            err(LACK_NUM);
            return;
        }
    }
    else if(type == CHARSY){
        type = CHARTYPE;
        if(symid == IDEN){
            strcpy(identifier, buf);
        }
        else{
            err(SYMBOLCONFLICT_ERR);
            return;
        }
        nextsym();
        if(symid != BECOMES){
            err(CONSTNOTDEF_ERR);
            return;
        }
        nextsym();
        if(symid != CHAR){
            err(LACK_CHAR);
            return;
        }
        else{
            value = buf[0];
        }
    }
    else{
        err(DEFTYPE_ERR);
        return;
    }
    enterTable(identifier, type, CONST, value, 0);
    nextsym();
    return;
}
void Conststate(){
    // when coming in: buf --> 'const'
    if(debug) printf("This is a constant statement!\n");
    nextsym();
    int type = symid;
    do{
        nextsym();
        Constdef(type);
    }while(symid == COMMA);
    if(symid != SEMICOLON){
        err(LACK_SEMICOLON);
    }
    else nextsym();
    return;
}
void Program(){
    Top = -1;
    Level = 0;
    mainflag = 0;
    if(debug) printf("This is a program!\n");
    nextsym();
    //const state
    while(symid == CONSTSY){
        Conststate();
    }
    // variable state
    while(1){
        if(symid == INTSY || symid == CHARSY){
            int id = symid;
            nextsym();
            if(Statehead(id) == FUNCTION) break;
        }
        else{
            if(symid == VOIDSY) break;
            else{
                err(VARSTATE_ERR);
            }
        }
    }
    // function state
    while(1){
        if(symid == INTSY || symid == CHARSY || symid == VOIDSY){
            int id = symid;
            nextsym();
            if(Statehead(id) == VARIABLE) err(ORDER_ERR);
            if(mainflag == 1) break;
        }
        else{
            err(FUNCSTATE_ERR);
            nextsym();
            if(Statehead(INTSY) == VARIABLE) err(ORDER_ERR);
            if(mainflag == 1) break;
        }
    }
    if(ch != EOF) err(REDUNDUNT); // there is something after main, ignored
    if(mainflag == 0) err(LACK_MAIN);
    return;
}
