CODE	SEGMENT
ASSUME	CS:CODE,DS:CODE,ES:CODE,SS:CODE	
command	equ	00h
stat	equ 02h
data	equ	04h
key		equ	01h
org 1000h


hlt
;-----------Vars--------------
ten = 10    ;Required by a function
signFlag db 0 ;Required by a function
;-----------------------------

;-----------------------------------------------------  
;Scan PROC
;Scans a kit button from the user into al
;Inputs:   None
;Outputs:  Al - scanned char code
;-----------------------------------------------------	
scan:   IN AL,key					;read from keypad register
        TEST AL,10000000b			;test status flag of keypad register
        JNZ Scan
        AND al,00011111b			;mask the valid bits for code
        OUT key,AL					;get the keypad ready to read another key
        ret
        
;-----------------------------------------------------  
;Busy PROC
;Makes the CPU wait till the kit is ready to take a command
;Inputs:   None
;Outputs:  None
;-----------------------------------------------------		
busy:   IN AL,Stat
        test AL,10000000b
        jnz busy
        ret
        
;-----------------------------------------------------  
;Lcd_init PROC
;LCD screen initialization which makes the screen ready as a one line input with a ;cursor. You can call this method again if you want to clear the LCD screen
;Inputs:   None
;Outputs:  None
;-----------------------------------------------------	
Lcd_init:	
        push ax
        call busy      	    ;Check if KIT is busy
		mov al,30h          ;8-bits mode, one line & 5x7 dots
		out command,al      ;Execute the command above.
		call busy           ;Check if KIT is busy
		mov al,0fh          ;Turn the display and cursor ON, and set cursor to blink
		out command,al      ;Execute the command above.
		call busy           ;Check if KIT is busy
		mov al,06h          ;cursor is to be moved to right
		out command,al      ;Execute the command above.
		call busy           ;Check if KIT is busy
		mov al,02           ;Return cursor to home
		out command,al      ;Execute the command above.
		call busy           ;Check if KIT is busy
		mov al,01           ;Clear the display
		out command,al      ;Execute the command above.
		call busy           ;Check if KIT is busy
		pop ax
		ret
		
;-----------------------------------------------------  
;clear_screen PROC
;Clears the LCD screen. Use it instead of Lcd_init if you are trying to clear the screen.
;Inputs:   None
;Outputs:  None
;-----------------------------------------------------
clear_screen:
              push ax
              call busy           ;Check if KIT is busy
              mov al,01           ;Clear the display
              out command,al      ;Execute the command above.
              call busy           ;Check if KIT is busy
              pop ax
              
;-----------------------------------------------------  
;print_string PROC
;Prints a null terminated string on the kit LCD screen
;Precondations: the string should be terminated by 0
;Inputs:   si   the offset of the string
;Outputs:  None
;-----------------------------------------------------	
print_string:   push ax
                push si
                start:  mov al,[si]
                        cmp al,00
                        je L1
                        out data,al
                        call busy
                        inc si
                        jmp start
                L1:
                pop si
                pop ax
                ret
                
;-----------------------------------------------------  
;integer_to_string PROC
;Converts an integer to string. Works with signed and unsigned numbers.
;Precondations: A buffer for the returned string
;Inputs:   Ax is the integer, si points to the first element in the buffer
;Outputs:  The string in si
;-----------------------------------------------------
integer_to_string:
   
   ;Clearing the buffer
   push cx
   mov cx, 0
   push si
   Li3:
       mov bl, [si]
       cmp bl,0
       je Li4
       mov bl, 0
       mov [si],bl
       inc si
       JMP Li3
       
   Li4: pop si
   push si
   push ax
   mov cx, 0
   
   ;Checking the sign
   cmp Ax, 0
   jge Li1
   mov [si], '-'
   add si, 1
   neg Ax
   
   Li1: mov dx, 0 
       mov bx, 10
       div bx
       add dl, '0'
       push dx
       inc cx
       cmp ax, 0
       jne Li1
   
       
   Li2:        
       pop dx
       mov [si], dl
       inc si
       Loop Li2
   pop ax
   pop si
   pop cx 
   ret
   
;-----------------------------------------------------  
;string_to_int PROC
;Converts a string into integer
;It works with sign and unsigned numbers
;Precondations: string is terminated by 0
;Inputs:   si: offset of string
;Outputs:  dx: output integer
;-----------------------------------------------------
string_to_int:
    push bx
    push ax
    push cx
    push si
    push di
    
    mov di, 0   ;result
    mov bx, 1   ;Represent 1, 10, 100, etc
    mov signFlag, 0       ;Is positive
    mov cx, 0        
            
    ;First loop to decide the number of chars
    sti_L1:  mov al, [si]
             
             cmp al, 0
             je sti_L2
             
             inc cx
             add si, 1
             
             JMP sti_L1
    
    sti_L2:  sub si, 1
             
             mov al, [si]
             mov ah, 0h
             
             cmp al,'-'       ; If a minus
             jne sti_number
             mov signFlag, 1   ;Is negative
             JMP sti_L3 ;Complete the loop
             
             sti_number: sub al, '0'
             mul bx  ; result = ax * bx
             add di, ax  ; Aggregation
                        
             mov al, ten
             mov ah, 0
             mul bx
             mov bx, ax   ;bx*= 10
             
             sti_L3:
             loop sti_L2
    
    mov dx, di
    
    ; Handeling the sign
    cmp signFlag, 1
    jne sti_exit
    neg dx
    
    sti_exit:
    pop di
    pop si
    pop cx
    pop ax
    pop bx
    ret
    
;-----------------------------------------------------  
;power PROC
;calculates power of a number given a power
;Inputs:   ax: number, bx: power
;Outputs:  dx: output
;-----------------------------------------------------
power:
    cmp bx, 00h
    jne pw_L2
    mov dx, 01h
    ret
    
    pw_L2:  push cx
            push ax
            push bx 
        
            mov cx, bx
            dec cx
            mov bx, ax
            pw_L1:  mul bx
                    Loop pw_L1
            mov dx, ax 
        
            pop bx
            pop ax
            pop cx
    ret                              

CODE	ENDS
END