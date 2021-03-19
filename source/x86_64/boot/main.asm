; MIT License

; Copyright (c) 2021 Saket Upadhyay

; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:

; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.

; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

global start
extern longmode_start

section .text
bits 32
start:
	MOV esp,stack_top

	CALL check_multiboot
	CALL check_cpuid
	CALL check_longmode

	CALL setup_pagetable
	CALL enable_paging

	lgdt [gdt64.pointer]

	JMP gdt64.code_segment:longmode_start

	; print 'SU'
	; MOV dword [0xb8000], 0x2f552f53
	; MOVed to main64.asm
	hlt


check_multiboot:

cmp eax, 0x36d76289
jne .no_multiboot
ret
.no_multiboot:

MOV al,"M"
JMP error


check_cpuid:
	pushfd
	pop eax
	MOV ecx,eax
	xor eax, 1<<21
	push eax
	popfd
	pushfd
	pop eax
	push ecx
	popfd
	cmp eax,ecx
	je .no_cpuid
	ret

.no_cpuid:
MOV al, "C"
JMP error


check_longmode:
	MOV eax,0x80000000
	cpuid
	cmp eax,0x80000001
	jb .no_long_mode

	MOV eax,0x80000001
	cpuid
	test edx, 1<<29
	jz .no_long_mode
	ret
	
.no_long_mode:
	MOV al,"L"
	JMP error


setup_pagetable:

	;Stitching different levels of page tables
	MOV eax, page_table_L3
	OR eax, 0b11 ; present, writable
	MOV [page_table_L4],eax

	MOV eax, page_table_L2
	OR eax, 0b11 ; present, writable
	MOV [page_table_L3],eax

	MOV ecx,0 ; loop counter
.loop:
	MOV eax,0x200000
	mul ecx
	OR eax,0b10000011 ; present, writable, huge page
	MOV [page_table_L2 + ecx * 8],eax
	inc ecx
	cmp ecx,512 ; check if the table is mapped
	jne .loop

	ret

enable_paging:
	; pass the page table location to CPU
	MOV eax,page_table_L4
	MOV cr3,eax

	;enable PAE
	MOV eax,cr4
	OR eax,1<<5
	MOV cr4, eax

	;enable longmode

	MOV ecx, 0xC0000080
	rdmsr ; read model specific register
	OR eax, 1<<8
	wrmsr

	;enable paging
	MOV eax,cr0
	OR eax,1<<31
	MOV cr0, eax

	ret


error:

MOV dword [0xb8000], 0x4f524f45
MOV dword [0xb8004], 0x4f3a4f52
MOV dword [0xb8008], 0x4f204f20
; doing MOV dword below will give operand size error as AL is lower register and do not operate on dword
MOV byte [0xb800a], al
hlt


section .bss

align 4096

page_table_L4:
	resb 4096
page_table_L3:
	resb 4096
page_table_L2:
	resb 4096

stack_bottom:
	resb 4096 * 4
stack_top:

section .rodata
; Global Discriptor Table to help 32 bit, move to 64 bit mode
gdt64:
	dq 0 ;zero entry
.code_segment: equ $ - gdt64
	dq (1<<43)|(1<<44)|(1<<47)|(1<<53) ; code segment

.pointer:
	dw $ - gdt64 -1
	dq gdt64
