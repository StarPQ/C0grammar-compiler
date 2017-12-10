#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"intermed.h"
#include"err.h"
#include"semantic.h"
#include"global.h"
#include"table.h"
#include"lexing.h"

int hasreturn;
int mainlabel = 1;
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
    insertMid("ret", nowitem, EMPTY, EMPTY);
    if(symid != SEMICOLON) err(LACK_SEMICOLON);
    else nextsym();
    hasreturn = 1;
    // if this function is returnable midRet();else err
}
void Printfsentence(){
    //when coming in: buf --> 'printf'
    if(debug) printf("This is a printf sentence!\n");
    nextsym();
    if(symid == LSBRACK){
        nextsym();
        if(symid == STRING){
            insertMid("printf", "string", buf, EMPTY);
            nextsym();
            if(symid == COMMA){
                nextsym();
                Expression();
                insertMid("printf", "number", nowitem, EMPTY);
            }
        }
        else{
            Expression();
            insertMid("printf", "number", nowitem, EMPTY);
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
                insertMid("scanf", var->name, EMPTY, EMPTY);
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
    insertMid("push", nowitem, EMPTY, EMPTY);
    while(symid == COMMA){
        nextsym();
        Expression();
        if(i < paranum){
            printf("push\n");
            /*if(i == paranum - 1){
                insertMid("pushJ", nowitem, EMPTY, EMPTY);
                i++;
            }
            else{*/
                insertMid("push", nowitem, EMPTY, EMPTY);
                i++;
            //}
        }
    }
    printf("push %d para\n", i);
    if(i < paranum){
            err(LACK_NUM);// lack para
    }
    return;
}
void Callfunc(){
    // when coming in: buf --> identifier
    if(debug) printf("This is a call of function!\n");
    Link func;
    func = find(buf);
    if(func == 0){
        err(NOTDEFINED_ERR);
        return;
    }
    insertMid("call", func->name, EMPTY, EMPTY);
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
    char l1[200] = {'\0'};
    strcpy(l1, "LABEL_");
    strcat(l1, func->name);
    insertMid("jal", l1, EMPTY, EMPTY);
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
void Case(char* key, char* lexit){
    //when coming in: buf --> 'case'
    if(debug) printf("This is a case!\n");
    char l1[20], casex[20] = {'\0'};
    strcpy(l1, nextlabel());// apply a label
    nextsym();
    if(symid == PLUS || symid == MINUS){
        int id = symid;
        //strcpy(casex, buf);
        nextsym();
        if(symid == NUMBER){
            Factor(id);
            strcat(casex, nowitem);
            strcpy(nowitem, nextvar());
            insertMid(nowitem, key, "==", casex);
            insertMid("BZ", nowitem, l1, EMPTY);
        }
        else{
            err(CASE_ERR);
            return;
        }
    }
    else if(symid == CHAR){
        Factor(PLUS);
        strcat(casex, nowitem);
        //itoa(buf[0], casex, 10);
        strcpy(nowitem, nextvar());
        insertMid(nowitem, key, "==", casex);
        insertMid("BZ", nowitem, l1, EMPTY);
    }
    else if(symid == NUMBER){
        Factor(PLUS);
        strcat(casex, nowitem);
        //strcpy(casex, buf);
        strcpy(nowitem, nextvar());
        insertMid(nowitem, key, "==", casex);
        insertMid("BZ", nowitem, l1, EMPTY);
    }
    else{
        err(ILLEGALSYM_ERR);
        return;
    }
    //nextsym();
    if(symid == COLON){
        nextsym();
        Sentence();
    }
    else{
        err(LACK_COLON);
        return;
    }
    insertMid("goto", lexit, EMPTY, EMPTY);
    insertMid(l1, ":", EMPTY, EMPTY);
    return;
}
void Caselist(char* key, char* lexit){
    //when coming in: buf --> first aym
    if(debug) printf("This is a caselist!\n");
    if(symid == CASESY){
        Case(key, lexit);
    }
    else{
        err(SENTENCE_ERR);
    }
    while(symid == CASESY){
        Case(key, lexit);
    }
    return;
}
void Switch(){
    //when coming in: buf --> 'switch'
    if(debug) printf("This is a switch sentence!\n");
    char key[20], lexit[20];
    strcpy(lexit, nextlabel());
    nextsym();
    if(symid == LSBRACK){
        nextsym();
        Expression();
        strcpy(key, nowitem);
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
        Caselist(key, lexit);
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
    insertMid(lexit, ":", EMPTY, EMPTY);
    return;
}
void Loop(){
    //when coming in: buf --> 'while'
    if(debug) printf("This is a while{} sentence!\n");
    char l1[20], l2[20];
    strcpy(l1, nextlabel());
    strcpy(l2, nextlabel());// apply 2 labels
    insertMid(l1, ":", EMPTY, EMPTY);
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
    insertMid("BZ", nowitem, l2, EMPTY);
    Sentence();
    insertMid("goto", l1, EMPTY, EMPTY);
    insertMid(l2, ":", EMPTY, EMPTY);
    return;
}
void Condition(){
    //when coming in: buf --> first sym
    if(debug) printf("This is a condition!\n");
    char var1[20], var2[20], op[20];
    Expression();
    strcpy(var1, nowitem);
    if(symid >= EQL && symid <= LEQ){
        int id = symid;
        strcpy(op, buf);
        nextsym();
        Expression();
        strcpy(var2, nowitem);
        strcpy(nowitem, nextvar());
        insertMid(nowitem, var1, op, var2);
        return;
    }
    return;
}
void Conditionsentence(){
    //when coming in: buf --> 'if'
    if(debug) printf("This is a condition sentence!\n");
    char l1[20], l2[20];
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
    strcpy(l1, nextlabel());
    strcpy(l2, nextlabel());// apply 2 labels
    insertMid("BZ", nowitem, l1, EMPTY);
    Sentence();
    insertMid("goto", l2, EMPTY, EMPTY);
    if(symid == ELSESY){
        insertMid(l1, ":", EMPTY, EMPTY);
        nextsym();
        Sentence();
        insertMid(l2, ":", EMPTY, EMPTY);
    }
    else err(LACK_ELSE);
    return;
}
void Becomes(Link tmp){
    //when coming in: buf --> '= | ['
    if(debug) printf("This is a become sentence!\n");
    int place = 0;
    char topass[MAX_wl+10] = {'\0'};
    char index[20] = {'\0'};
    strcpy(topass, tmp->name);
    if(tmp->isarray){
        if(symid == LMBRACK){
            nextsym();
            if(symid == NUMBER){
                place = num;
                strcat(index, buf);
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
        insertMid(topass, index, "=", nowitem);
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
void Factor(int op){
    //when coming in: buf -->  + / - / identifier
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
                // is array
                char topass[MAX_wl+10] = {'\0'};
                strcat(topass, nowitem);//get iden[exp]
                strcpy(nowitem, nextvar());
                insertMid(nowitem, "=", tmp->name, topass);
            }
            else{
                //is var get name of var
                strcpy(nowitem, tmp->name);
            }
        }
        else if(tmp->type == FUNCTION){
            if(tmp->isreturn){
                Callfunc();
                strcpy(nowitem, nextvar());
                insertMid(nowitem, "=", "RET", EMPTY);
                return;
            }
            else{
                err(CALLNONRET_ERR);
            }
        }
    }
    // else if(symid == PLUS || symid == MINUS){
    //     nextsym();
    //     if(symid == NUMBER){
    //         midOperation();
    //     }
    //     else{
    //         err(LACK_NUM);
    //         return;
    //     }
    // }
    else if(symid == NUMBER){
        char tmp[50] = {'\0'};
        strcpy(nowitem, nextvar());
        insertMid("li", nowitem, buf, EMPTY);
    }
    else if(symid == CHAR){
        // get ascii type char and transfor it to char*
        char topass[5] = {'\0'};
        itoa(buf[0], topass, 10);
        strcpy(nowitem, nextvar());
        insertMid("li", nowitem, topass, EMPTY);
    }
    else if(symid == LSBRACK){
        nextsym();
        Expression();
        // nowitem get from Expression
    }
    else{
        err(FACTOR_ERR);
    }
    nextsym();
    char addop[50] = {'\0'};
    if(op == MINUS){
        strcpy(addop, nowitem);
        strcpy(nowitem, nextvar());
        insertMid(nowitem, "\0", "-", addop);
    }
    // strcat(addop, nowitem);
    // strcpy(nowitem, addop);
}
void Item(int op){
    //when coming in: buf --> identifier/num/etc
    if(debug) printf("This is a item!\n");
    char var1[ 200 ], var2[ 200 ], head[ 200 ];
    int id;
    Factor(op);
    strcpy(head, nowitem);//这种操作是为了对付只有赋值的情况
    while(symid == TIMES || symid == IDIV){
        strcpy(var1, head);
        id = symid;
        nextsym();// get +/-
        if(symid == PLUS || symid == MINUS){
            int fid = symid;
            nextsym();
            Factor(fid);// ++2/+-2
        }
        else{
            Factor(PLUS);//+2
        }
        if(id == TIMES){
            strcpy(var2, nowitem);
            strcpy(head, nextvar());//申请临时变量
            insertMid(head, var1, "*", var2);
            continue;
        }
        else if(id == IDIV){
            strcpy(var2, nowitem);
            strcpy(head, nextvar());
            insertMid(head, var1, "/", var2);
            continue;
        }
    }
    strcpy(nowitem, head);
    return;
}
void Expression(){
    //when coming in: buf --> first sym
    if(debug) printf("This is a expression!\n");
    char var1[ 30 ], var2[ 30 ], head[ 30 ];
    int id;
    if(symid == PLUS){
        nextsym();
        if(symid == PLUS || symid == MINUS){
            id = symid;
            nextsym();
            Item(id);// ++2/+-2
        }
        else{
            Item(PLUS);//+2
        }
        strcpy(head, nowitem);
    }
    else if(symid == MINUS){
        nextsym();
        if(symid == PLUS || symid == MINUS){
            id = symid;
            nextsym();
            Item(id);// -+2/--2
            strcpy(var1, nowitem);
            strcpy(head, nextvar());
            insertMid(head, "0 ", "-", var1); //head = 0 - (var1)
        }
        else{
            Item(MINUS);//-2
            strcpy(head, nowitem);
        }
    }
    else{
        Item(PLUS);// 2
        strcpy(head, nowitem);
    }
    /*////////////////////////////////////////////////////////////////////////////////
    if ( symid == PLUS || symid == MINUS ) {
        if ( symid == PLUS ) {
            nextsym();
            Item(PLUS);//项，结束后，项的结果会放入全局变量nowitem
            strcpy(head, nowitem);//把项的结果放入临时变量的位置
        }
        if ( symid == MINUS ) {
            nextsym();
            Item(MINUS);//项
            strcpy(var1, nowitem);
            strcpy(head, nextvar());
            insertMid(head, "0 ", "-", var1); //head = 0 - (var1)
        }
    }
    else {
        Item(PLUS);
        strcpy(head, nowitem);
    }
    *//////////////////////////////////////////////////////////////////////////////////
    while(symid == PLUS || symid == MINUS){
        id = symid;
        nextsym();
        if(symid == PLUS){
            nextsym();
            Item(PLUS);
        }
        else if(symid == MINUS){
            nextsym();
            Item(MINUS);
        }
        else{
            Item(PLUS);
        }
        strcpy(var1, head);
        if ( id == PLUS ) {
            strcpy(var2, nowitem);
            strcpy(head, nextvar());
            insertMid(head, var1, "+", var2);
            continue;
        }
        else {
            strcpy(var2, nowitem);
            strcpy(head, nextvar());
            insertMid(head, var1, "-", var2);
            continue;
        }
    }
    strcpy(nowitem, head);
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
    if(debug) printf("This is a mainfunction!\n");\
    insertMid("LABEL_MAIN", ":", EMPTY, EMPTY);
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
    insertMid("void", "main", "()", EMPTY);
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
            insertMid("para", "int", identifier, EMPTY);
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
            insertMid("para", "char", identifier, EMPTY);
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
    hasreturn = 0;
    midLabel(identifier);
    enterTable(identifier, FUNCTION, ret, 0, 0);
    //strcat(identifier, "()\0");
    if(type == INTTYPE){
        insertMid("int", identifier, "()", EMPTY);
    }
    else if(type == CHARTYPE){
        insertMid("char", identifier, "()", EMPTY);
    }
    else{
        insertMid("void", identifier, "()", EMPTY);
    }
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
        printf("func %s has %d paras\n", tmp->name, tmp->paranum);
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
    reset();
    if(type == INTTYPE || type == CHARTYPE){
        if(!hasreturn){
            err(LACK_RETURN);
        }
    }
    if(!hasreturn) insertMid("ret", EMPTY, EMPTY, EMPTY);
    insertMid("end", EMPTY, EMPTY, EMPTY);
    return;
}
void Vardef(int type){
    // when coming in: buf --> identifier
    if(debug) printf("This is a variable definition!\n");
    char* value;
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
            char listlen[6] = {'\0'};
            strcpy(listlen, buf);
            if(type == INTTYPE)insertMid("var", "int", identifier, listlen);
            else insertMid("var", "char", identifier, listlen);
        }
        nextsym();
        if(symid != RMBRACK){
            err(LACK_RMBRACK);
            return;
        }
        else{
            nextsym();
        }
    }
    else{
        if(type == INTTYPE)insertMid("var", "int", identifier, EMPTY);
        else insertMid("var", "char", identifier, EMPTY);
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
            char listlen[6] = {'\0'};
            strcpy(listlen, buf);
            nextsym();
            if(symid == RMBRACK){
                enterTable(identifier, type, detail, 0, paranum);
                if(type == INTTYPE){
                    insertMid("var", "int", identifier, listlen);
                }
                else{
                    insertMid("var", "char", identifier, listlen);
                }
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
    else{
        enterTable(identifier, type, detail, 0, paranum);// put the first variable into table
        if(type == INTTYPE)insertMid("var", "int", identifier, EMPTY);
        else insertMid("var", "char", identifier, EMPTY);
    }
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
        if(mainlabel){
            insertMid("goto", "LABEL_MAIN", EMPTY, EMPTY);
            mainlabel = 0;
        }
        Funcdef(type, identifier, ret);
        return FUNCTION;
    }
    else if(statetype == MAINFUNCTION){
        if(mainlabel){
            insertMid("goto", "LABEL_MAIN", EMPTY, EMPTY);
            mainlabel = 0;
        }
        Mainfunc();
        return MAINFUNCTION;
    }
}
void Constdef(int type){
    // when coming in: buf --> identifier
    if(debug) printf("This is a constant definition!\n");
    char* value;
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
            int id = symid;
            nextsym();
            if(symid == NUMBER){
                value = num;
                if(id == MINUS){
                    char tmp[200] = {'\0'};
                    strcpy(tmp, "-");
                    strcat(tmp, buf);
                    insertMid("const int", identifier, "=", tmp);
                }
                else insertMid("const int", identifier, "=", buf);
            }
            else{
                err(LACK_NUM);
                return;
            }
        }
        else if(symid == NUMBER){
            value = num;
            insertMid("const int", identifier, "=", buf);
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
            value = buf;
            char toint[4] = {'\0'};
            itoa(buf[0], toint, 10);
            insertMid("const char", identifier, "=", toint);
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
    mainlabel = 1;
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
            if(ch == EOF) break;
            err(FUNCSTATE_ERR);
            nextsym();
            if(Statehead(INTSY) == VARIABLE) err(ORDER_ERR);
            if(mainflag == 1) break;
        }
        printf("here\n");
    }
    if(ch != EOF) err(REDUNDUNT); // there is something after main, ignored
    if(mainflag == 0) err(LACK_MAIN);
    return;
}
