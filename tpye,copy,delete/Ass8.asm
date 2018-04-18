%include "macro.asm"

section .data
        nline 		db	10,10
	nline_len	equ	$-nline

	ano		db	10,"	Assignment no	:8",
			db	10,"------------------------------------------------------------",
			db      10,"	Assignment Name:Perform Type,Copy,Delete using file operation by command line arguments.",
			db      10,"----------------------------------------------------------",10
	ano_len		equ	$-ano

	menu		db	10,"1.Type",
			db	10,"2.Copy",
			db	10,"3.Delete",
			db	10,"4.Exit",
			db	10,"Enter Your Choice::"
	menu_len	equ	$-menu

	filemsg		db	10,"Enter filename::"
	filemsg_len	equ	$-filemsg

	file2msg		db	10,"Enter second file to copy data:"
	file2msg_len	equ	$-file2msg

	cmsg		db	10,"file copied succesfully"
	cmsg_len	equ	$-cmsg

	dmsg		db	10,"file deleted successfully"
	dmsg_len	equ	$-dmsg

	emsg		db	10,"Error in opening/reading file",10
	emsg_len	equ	$-emsg
	
	

section .bss
	buf			resb	4096
	buf_len		equ	$-buf		; buffer initial length

	filename		resb	50	
	file2name		resb	50	
	
 
	filehandle		resq	1
	filehandle2		resq	1
	abuf_len		resq	1		; actual buffer length




section .text
global _start
_start:
    	print	ano,ano_len
    	
   
MENU:	print	menu,menu_len
	read	buf,2		;accept choice i.e 1 digit+enter

	mov	al,[buf]	;contains only digit character

c1:	cmp	al,'1'
	jne	c2
	call	Type_pro
	jmp	MENU

c2:	cmp	al,'2'
	jne	c3
	call	Copy_pro
	jmp	MENU

c3:	cmp	al,'3'
	jne	c4
	call 	Delete_pro
	jmp MENU
	
c4:     cmp 	al,'4'
	jne invalid
	exit

invalid:
	print	emsg,emsg_len
	jmp	MENU
	


Type_pro:
		print	filemsg,filemsg_len		
		read 	filename,50
		dec	rax
		mov	byte[filename + rax],0		; blank char/null char

	
		
		fopen	filename			; on succes returns handle
		cmp	rax,-1H			; on failure returns -1
		jle	invalid
		mov	[filehandle],rax	

		
		read	buf, buf_len
		fwrite [filehandle],buf,buf_len
		
	        print   buf,buf_len
		
		fclose [filehandle]
ret

Copy_pro:

		print	filemsg,filemsg_len		
		read 	filename,50
		dec	rax
		mov	byte[filename + rax],0		; blank char/null char

	
		
		fopen	filename			; on succes returns handle
		cmp	rax,-1H			; on failure returns -1
		jle	invalid
		mov	[filehandle],rax	

		fread	[filehandle],buf,buf_len
		mov	[abuf_len],rax
		
		print	file2msg,file2msg_len		
		read 	file2name,50
		dec	rax
		mov	byte[file2name + rax],0		; blank char/null char

	
		
		fopen	file2name			; on succes returns handle
		cmp	rax,-1H			; on failure returns -1
		jle	invalid
		mov	[filehandle2],rax	

		fwrite	[filehandle2],buf,buf_len
		print	buf,buf_len
		fclose [filehandle]
		fclose [filehandle2]
		print cmsg,cmsg_len

ret

Delete_pro:
		print	filemsg,filemsg_len		
		read 	filename,50
		dec	rax
		mov	byte[filename + rax],0		; blank char/null char

		fdelete filename
		print dmsg,dmsg_len
ret
