.global start
.extern Main
.text
start:
	ldr sp,=0x0c7ff000
	mov fp,#0
	ldr r0,=Main
	mov lr,pc
	mov pc,r0
end:
	b end
.global FOO
FOO:
	str r4,[sp,#-4]!
	ldmib r0,{r2,r3} @ r6+4->r2 , r6+8->r3
	cmp r2,r3
	ldreq r4,[sp],#4
	moveq pc,lr
	add ip,r0,#12
	add r4,r0,#524
LOOP:
	rsb r3,ip,r2   @lo que hace es r2-ip=>r3
	mov r3,r3,asr #1 @Specifies an arithmetic shift right 
	strb r3,[r1]   @STRB R1, [R5, #31] ; Store byte from R3 to address R1
	ldrh r3,[r2], #2	 @LDRH R3, [R6, R5] ; Load word into R3 from R6 + R5
	strh r3,[r1,#2]  @STRH R4, [R2, R3] ; Store halfword from R4 to R2 + R3
	cmp r2,r4  
	movcs r2,ip @ the instruction moves ip to r2 only if carry is set.
	add r1,r1,#4 @suma a r1+4
	ldr r3,[r0,#8] @carga en r3 r0+8
	cmp r2,r3 @ r2 comp r3
	bne LOOP @if not equals loop
	ldr r4,[sp],#4 @carga en r4 sp+4
	mov pc,lr @mueve lr a pc
.global screen
screen: .space 1024, 0x0
.end
