# Lab Projects Ideas

- Each team should choose one idea from the listed ideas.


- A team is formed by 2, 3, or 4 members.
- After choosing your idea, send to me an email with the **team members**, **team name**, and **the idea** and wait for a **confirmation** from me.
- Projects ideas should be balanced over all the teams. I might force a team to an idea if there aren't enough teams in it.
- Each project contains a **bonus** task.
- **Copying** code from each others is **forbidden**.


## Announcements

- No more traffic light's project can be registered.


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
    Lcd_init:	call busy      	    ;Check if KIT is busy
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
    		ret
    ```

- Print string on screen procedure:

  - ```assembly
    ;-----------------------------------------------------  
    ;print_string PROC
    ;Prints a null terminated string on the kit LCD screen
    ;Precondations: the string should be terminated by 0
    ;Inputs:   si   the offset of the string
    ;Outputs:  None
    ;-----------------------------------------------------	
    print_string:   push al
                    push si
                    start:  mov al,[si]
                            cmp al,00
                            je L1
                            out data,al
                            call busy
                            inc si
                            jmp start
                    pop si
                    pop al
    ```

    ​

## Registered ideas and teams:

| Project title                           | Teams registered                         | Count |
| --------------------------------------- | ---------------------------------------- | ----- |
| **Matrix addition and multiplications** | Matrix<br />New-Folder<br />sabdo1230<br />ar1682<br />omaressam3332 | **5** |
| **Sorting algorithms package**          | mohamed.ali.farag.171997<br />ayamohamed21337<br />sabdo1230<br />bishosaed1<br />assembly2017 | **5** |
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
|             | Ahmed Khaled           |

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

| Team        | sabdo1230                                |
| ----------- | ---------------------------------------- |
| **Problem** | Sorting algorithms package & Matrix addition and multiplications |
| **Members** | Ahmed el sayed mokhtar                   |
|             | Abdelrahman saber                        |
|             | Hani nady                                |
|             | Ibrahim anany                            |
|             | Hussein badran                           |

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
|             |                                     |

