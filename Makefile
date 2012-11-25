FLEX=flex
BISON=bison
CC=g++

PROGRAMA = c-like-parser
LEXICO = lexico.l
SINTATICO = sintatico.y

$(PROGRAMA): $(LEXICO) $(SINTATICO)
	$(BISON) -d -r all -v -k $(SINTATICO)
	$(FLEX) $(LEXICO)
#	$(CC) *.c -o $(PROGRAMA) -I. -B .
	$(CC) -c *.c -I. -w
	$(CC) *.o -o $(PROGRAMA)

clean:
	rm -f *.yy.c
	rm -f *.tab.c
	rm -f *.tab.h
	rm -f *.o
	rm -f *.output
	rm -f $(PROGRAMA)


build:
	$(CC) -c *.c -I.
	$(CC) *.o -o $(PROGRAMA)

zip:
	zip -r sintatico_final.zip *

test1:
	./$(PROGRAMA) < teste.txt
