cc=gcc -Wall -Wextra -std=c99 -pedantic

all: bin/ bin/d2 bin/d5 bin/d7

bin/:
	mkdir bin/

bin/%: %.c bin/intcode.o
	$(cc) $^ -o $@

bin/intcode.o: intcode.c intcode.h
	$(cc) -c $< -o $@
