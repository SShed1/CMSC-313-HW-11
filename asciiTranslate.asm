;Filename: asciiTranslate.asm
;Author: Sam Shedwick
;Date: 5/15/2025
;Description: Takes 8 different bytes and one by one translates the left 4 and right 4 bits in the byte into their ASCII code versions to be able to print it out. 
;It adds spaces in between each byte, and adds a new line at the end for formatting.
SECTION .data
inputBuf:
        db 0x83,0x6A,0x88,0xDE,0x9A,0xC3,0x54,0x9A ; The different bytes to be printed out
numOfBytes:
        db 0x8                  ; Number of bytes in the inputBuffer
space:
        db 0x20                 ; ASCII number for the space character

SECTION .bss
outputBuf:
        resb 80                 ; Container to hold the ASCII characters and be printed from

SECTION .text
global _start

_start:
        mov esi, 0              ; Counter for where in inputBuf the information will be taken from
        mov edi, 0              ; Counter for where in outputBuf the information will go
        mov ebx, numOfBytes     ; Moves the numOfBytes byte into the ebx register to be used
        and ebx, 0x0F           ; Gets the right byte of ebx to only use the 8 in the numOfBytes

byteTranslate:
        mov eax, [inputBuf + esi] ; Moves the current byte that it is looking at into eax
        and eax, 0xF0             ; Gets the left byte of eax
        shr eax, 4                ; Shifts the lone non-zero byte over to the right byte
        cmp eax, 0x9              ; Finds if byte in eax is a letter or number, number if 9 or less, letter greater than 9
        jle upperIsNumber         ; Goes to the ASCII number shifting
        jg upperIsLetter          ; Goes to the ASCII letter shifting

upperIsNumber:
        add eax, 0x30           ; Shifts the byte in eax to the ASCII code for the number
        jmp upperToOutput       ; Goes to the moving eax to outputBuf

upperIsLetter:
        add eax, 0x37           ; Shifts the byte in eax to the ASCII code for the letter
        jmp upperToOutput       ; Goes to the moving eax to outputBuf

upperToOutput:
        mov [outputBuf + edi], eax ; Puts the ASCII code in eax into the current open spot in outputBuf
        inc edi                    ; Increases the destination in outputBuf counter

        mov eax, [inputBuf + esi] ; Moves the current byte that it is looking at into eax
        and eax, 0x000F           ; Gets the right byte of eax
        cmp eax, 0x9              ; Finds if byte in eax is a letter or number, number if 9 or less, letter greater than 9
        jle lowerIsNumber         ; Goes to the ASCII number shifting
        jg lowerIsLetter          ; Goes to the ASCII letter shifting

lowerIsNumber:
        add eax, 0x30           ; Shifts the byte in eax to the ASCII code for the number
        jmp lowerToOutput       ; Goes to the moving eax to outputBuf

lowerIsLetter:
        add eax, 0x37           ; Shifts the byte in eax to the ASCII code for the letter
        jmp lowerToOutput       ; Goes to the moving eax to outputBuf

lowerToOutput:
        mov [outputBuf + edi], eax ; Puts the ASCII code in eax into the current open spot in outputBuf

checkForContinue:
        inc esi                 ; Increases the selection counter in inputBuf
        inc edi                 ; Increases the destination in outputBuf counter
        mov eax, [space]        ; Puts the space ASCII character into the eac register
        mov [outputBuf + edi], eax ; Puts the ASCII code in eax into the current open spot in outputBuf
        inc edi                    ; Increases the destination in outputBuf counter
        cmp esi, ebx               ; Compares the amount of bytes that have been moved over to the amount of bytes in inputBuf
        jl byteTranslate           ; If the amount of bytes that have been moved over is less than the total amount of bytes in inputBuf, it repeats the process with the next byte

        mov byte [outputBuf + edi], 0x0A ; Once all the bytes in inputBuf have been translated and moved into outputBuf, it adds a null terminator after all characters in outputBuf
        inc edi                          ; Increments the destination in outputBuf counter to after the null terminator
        mov byte [outputBuf + edi], 0x0A ; For formatting purposes, it puts a new line in after the null terminator in outputBuf
        mov ecx, outputBuf               ; Puts outputBuf into ecx for writing
        mov edx, edi                     ; Makes the amount of characters in outputBuf the amount of bytes that the system will write out

        mov ebx, 1              ; Initiates the STDOUT file
        mov eax, 4              ; Initiates SYS_WRITE
        int 80h

        mov ebx, 0              ; Sets return status to 0 for no errors
        mov eax, 1              ; invokes SYS_EXIT
        int 80h
