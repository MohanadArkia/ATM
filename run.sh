#/bin/bash
nasm -f elf32 -o main.o Main.asm && ld -m elf_i386 -o main main.o && ./main
