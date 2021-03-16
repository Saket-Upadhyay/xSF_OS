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
	mov esp,stack_top

	call check_multiboot
	call check_cpuid
	call check_longmode

	call setup_pagetable
	call enable_paging

	lgdt [gdt64.pointer]

	jmp gdt64.code_segment:longmode_start

	; print 'SU'
	; mov dword [0xb8000], 0x2f552f53
	; moved to main64.asm
	hlt


check_multiboot:

cmp eax, 0x36d76289
jne .no_multiboot
ret
.no_multiboot:

mov al,"M"
jmp error


check_cpuid:
	pushfd
	pop eax
	mov ecx,eax
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
mov al, "C"
jmp error


check_longmode:
	mov eax,0x80000000
	cpuid
	cmp eax,0x80000001
	jb .no_long_mode

	mov eax,0x80000001
	cpuid
	test edx, 1<<29
	jz .no_long_mode
	ret
.no_long_mode:
	mov al,"L"
	jmp error


setup_pagetable:

	;Stitching different levels of page tables
	mov eax, page_table_L3
	or eax, 0b11 ; present, writable
	mov [page_table_L4],eax

	mov eax, page_table_L2
	or eax, 0b11 ; present, writable
	mov [page_table_L3],eax

	mov ecx,0 ; loop counter
.loop:
	mov eax,0x200000
	mul ecx
	or eax,0b10000011 ; present, writable, huge page
	mov [page_table_L2 + ecx * 8],eax
	inc ecx
	cmp ecx,512 ; check if the table is mapped
	jne .loop

	ret

enable_paging:
	; pass the page table location to CPU
	mov eax,page_table_L4
	mov cr3,eax

	;enable PAE
	mov eax,cr4
	or eax,1<<5
	mov cr4, eax

	;enable longmode

	mov ecx, 0xC0000080
	rdmsr ; read model specific register
	or eax, 1<<8
	wrmsr

	;enable paging
	mov eax,cr0
	or eax,1<<31
	mov cr0, eax

	ret


error:

mov dword [0xb8000], 0x4f524f45
mov dword [0xb8004], 0x4f3a4f52
mov dword [0xb8008], 0x4f204f20
; doing mov dword below will give operand size error as AL is lower register and do not operate on dword
mov byte [0xb800a], al
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
