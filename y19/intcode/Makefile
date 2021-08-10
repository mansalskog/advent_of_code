cc=gcc -Wall -Wextra -std=c99 -pedantic -g

all: bin/ bin/d2 bin/d5 bin/d7 bin/d9 bin/d11 bin/d13 bin/d15

bin/:
	mkdir bin/

bin/%: %.c bin/intcode.o
	$(cc) $^ -o $@

bin/intcode.o: intcode.c intcode.h
	$(cc) -c $< -o $@

clean:
	rm -r bin/
