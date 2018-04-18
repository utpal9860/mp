;This program first check the mode of processor(Real or Protected),
;then reads GDTR, LDTR and IDTR and displays the same.

section .data
	welmsg db 'Welcome',10
	wmsg_len:equ $-welmsg
	gdtmsg db 10,'GDT Contents are::'
	gmsg_len:equ $-gdtmsg
	ldtmsg db 10,'LDT Contents are::'
	lmsg_len:equ $-ldtmsg
	idtmsg db 10,'IDT Contents are::'
	imsg_len:equ $-idtmsg
	nxline db 10
	colmsg db ':'
	rmodemsg db 10,'Processor is in Real Mode'
	rmsg_len:equ $-rmodemsg
	pmodemsg db 10,'Processor is in Protected Mode'
	pmsg_len:equ $-pmodemsg

section .bss
	gdt resd 1
	    resw 1
	ldt resw 1
	idt resd 1
	    resw 1
	dnum_buff resb 04
	cr0_data resd 1

%macro disp 2
	mov rax,01
	mov rdi,01
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .text
	global _start
_start:	
	disp welmsg,wmsg_len

	smsw eax		;Reading CR0

	mov [cr0_data],eax

	ror eax,1		;Checkin PE bit, if 1=Protected Mode, else Real Mode
	jc prmode
	disp rmodemsg,rmsg_len
	jmp nxt1

prmode:	disp pmodemsg,pmsg_len

nxt1:	sgdt [gdt]
	sldt [ldt]
	sidt [idt]

	disp gdtmsg,gmsg_len
	
	mov bx,[gdt+4]
	call disp_num

	mov bx,[gdt+2]
	call disp_num

	disp colmsg,1

	mov bx,[gdt]
	call disp_num

	disp ldtmsg,lmsg_len
	mov bx,[ldt]
	call disp_num

	disp idtmsg,imsg_len
	
	mov bx,[idt+4]
	call disp_num

	mov bx,[idt+2]
	call disp_num

	disp colmsg,1

	mov bx,[idt]
	call disp_num

	
exit:	mov rax,60
	mov rdi,00
	syscall

disp_num:
	mov esi,dnum_buff	;point esi to buffer

	mov ch,04		;load number of digits to display 
	mov cl,04		;load count of rotation in cl

up1:
	rol bx,cl		;rotate number left by four bits
	mov dl,bl		;move lower byte in dl
	and dl,0fh		;mask upper digit of byte in dl
	add dl,30h		;add 30h to calculate ASCII code
	cmp dl,39h		;compare with 39h
	jbe skip1		;if less than 39h akip adding 07 more 
	add dl,07h		;else add 07

skip1:
	mov [esi],dl		;store ASCII code in buffer
	inc esi			;point to next byte
	dec ch			;decrement the count of digits to display
	jnz up1			;if not zero jump to repeat

	mov rax,1		;display the number from buffer
	mov rdi,1
	mov rsi,dnum_buff
	mov rdx,4
	syscall
	
	ret
