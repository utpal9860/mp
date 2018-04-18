section .data
	MsgGdt db "GDT Register:",10
	MsgGdtLen equ $-MsgGdt
	MsgIdt db "IDT Register:",10
	MsgIdtLen equ $-MsgIdt
	MsgLdt db "LDT Register:",10
	MsgLdtLen equ $-MsgLdt
	MsgTdt db "Task Register:",10
	MsgTdtLen equ $-MsgTdt
	MsgMdt db "Machine Status Word Register:",10
	MsgMdtLen equ $-MsgMdt
	
	newl db " ",10
	newlLen equ $-newl
	%macro operate 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
	%endmacro

section .bss

	gdtr resb 8
	gdtLimit resb 4
	ldtr resb 4
	idtr resb 16
	idtLimit resb 4
	tr resb 4
	smsw1 resb 4
	
	temp resb 1
	result64 resb 16
	result16 resb 4

section .text
	global _start:
	_start:
	
	;DISPLAYING CONTENTS OF GDTR
	operate 1,1,newl,newlLen
	operate 1,1,MsgGdt,MsgGdtLen
	mov esi,gdtr
	sgdt [esi]
	mov rax,qword[esi]
	call Display64

	operate 1,1,newl,newlLen
	mov esi,gdtLimit
	mov ax,word[esi]
	call Display16

	operate 1,1,newl,newlLen
	operate 1,1,MsgIdt,MsgIdtLen
	mov esi,idtr
	sidt [esi]
	mov rax,qword[esi]
	call Display64

	operate 1,1,newl,newlLen
	mov esi,idtLimit
	mov ax,word[esi]
	call Display16

	operate 1,1,newl,newlLen
	operate 1,1,MsgLdt,MsgLdtLen
	mov esi,ldtr
	mov ax,word[esi]
	call Display16

	operate 1,1,newl,newlLen
	operate 1,1,MsgTdt,MsgTdtLen
	mov esi,tr
	mov ax,word[esi]
	call Display16
	
	operate 1,1,newl,newlLen
	operate 1,1,MsgMdt,MsgMdtLen
	mov esi,smsw1
	smsw [esi]
	mov ax,word[esi]
	call Display16

	operate 60,0,0,0

Display64:
		mov bp,16
	DispUp:
		rol rax,4
		mov qword[result64],rax
		and al,0FH
		cmp al,09H
		jbe DispDown
		add al,07H
	DispDown:
		add al,30H
		mov byte[temp],al
		operate 1,1,temp,1
		mov rax,qword[result64]
		dec bp
		jnz DispUp

		ret

Display16:
		mov bp,4
	Disp16Up:
		rol ax,4
		mov word[result16],ax
		and al,0FH
		cmp al,09H
		jbe Disp16Down
		add al,07H
	Disp16Down:
		add al,30H
		mov byte[temp],al
		operate 1,1,temp,1
		mov ax,word[result16]
		dec bp
		jnz Disp16Up

		ret

