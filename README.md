# number-system-converter
My final assignment for my Computer Organization and Assembly Language course during my 5th semester at the Autonomous University of Baja California (September - December, 2020). A numeral system converter that allows you to input a decimal, binary or octal number and converts it to decimal, binary, octal and hexadecimal. Written in x86 NASM Assembly in Ubuntu.

The file that I wrote and that has to be assembled is ***conversiones3.asm***. Requires the ***asm_io.inc*** file (which was provided to me by my professor).  
Assemble the file with `nasm -f elf conversiones3.asm`.

Then create the executable file with `gcc -o conversiones3 conversiones3.o asm_io.o driver.c`. This requires the files ***asm_io.o***, ***driver.c*** and ***cdecl.h*** (all of which were provided to me by my professor).

Finally, execute the program with `./conversiones3`.

To input a binary number after selecting the binary option, introduce one digit at a time, starting from the least significant digit to the most significant, like you're writing a binary number starting from the rightmost digit; type a digit between 0 and 1, then press enter, then enter the next digit, and so on. To stop inputing digits, input any number that isn't 0 or 1. For example:  
1  
0  
0  
1  
1  
0  
1  
This input is equivalent to 1011001.

Inputing an octal number after selecting the octal option works exactly the same as inputing a binary number: introduce one digit between 0 and 7 at a time, starting from the least significant digit to the most significant. To stop inputing digits, input any number that isn't between 0 and 7. For example:  
4  
5  
2  
6  
This input is equivalent to 6254.
