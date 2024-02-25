bin/main: bin/main.o bin/int2str.o bin/mcds.o bin/
	ld -o bin/main bin/main.o bin/int2str.o bin/mcds.o

bin/main.o: src/main.asm bin/
	nasm -f elf64 -o bin/main.o src/main.asm

bin/int2str.o: src/int2str.asm bin/
	nasm -f elf64 -o bin/int2str.o src/int2str.asm

bin/mcds.o: src/mcds.asm bin/
	nasm -f elf64 -o bin/mcds.o src/mcds.asm

bin/:
	mkdir bin

