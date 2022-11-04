// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed.
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

(LOOP)
    // D = KBD (if D == 0 then no key is pressed)
    @KBD
    D=M
    // if D != 0 goto DRAWBLACK
    @DRAWBLACK
    D;JNE
    // if D == 0 goto DRAWWHITE
    @DRAWWHITE
    0;JMP

(DRAWBLACK)
// We will set [SCREEN, SCREEN + 8192 - 1] -1
    // D = 8192
    @8192
    D=A
(DRAWBLACKLOOP)
    // if key is released, goto DRAWWHITE
    // I dont know if it's safe to use R0 here
    @R0
    M=D
    @KBD
    D=M
    @DRAWWHITE
    D;JEQ
    @R0
    D=M
    // D = D - 1
    D=D-1
    // RAM[SCREEN + D] = -1
    @SCREEN
    A=A+D
    M=-1
    // if D > 0 goto DRAWBLACKLOOP
    @DRAWBLACKLOOP
    D;JGE
    // if D == 0 goto LOOP
    @LOOP
    0;JMP

(DRAWWHITE)
// We will set [SCREEN, SCREEN + 8192 - 1] 0
    // D = 8192
    @8192
    D=A
(DRAWWHITELOOP)
    // if key is pressed, goto DRAWBLACK
    @R0
    M=D
    @KBD
    D=M
    @DRAWBLACK
    D;JNE
    @R0
    D=M
    // D = D - 1
    D=D-1
    // RAM[SCREEN + D] = 0
    @SCREEN
    A=A+D
    M=0
    // if D > 0 goto DRAWWHITELOOP
    @DRAWWHITELOOP
    D;JGE
    // if D == 0 goto LOOP
    @LOOP
    0;JMP
