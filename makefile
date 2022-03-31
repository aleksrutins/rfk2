.PHONY: rfk2
%.o: %.asm
	nasm -felf64 $< -o $@

rfk2: main.o
	ld $< -o $@