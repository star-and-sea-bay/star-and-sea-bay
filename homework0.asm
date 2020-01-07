;**********************
;*     采样控制直流电机调速      *
;**********************
DATA SEGMENT
PORT1   EQU     290H   ;0832控制
PORT2   EQU     28BH   ;8255控制口
PORT3   EQU     28AH
io0809a equ 298h;0809A口
IO8255A EQU 288H
BUF1    DW      0
BUF2    DW      0
BUF3    DW      0
DATA ENDS
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
        MOV    AX,DATA
        MOV    DS,AX
        MOV     DX,PORT2
        MOV     AL,89H  ;设置为A口输出，C口输入
        OUT     DX,AL            ;8255 PORT C INPUT
START1: MOV DX,io0809a ;启动A/D转化器
        OUT DX,AL
        MOV CX,0FFH;延时
DELAY:  LOOP DELAY
LL:     IN AL,DX ;读取数据 
        PUSH AL;保护AL中的数据
LLL:    MOV   AL,80H
        MOV     DX,PORT1;设置0832
        OUT     DX,AL             ;D/A OUTPUT 0V
        push    dx
        MOV     AH,06h
        mov     dl,0ffh
        INT     21H
        pop     dx
        JE      INTK              ;NOT ANY KEY JMP INTK
        MOV     AH,4CH
        INT     21H               ;EXIT TO DOS

INTK:   POP     AL             ;READ SWITCH
        CMP    AL,1FH
        JB     K0
        CMP    AL,2FH
        JB     K1
        CMP    AL,3FH
        JB     K2
        CMP    AL,4FH
        JB     K3
        CMP    AL,8FH
        JB     K4
        CMP    AL,0AFH
        JB     K5
        JMP     START1

K0:     MOV     BUF1,0400H
        MOV     BUF2,0330H
        MOV     BUF3,0001H
DELAY:   MOV     CX,BUF1
DELAY1:  LOOP    DELAY1
        MOV     AL,0FFH
        MOV     DX,PORT1
        OUT     DX,AL
        MOV     CX,BUF2
DELAY2:  LOOP    DELAY2
        MOV DX,IO8255A
        MOV AL,BUF3
        OUT DX,AL
        JMP     START1
K1:     MOV     BUF1,0400H
        MOV     BUF2,0400H
        MOV     BUF3,0003H
        JMP     DELAY
K2:     MOV     BUF1,0400H
        MOV     BUF2,0500H
        MOV     BUF3,0007H
        JMP     DELAY
K3:    MOV     BUF1,0400H
        MOV     BUF2,0600H
        MOV     BUF3,000FH
        JMP     DELAY
K4:     MOV     BUF1,0400H
        MOV     BUF2,0700H
        MOV     BUF3,001FH
        JMP     DELAY
K5:     MOV     BUF1,0400H
        MOV     BUF2,0800H
        MOV     BUF3,003FH
        JMP     DELAY
CODE ENDS
END START
