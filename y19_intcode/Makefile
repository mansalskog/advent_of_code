cc=gcc -Wall -Wextra -std=c99 -pedantic

all: d2 d5

%: %.c intcode.o
	$(cc) $^ -o $@

intcode.o: intcode.c intcode.h
	$(cc) -c $< -o $@
