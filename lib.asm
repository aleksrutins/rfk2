puts:	mov	rax, 1
	mov	rdi, 1
	syscall
	ret

gets:	mov	rax, 0
	xor	rdi, rdi
	syscall
	ret

exit:	mov	rax, 60
	xor	rdi, rdi
	syscall
	ret

prompt:	push	rsi
	push	rdx
	mov	rsi, .sprompt
	mov	edx, [.lprompt]
	call	puts
	pop	rdx
	pop	rsi
	call	gets
	ret
.sprompt:	db	'] '
.lprompt:	dd	$-.sprompt

cmdparse:	mov	rbx, cmdbuf	; load command buffer
.empty:	cmp	byte [rbx], 10	; check for empty command
	je	.end
.quit:	cmp	dword [rbx], 'quit'	; check for quit
	jne	.right		; next branch if not
	mov	bl, 1		; quit
	mov	[do_exit], bl	; ...
	jmp	.end		; end
.right:	cmp	dword [rbx], 'rght' ; check for right
	jne	.down		; next branch if not
	call	go_right
	jmp	.end
.down:	cmp	dword [rbx], 'down'
	jne	.left
	call	go_down
	jmp	.end
.left:	cmp	dword [rbx], 'left'
	jne	.up
	call	go_left
	jmp	.end
.up:	cmp	word [rbx], 'up'
	jne	.pos
	call	go_up
	jmp	.end
.pos:	cmp	dword [rbx], `pos\xA`
	jne	.cnf
	call	print_pos
	jmp	.end
.cnf:	mov	rsi, .cnf_str	; load cnf message
	mov	edx, [.cnf_len]	; ...
	call	puts		; print cnf message
.end:	xor 	al, al		; zero
	xor	rbx, rbx		; some
	xor	bl, bl		; stuff
	ret			; return
.cnf_str:	db	"??Command not found", 10
.cnf_len:	dd	$-.cnf_str

go_right:	mov	al, [curx]
	add	al, 1
	mov	bl, [fieldw]
	add	bl, 1
	cmp	al, bl
	je	.failed
	mov	[curx], al
	mov	rsi, .msg
	mov	edx, [.msg_len]
	call	puts
	jmp	.end
.failed:	mov	rsi, endmsg
	mov	edx, [l_endmsg]
	call	puts
.end:	call	print_pos
	ret
.msg:	db	"Moved right.", 10
.msg_len:	dd	$-.msg

go_down:	mov	al, [cury]
	add	al, 1
	mov	bl, [fieldh]
	add	bl, 1
	cmp	al, bl
	je	.failed
	mov	[cury], al
	mov	rsi, .msg
	mov	edx, [.msg_len]
	call	puts
	jmp	.end
.failed:	mov	rsi, endmsg
	mov	edx, [l_endmsg]
	call	puts
.end:	call	print_pos
	ret
.msg:	db	"Moved down.", 10
.msg_len:	dd	$-.msg

go_left:	mov	al, [curx]
	cmp	al, 0
	je	.failed
	sub	al, 1
	mov	[curx], al
	mov	rsi, .msg
	mov	edx, [.msg_len]
	call	puts
	jmp	.end
.failed:	mov	rsi, endmsg
	mov	edx, [l_endmsg]
	call	puts
.end:	call	print_pos
	ret
.msg:	db	"Moved left.", 10
.msg_len:	dd	$-.msg

go_up:	mov	al, [cury]
	cmp	al, 0
	je	.failed
	sub	al, 1
	mov	[cury], al
	mov	rsi, .msg
	mov	edx, [.msg_len]
	call	puts
	jmp	.end
.failed:	mov	rsi, endmsg
	mov	edx, [l_endmsg]
	call	puts
.end:	call	print_pos
	ret
.msg:	db	"Moved up.", 10
.msg_len:	dd	$-.msg

print_pos:
	mov	rsi, .msg_cpos_start
	mov	edx, [.msg_cpos_start_len]
	call	puts
	mov	al, [curx]
	mov	bl, [cury]
	add	al, '0'
	add	bl, '0'
	call	.printxy
	mov	rsi, .msg_dim_start
	mov	edx, [.msg_dim_start_len]
	call	puts
	mov	al, [fieldw]
	mov	bl, [fieldw]
	add	al, '0'
	add	bl, '0'
	call	.printxy
	ret
.printxy:	mov	rsi, xymsg
	mov	edx, 7
	mov	byte [xymsg + 1], al
	mov	byte [xymsg + 4], bl
	call	puts
	ret
.msg_cpos_start: db	'Current position: '
.msg_cpos_start_len: dd	$-.msg_cpos_start
.msg_dim_start: db	'Field dimensions: '
.msg_dim_start_len: dd	$-.msg_dim_start