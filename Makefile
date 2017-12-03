objects = main.o lexing.o err.o semantic.o intermed.o \
	table.o optimization.o asm.o
edit : $(objects)
	cc -o edit $(objects)
main.o : main.c err.h lexing.h semantic.h global.h
	cc -c main.c 
lexing.o : lexing.c lexing.h err.h global.h
	cc -c lexing.c
err.o :  err.c err.h lexing.h
	cc -c err.c
semantic.o : semantic.c semantic.h lexing.h err.h global.h table.h intermed.h
	cc -c semantic.c
intermed.o : intermed.c intermed.h
	cc -c intermed.c
table.o : table.c table.h 
	cc -c table.c
optimization.o : optimization.c
	cc -c optimization.c
asm.o : asm.c
	cc -c asm.c

.PHONY : clean
       clean :
               -rm edit $(objects)