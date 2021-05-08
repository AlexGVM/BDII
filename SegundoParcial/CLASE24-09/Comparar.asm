.MODEL small
.DATA 
cadena DB 'El resultado es: $'
cadena1 db 'Los numeros son iguales$'
cadena2 db 'El primero es mayor'
cadena3 db 'El segundo es mayor'
num1 DB ?
num2 DB ?

.code 
programa:
;iniciar programa
       MOV AX,@DATA  ; se obtiene la direcci'on de inicio del segmento de datos
        MOV DS, AX   ; asignamos al registro data segment la direccion de inicio de segmento
            ; leer digito 1
       leer:
            XOR AX, AX
            MOV ah, 01h
            INT 21h
            SUB al, 30h ; obtener el valor real
            MOV num1, al 
            XOR AX, AX
            MOV ah, 01h
            int 21h
            sub al, 30h
            mov num2, al
            ; imprimir valores por referencia
            XOR DX, DX
            XOR AX, AX
            mov ah,02h
            mov dl, num1
            ADD dl, 30h
            int 21h
              XOR DX, DX
            XOR AX, AX
            mov ah,02h
            mov dl, num2
            ADD Dl, 30h
            int 21h
      Iguales:
        Mov dx, offset cadena1 ; imprime si son iguales
        mov ah, 09h            ; imprimir cadena
        int 21h
        jmp finalizar
        
      Mayor:
      Mov dx, offset cadena2 ; imprime si son iguales
        mov ah, 09h            ; imprimir cadena
        int 21h
        jmp finalizar
      Menor:
      Mov dx, offset cadena3 ; imprime si son iguales
        mov ah, 09h            ; imprimir cadena
        int 21h
        jmp finalizar
      comparacion:
        mov al, num1
        cmp al, num2
        je iguales
        js menor
        jmp mayor
        
      finalizar:
      mov ah, 4ch
      int 21h
            
.STACK
END programa
            
    
  