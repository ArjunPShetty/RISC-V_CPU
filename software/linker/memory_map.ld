# Memory map linker script
/* RISC-V Memory Map */
MEMORY {
    RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 64K
    ROM (rx)  : ORIGIN = 0x20000000, LENGTH = 32K
}

SECTIONS {
    .text : {
        *(.text.start)
        *(.text)
    } > ROM
    
    .data : {
        *(.data)
    } > RAM
    
    .bss : {
        *(.bss)
    } > RAM
    
    .stack : {
        . = ALIGN(16);
        _stack_end = .;
        . = . + 4K;
        _stack_top = .;
    } > RAM
}