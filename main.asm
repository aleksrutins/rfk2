	global	_start

	section .text
	%include "lib.asm"
_start:	mov	rsi, msg
	mov	edx, [msg_len]
	call	puts
cmdloop:	mov	rsi, cmdbuf
	mov	rdx, 255
	call	prompt
	call	cmdparse
	mov	al, [do_exit]
	cmp	al, 1
	jne	cmdloop
	call	exit

	section	.data
msg:	db	'---------------------------', 10
	db	'WELCOME TO ROBOTFINDSKITTEN', 10
	db	'---------------------------', 10
	db	'This version copyrightleftmiddleupdownwhat? (c) 2022 Aleks Rutins', 10
	db	'Written in NASM assembly for Linux', 10
	db	10
	db	'In this game, you are robot.', 10
	db	'Your task is to find kitten.', 10
	db	'This task is complicated somewhat by the existence of certain items which are not kitten.', 10
	db	'Commands: (note that they are case-sensitive)', 10
	db	10
	db	'Name	Purpose', 10
	db	'====	=======', 10
	db	10
	db	'quit	Quit the game.', 10
	db	"rght	Go right, and see what's there.", 10
	db	"left	Go left, and see what's there.", 10
	db	"down	Go down, and see what's there.", 10
	db	"up	Go up, and see what's there.", 10
	db	'pos	Print the current position and field dimensions.', 10
	db	10
msg_len:	dd	$-msg
field:	dd	0, 0, 0, 0, 0, 10
	dd	0, 0, 0, 0, 0, 10
	dd	0, 0, 0, 0, 0, 10
	dd	0, 0, 0, 0, 0, 10
	dd	0, 0, 0, 0, 0, 10
fieldh:	db	5
fieldw:	db	5
curx:	db	0
cury:	db	0
cmdbuf:	times 	256	db 	0
do_exit:	db	0
xymsg:	db	'( ,  )', 10
endmsg:	db	"You have reached the end.", 10
l_endmsg:	dd	$-endmsg