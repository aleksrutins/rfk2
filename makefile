.PHONY: rfk2
all: rfk2
main.o: *.asm
	nasm -felf64 main.asm -o $@

rfk2: main.o
	ld $< -o $@