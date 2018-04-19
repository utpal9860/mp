
extern	far_proc		;  FAR PROCRDURE 
					;   USING EXTERN DIRECTIVE 

global	filehandle, char, buf, abuf_len

%include	"macro.asm"



section .data
	nline		db	10
	nline_len	equ	$-nline

	

	filemsg	db	10,"Enter filename : "
	filemsg_len	equ	$-filemsg	
  
	charmsg	db	10,"Enter character to be searched : "
	charmsg_len	equ	$-charmsg

	errmsg	db	10,10,"ERROR while opening File!!!!!",10,10
	errmsg_len	equ	$-errmsg

	exitmsg	db	10,10,"Exiting from program!!!",10,10
	exitmsg_len	equ	$-exitmsg

;---------------------------------------------------------------------------
section .bss
	buf			resb	4096
	buf_len		equ	$-buf		; buffer initial length

	filename		resb	50	
	char			resb	2	
 
	filehandle		resq	1
	abuf_len		resq	1		; actual buffer length



section .text
	global _start
		
_start:
		

		print	filemsg,filemsg_len		
		read 	filename,50
		dec	rax
		mov	byte[filename + rax],0		; blank char/null char

		print	charmsg,charmsg_len		
		read 	char,2
		
		fopen	filename			; if opened returns handle
		cmp	rax,-1H			; if not found returns -1
		jle	Error
		mov	[filehandle],rax	

		fread	[filehandle],buf, buf_len
		mov	[abuf_len],rax

		call	far_proc
		jmp	Exit

Error:	print	errmsg, errmsg_len

Exit:		print	exitmsg,exitmsg_len
		exit


