FLEX=flex
BISON=bison
CC=g++

PROGRAM = c-like-parser
LEX = lex.l
PARSER = parser.y

$(PROGRAM): $(LEX) $(PARSER)
	$(BISON) -d -r all -v -k $(PARSER)
	$(FLEX) $(LEX)
	$(CC) -c *.c -I. -w
	$(CC) *.o -o $(PROGRAM)

clean:
	rm -f *.yy.c
	rm -f *.tab.c
	rm -f *.tab.h
	rm -f *.o
	rm -f *.output
	rm -f *.gch
	rm -f $(PROGRAM)
	rm -f *.*~
	rm -f c-alike-parser.zip

zip:
		zip -r -9 c-alike-parser.zip lex.l Makefile node.c node.h parser.y test-case.cag

test:
	./$(PROGRAM) < test-case.cag


