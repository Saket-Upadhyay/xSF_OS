section .multiboot_header
start_header:
	; magic number for MB2
	dd 0xe85250d6
	; architecture def
	dd 0 ; protected mode i386
	; length of the header
	dd end_header - start_header
	; checksum
	dd 0x100000000 - (0xe85250d6 + 0 + (end_header - start_header))
    
	dw 0
	dw 0
	dd 8
end_header: