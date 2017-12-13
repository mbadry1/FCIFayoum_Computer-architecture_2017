# Lab Projects Ideas

- Each team should choose one idea from the listed ideas.


- A team is formed by 2, 3, or 4 members.
- After choosing your idea, send to me an email with the **team members**, **team name**, and **the idea** and wait for a **confirmation** from me.
- Projects ideas should be balanced over all the teams. I might force a team to an idea if there aren't enough teams in it.
- Each project contains a **bonus** task.
- **Copying** code from each others is **forbidden**.


## Announcements

- No more traffic light's project can be registered.
- All Teams has been registered.
- `Template.asm` file has been added.


## Useful codes for the project

- First and last lines on any kit code:

  - ```assembly
    CODE	SEGMENT
    ASSUME	CS:CODE,DS:CODE,ES:CODE,SS:CODE	
    command	equ	00h
    stat	equ 02h
    data	equ	04h
    key		equ	01h
    org 1000h

    ; Put your code here...

    CODE	ENDS
    END
    ```

- Scan procedure:

  - ```assembly
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
    ```

- Busy procedure:

  - ```assembly
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
    ```

- LCD screen initialization procedure:

  - ```assembly
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
    ```

- Clear screen

  - ```assembly
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
    ```

    ​

- Print string on screen procedure:

  - ```assembly
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
    ```

- Integer to string

  - ```assembly
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
            

    ```

- String to integer:

  - ```assembly
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
    ```

- Power

  - ```assembly
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
    ```

    ​

## Registered ideas and teams:

| Project title                           | Teams registered                         | Count |
| --------------------------------------- | ---------------------------------------- | ----- |
| **Matrix addition and multiplications** | Matrix<br />New-Folder<br />ar1682<br />omaressam3332<br />moazelmassery<br />ahmedbadia96<br /> hanynady553 | **7** |
| **Sorting algorithms package**          | mohamed.ali.farag.171997<br />ayamohamed21337<br />sabdo1230<br />bishosaed1<br />assembly2017<br /> Nehadahmed2210<br />ahmedbadia961 | **7** |
| **Shape detector**                      | ij1129                                   | **1** |
| **Traffic Light**                       | nalohosam555 <br />ayamohamed21337<br />4S<br />kn1128<br />moatazalazamy<br />sm2073<br />carolmicheal784 | **7** |
| **XO game**                             | abdalrhim122mostafa                      | **1** |



## Teams

| Team        | Matrix                              |
| ----------- | ----------------------------------- |
| **Problem** | Matrix addition and multiplications |
| **Members** | Ahmed Sayed Anwar                   |
|             | Ahmed Emad Hamdy Beledy             |
|             | Mahmoud Mohamed Abdelaziz           |
|             | Ezzat                               |

| Team        | mohamed.ali.farag.171997   |
| ----------- | -------------------------- |
| **Problem** | Sorting algorithms package |
| **Members** | Mohamed Ali Farag          |
|             | Hussien Ragab Mohamed      |
|             | Ismail Ramadan Ismail      |
|             | Hossam Hassan Zaki         |

| Team        | nalohosam555                    |
| ----------- | ------------------------------- |
| **Problem** | Traffic Light                   |
| **Members** | Nilly Hosam                     |
|             | AbdElrahman mohamed nour Eldeen |
|             | Mostafa Mohamed Mohamed         |
|             | Hadeer kamel                    |

| Team        | ayamohamed21337                          |
| ----------- | ---------------------------------------- |
| **Problem** | Sorting algorithms package & Traffic light |
| **Members** | Amal Atef                                |
|             | Hend Mohamed                             |
|             | Aya Mohamed                              |
|             | Yasmein Ahmed                            |
|             | Yara Hesham                              |

| Team        | 4S             |
| ----------- | -------------- |
| **Problem** | Traffic lights |
| **Members** | Salma Sa'ed    |
|             | Somaya sayed   |
|             | Sara Gomaa     |
|             | Samar Mohammed |

| Team        | kn1128             |
| ----------- | ------------------ |
| **Problem** | Traffic lights     |
| **Members** | Mohamed ahmed sofy |
|             | Ammar Sayed Taha   |
|             | Khaled nour        |
|             |                    |

| Team        | moatazalazamy              |
| ----------- | -------------------------- |
| **Problem** | Traffic lights             |
| **Members** | Moataz mohamed azamy       |
|             | Hesham abdelgawad mohammed |
|             | Adel ahmed hashem          |
|             | Mena mamdoh                |

| Team        | abdalrhim122mostafa    |
| ----------- | ---------------------- |
| **Problem** | XO game                |
| **Members** | Abdelrehim Mostafa     |
|             | Mohammed saber         |
|             | Ahmed Hussein Hassanin |
|             | ~~Ahmed Khaled~~       |

| Team        | sm2073                   |
| ----------- | ------------------------ |
| **Problem** | Traffic lights           |
| **Members** | Samah Mohammed abdelhady |
|             | Ahmed Deef               |
|             | Mohammed Adel            |
|             | Ahmed Mohammed Nomman    |

| Team        | carolmicheal784 |
| ----------- | --------------- |
| **Problem** | Traffic lights  |
| **Members** | Dolagy Fawzy    |
|             | Carol Mesheal   |
|             | Marina Nady     |
|             | Marina Ayman    |

| Team        | New-Folder                          |
| ----------- | ----------------------------------- |
| **Problem** | Matrix addition and multiplications |
| **Members** | Ameen Ahmed                         |
|             | Mohamed Mahmoud Saleh               |
|             | Mohamed Ramadan                     |
|             |                                     |

| Team        | sabdo1230                  |
| ----------- | -------------------------- |
| **Problem** | Sorting algorithms package |
| **Members** | Ahmed el sayed mokhtar     |
|             | Abdelrahman saber          |
|             | Ibrahim anany              |
|             | Hussein badran             |
|             |                            |

| Team        | bishosaed1                 |
| ----------- | -------------------------- |
| **Problem** | Sorting algorithms package |
| **Members** | Beshoy Adel                |
|             | Samer Samy                 |
|             | Ibram Idward               |
|             | Beshoy saeed               |

| Team        | assembly2017               |
| ----------- | -------------------------- |
| **Problem** | Sorting algorithms package |
| **Members** | Abdelmenem Abdelaal        |
|             | Mohamed Ewaes              |
|             | Fatma Mabrouk              |
|             | Mustafa Ryad               |

| Team        | ar1682                              |
| ----------- | ----------------------------------- |
| **Problem** | Matrix addition and multiplications |
| **Members** | Mostafa Mahmoud Abbas               |
|             | Fayed Goda                          |
|             | Ahmed Ramadan                       |
|             | Raouf Mohamed                       |

| Team        | ij1129                          |
| ----------- | ------------------------------- |
| **Problem** | Shape detector                  |
| **Members** | Ibrahim Gamal elsoufy           |
|             | Ahmed Sarhan Ahmed              |
|             | Abdelrahman Mohammed Abdelsalam |
|             | Mohammed Saber Abdelhameed      |

| Team        | omaressam3332                       |
| ----------- | ----------------------------------- |
| **Problem** | Matrix addition and multiplications |
| **Members** | Omar Essam Omar Qasem               |
|             | Mohamed Adel Abdeltawab             |
|             | Ezz eldein Hamdy Hosny              |
|             | Abdelrahman Atef Mostafa            |

| Team        | moazelmassery                       |
| ----------- | ----------------------------------- |
| **Problem** | Matrix addition and multiplications |
| **Members** | Moaaz Abd elnasser Abd elazzez      |
|             | Mohammed Taha Taha                  |
|             | Kerolos Ibram                       |
|             | Mohamed Ahmed Abdelwahed            |

| Team        | Nehadahmed2210             |
| ----------- | -------------------------- |
| **Problem** | Sorting algorithms package |
| **Members** | Nehad ahmed                |
|             | Doaa Mohamed               |
|             |                            |
|             |                            |

| Team        | ahmedbadia96                        |
| ----------- | ----------------------------------- |
| **Problem** | Matrix addition and multiplications |
| **Members** | Ahmed mohamed mahmoud               |
|             | Hossam abdallah ebrahim             |
|             | Mohamed ahmed moustafa              |
|             |                                     |

| Team        | ahmedbadia961              |
| ----------- | -------------------------- |
| **Problem** | Sorting algorithms package |
| **Members** | moutaz mohamed gaber       |
|             | youssof ahmed said         |
|             | abdelrahman aswa ahmed     |
|             |                            |

| Team        | hanynady553                         |
| ----------- | ----------------------------------- |
| **Problem** | Matrix addition and multiplications |
| **Members** | Hani nady                           |
|             | Mahmoud Hamouda                     |
|             |                                     |
|             |                                     |

