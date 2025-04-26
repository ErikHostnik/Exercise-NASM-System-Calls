all: build run

build:
	nasm -f elf32 main.s -o main.o
	ld -m elf_i386 main.o -o sys_calls

run:
	./sys_calls

clean:
	rm -f main.o sys_calls
