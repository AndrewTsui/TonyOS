; ----------------------------------------------------------------
;
; 	boot.s
;
; ----------------------------------------------------------------

MBOOT_HEADER_MAGIC 	equ 	0x1BADB002 	; Multiboot Magic
MBOOT_PAGE_ALIGN 	equ 	1 << 0    	; 4K Alignment
MBOOT_MEM_INFO 		equ 	1 << 1    
MBOOT_HEADER_FLAGS 	equ 	MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO
MBOOT_CHECKSUM 		equ 	- (MBOOT_HEADER_MAGIC + MBOOT_HEADER_FLAGS)

; ----------------------------------------------------------------

[BITS 32]  	; Compile codes whih 32-bit

section .text 	; Code segment

dd MBOOT_HEADER_MAGIC 	; GRUB will check out those parameters
dd MBOOT_HEADER_FLAGS   
dd MBOOT_CHECKSUM       

[GLOBAL start] 		; The entrance of kernel codes for ld linker
[GLOBAL glb_mboot_ptr] 	; Global struct multiboot * 
[EXTERN kern_entry] 	; The entrance of kernel C codes

start:
	cli  			 ; Interrupt disable
	mov esp, STACK_TOP  	 ; Stack address
	mov ebp, 0 		 ; Stack pointer
	and esp, 0FFFFFFF0H	 ; Staci address in 16 bytes alignment
	mov [glb_mboot_ptr], ebx 
	call kern_entry		 
stop:
	hlt 			 
	jmp stop 		 ; End

;-----------------------------------------------------------------

section .bss 			 ; Data segment
stack:
	resb 32768 	 	 ; Stack of kernel
glb_mboot_ptr: 			 ; Global struct multiboot pointer
	resb 4

STACK_TOP equ $-stack-1 	 ; Top of Stack

;-----------------------------------------------------------------
