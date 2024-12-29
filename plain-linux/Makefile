all: morse nop

morse: morse.cpp Makefile
	g++ -Wall -Wextra -std=c++17 -o build/$@ $<

nop: nop.c Makefile
	g++ -Wall -Wextra -std=c++17 -o build/$@ $<

clean:
	rm -f build/morse

.PHONY: all clean
