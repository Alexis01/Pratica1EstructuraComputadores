#Program entry
.global start
.extern Main
.extern Empty

.text
start:
	LDR sp, =0x0C7FF000
	MOV fp, #0
	LDR r0, =Main
	MOV lr, pc
	MOV pc, r0
	
End:
	B End
	
.global F00
F00:
	STR r4, [sp, #-4]!
	LDMIB r0, {r2, r3}	@ r2 = start, r3 = end
	CMP r2, r3
	LDREQ r4, [sp], #4
	MOVEQ pc, lr
	ADD ip, r0, #12	@ ip = Buffer (principio del array)
	ADD r4, r0, #524	@ r4 = Buffer + 256 (apunta a la siguiente posicion del final del array)
	
	LOOP:
		RSB r3, ip, r2	@ r3 = start - Buffer (posiciones sin ocupar al principio del array)
		MOV r3, r3, asr #1	@ r3 = (start - Buffer) / 2 (que es la posicion del elemento actual en el array)
		STRB r3, [r1]	@ Guarda el ultimo byte de r3 en screen.pos (solo necesita 8 bits para direccionar el array)
		LDRH r3, [r2], #2	@ r3 = *start y start += 1;
		STRH r3, [r1, #2]	@ Guarda a donde apuntaba start en screen.value
		CMP r2, r4	@ Comprueba si se ha pasado del array
		MOVCS r2, ip	@ start = Buffer si carry = 1
		ADD r1, r1, #4	@ Como screen es un array de 256 posiciones, actualiza el puntero al siguiente elemento
		LDR r3, [r0, #8]	@ r3 = end
		CMP r2, r3	@ Comprueba si start = end
		BNE LOOP
		
	LDR r4, [sp], #4
	MOV pc, lr
	
.global screen
screen: .space 1024, 0x0

.global Extract_asm
Extract_asm:
	@ Prologo
	MOV ip, sp
	STMDB sp!, {fp, ip, lr, pc}
	SUB fp, ip, #4
	SUB sp, sp, #8	@ Espacio para variables locales y parametros de llamada
	
	@ Llamada a Empty(CBuffer* B)
	STR r0, [sp]
	STR r1, [sp, #4] 
	LDR r2, =Empty
	MOV lr, pc
	MOV pc, r2
	
	@ if (Empty(B))
	CMP r0, #1
	MOVEQ r0, #-1	@ El valor de return
	BEQ Extract_asm_epil
	
	@ Restaurar r0 y r1
	LDR r0, [sp]
	LDR r1, [sp, #4]
	
	@ *elem = *(B->start);
	LDR r2, [r0, #4]	@ Guardo en r2 el puntero a start
	LDRH r3, [r2]	@ Guardo en r3 el contenido de start (short int)
	STRH r3, [r1]	@ Guardo el contenido de start a donde apunta elem
	
	@ B->start++;
	ADD r2, r2, #2	@ Sumo 2 al puntero a start (short int)
	STR r2, [r0, #4]	@ Guardo el puntero actualizado en su posicion
	
	@ if (B->start >= B->Buffer + N)
	ADD r3, r0, #12	@ Guardo en r3 el puntero a Buffer
	ADD r3, r3, #512	@ Sumo a B->Buffer 256 posiciones (256*2)
	CMP r2, r3	@ Comparacion entre B->start y B->Buffer + N
	ADD r3, r0, #12	@ Vuelvo a cargar el puntero a Buffer en r3
	STRGE r3, [r0, #4]	@ Guardo Buffer en la posicion de memoria de start
	
	@ B->count--;
	LDRH r2, [r0]	@ Cargo en r2 count
	SUB r2, r2, #1
	STRH r2, [r0]	@ Guardo count-- en su posicion
	MOV r0, #0	@ El valor de return
	
	Extract_asm_epil:
		@ Epilogo
		LDMDB fp, {fp, sp, pc}
.end