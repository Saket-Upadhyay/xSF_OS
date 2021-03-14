global start

section .text
bits 32
start:
	; print 'SU'
	mov dword [0xb8000], 0x2f552f53
	hlt