        global rand_nki
        section .text
rand_nki:
        mov     rdi, file      ; filename
        xor     rsi, rsi        ; 0 = read-only
        mov     rdx, 0777       ; file mode
        mov     rax, 2          ; open
        syscall

.readf: mov     rdi, rax        ; file pointer
        mov     rsi, [curb]    ; buffer pointer
        mov     rdx, 1          ; read 1 byte
        xor     rax, rax        ; read (0)
        mov     cl, 0           ; initialize line counter
.readb: syscall
        
        
        section .data
file:   db      'vanilla.nki', 0
curb:   db      0               ; current byte in file
lbuf:   times   81      db      0 ; current line buffer
total:  dw      702             ; total number of non-kitten items
target: db      198             ; (dummy) target item