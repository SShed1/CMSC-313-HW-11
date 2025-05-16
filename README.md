# CMSC-313-HW-11

To assemble the code, download the code and use the line in a linux or gl server:
nasm -f elf32 -g -F dwarf -o driver.o asciiTranslate.asm

To link the code, use the line in a linux or gl server:
ld -m elf_i386 -o driver driver.o

