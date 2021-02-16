.code16
.intel_syntax noprefix
.text
.global _start
_start:
	mov ah, 0
	mov al, 3
	int 0x10
	call setImage
	L0:
	jmp L0
	hlt
setImage:
	push bp
	mov bp, sp
	push di
	push bx
	mov ax, [size]
	mov bx, [width]
	mov dx, 0
	div bx
	mov bx, ax
	mov di, 0
setImage_L0:
	cmp di, bx
	je setImage_L1
	push di
	call setImageLine
	add sp, 2
	inc di
	jmp setImage_L0
setImage_L1:
	pop bx
	pop di
	mov sp, bp
	pop bp
	ret
setImageLine: #y
	push bp
	mov bp, sp
	push di
	push si
	push bx
	mov bx, [width]
	mov di, 0
	mov si, [bp+4]
setImageLine_L0:
	cmp di, bx
	je setImageLine_L1
	push si
	push di
	call setImagePixel
	add sp, 4
	inc di
	jmp setImageLine_L0
setImageLine_L1:
	pop bx
	pop si
	pop di
	mov sp, bp
	pop bp
	ret
setImagePixel: #x, y
	push bp
	mov bp, sp
	push di
	push si
	push bx
	mov ax, [width]
	mov si, [bp+6]
	mov bx, [bp+4]
	mul si
	add ax, di
	mov dx, 0
	mov di, 2
	div di
	lea di, [image]
	add di, ax
	mov di, [di]
	test bx, 1
	jnz setImagePixel_L0
	shr di, 4
setImagePixel_L0:
	and di, 0xF
	mov ax, 2
	mul bx
	mov bx, ax
	push di
	push si
	push bx
	call setPixel
	add sp, 6
	push di
	push si
	inc bx
	push bx
	call setPixel
	add sp, 6
	pop bx
	pop si
	pop di
	mov sp, bp
	pop bp
	ret
setPixel: #x, y, color
	push bp
	mov bp, sp
	push bx
	mov ah, 2
	mov bh, 0
	mov dl, [bp+4]
	mov dh, [bp+6]
	int 0x10
	mov ah, 9
	mov al, 0x20
	mov bh, 0
	mov bl, [bp+8]
	shl bl, 4
	mov cx, 1
	int 0x10
	pop bx
	mov sp, bp
	pop bp
	ret

width:
.word 24
size:
.word 480
image:
.ascii "\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xf8\x88\x8f\x88\x88\xf8\x8f\xf8\x8f\xf8\x88\x8f\xf8\xff\xff\x8f\xff\xff\x8f\xff\x8f\xf8\xff\x8f\xf8\xff\xff\x88\x88\xff\x8f\xff\x8f\xf8\x88\x8f\xf8\xff\xff\xff\xf8\xff\x8f\xff\x8f\xf8\xff\x8f\xe8\x88\x8f\x88\x88\xf8\x88\xf8\x88\xf8\x88\x82\xee\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\xe8\x88\x8f\x88\x88\xf8\xff\xf8\xff\xff\xf2\x22\xe8\xee\x8f\x8f\xff\xf8\x8f\x88\xff\xff\x22\x22\xc8\x88\x8f\x88\x88\xf8\xf8\xf8\xff\xf2\x22\x22\xc8\xee\x8e\xff\xf8\xf8\xff\xf8\xff\x22\x22\x25\xc8\xce\x8e\x88\x88\xf8\xff\xf8\xf2\x22\x22\x55\xcc\xcc\xee\xee\xff\xff\xff\xff\x22\x22\x25\x55\xcc\xcc\xce\xee\xef\xff\xff\xf2\x22\x22\x55\x55\xcc\xcc\xcc\xee\xee\xff\xff\x22\x22\x25\x55\x55\xcc\xcc\xcc\xce\xee\xef\xf2\x22\x22\x55\x55\x59\xcc\xcc\xcc\xcc\xee\xee\x22\x22\x25\x55\x55\x99\xcc\xcc\xcc\xcc\xce\xee\xe2\x22\x55\x55\x59\x99\xcc\xcc\xcc\xcc\xcc\xee\xee\x25\x55\x55\x99\x99\xcc\xcc\xcc\xcc\xcc\xce\xee\xe5\x55\x59\x99\x99"

. = _start + 510
.byte 0x55
.byte 0xAA
