# Basic assembly test
# Basic RISC-V Assembly Test Program
# Tests basic arithmetic, memory operations, and branches

.section .text
.global _start

_start:
    # Test 1: Arithmetic operations
    addi x1, x0, 5      # x1 = 5
    addi x2, x0, 3      # x2 = 3
    add  x3, x1, x2     # x3 = 8 (5 + 3)
    sub  x4, x1, x2     # x4 = 2 (5 - 3)
    
    # Test 2: Logical operations
    ori  x5, x1, 0x00F  # x5 = 5 | 0xF = 0xF
    andi x6, x5, 0x00A  # x6 = 0xF & 0xA = 0xA
    xori x7, x6, 0x00F  # x7 = 0xA ^ 0xF = 0x5
    
    # Test 3: Shift operations
    slli x8, x1, 2      # x8 = 5 << 2 = 20
    srli x9, x8, 1      # x9 = 20 >> 1 = 10
    
    # Test 4: Memory operations
    lui  x10, 0x10000   # x10 = 0x10000000
    sw   x3, 0(x10)     # Store x3 to memory
    lw   x11, 0(x10)    # Load back to x11
    
    # Test 5: Branch operations
    beq  x3, x11, branch_taken  # Should branch
    addi x12, x0, 1     # Should be skipped
    
branch_taken:
    addi x12, x0, 2     # x12 = 2
    
    # Test 6: Jump operations
    jal  x13, jump_target
    
skip_here:
    addi x14, x0, 1     # Should be skipped
    
jump_target:
    addi x14, x0, 3     # x14 = 3
    
    # Test completion
    ebreak              # Break to indicate completion
    
.section .data
test_data:
    .word 0x12345678
    .word 0x9ABCDEF0