.PHONY: rfk2
all: rfk2
%.o: %.asm
	nasm -felf64 $< -o $@

rfk2: main.o lib.o nki.o
	ld *.o -o $@