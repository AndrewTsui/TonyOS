/*
 *          Thanks to Mr.JamesM
 *
 *          Original file taken from Bran's Kernel Development 
 *          tutorials: http://www.osdever.net/bkerndev/index.php. 
 *
 *      This script tells LD how to set up our kernel image. 
 *      Firstly it tells LD that the start location of our binary should be the symbol 'start'. 
 *      It then tells LD that the .text section (that's where all your code goes) should be first,
 *      and should start at 0x100000 (1MB). 
 *      The .data (initialised static data) and the .bss (uninitialised static data) should be next, 
 *      and each should be page-aligned (ALIGN(4096)).
 *      Linux GCC also adds in an extra data section: .rodata. 
 *      This is for read-only initialised data, such as constants. 
 *      For simplicity we simply bundle this in with the .data section.
 */

ENTRY(start)
SECTIONS
{
	. = 0x100000;

	.text :
	{
		*(.text)
		. = ALIGN(4096);
	}
	.data :
	{
		*(.data)
		*(.rodata)
		. = ALIGN(4096);
	}
	.bss :
	{
		*(.bss)
		. = ALIGN(4096);
	}
	.stab :
	{
		*(.stab)
		. = ALIGN(4096);
	}
	.stabstr :
	{
		*(.stabstr)
	 	. = ALIGN(4096);
	}
	
	/DISCARD/ : { *(.comment) *(.eh_frame) }
}

