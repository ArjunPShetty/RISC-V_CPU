# Top testbench
module tb_top;

    // Clock and reset
    reg clk;
    reg rst_n;
    
    // CPU signals
    wire [31:0] imem_addr;
    wire [31:0] imem_data;
    wire [31:0] dmem_addr;
    wire dmem_write_en;
    wire [3:0] dmem_write_strb;
    wire [31:0] dmem_write_data;
    wire [31:0] dmem_read_data;
    
    // Instruction memory
    reg [31:0] instr_mem [0:1023];
    reg [31:0] data_mem  [0:1023];
    
    // Test program
    integer i;
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Memory simulation
    assign imem_data = instr_mem[imem_addr[31:2]];
    assign dmem_read_data = data_mem[dmem_addr[31:2]];
    
    always @(posedge clk) begin
        if (dmem_write_en) begin
            if (dmem_write_strb[0]) data_mem[dmem_addr[31:2]][7:0]   <= dmem_write_data[7:0];
            if (dmem_write_strb[1]) data_mem[dmem_addr[31:2]][15:8]  <= dmem_write_data[15:8];
            if (dmem_write_strb[2]) data_mem[dmem_addr[31:2]][23:16] <= dmem_write_data[23:16];
            if (dmem_write_strb[3]) data_mem[dmem_addr[31:2]][31:24] <= dmem_write_data[31:24];
        end
    end
    
    // Instantiate CPU
    riscv_core u_cpu (
        .clk(clk),
        .rst_n(rst_n),
        .imem_addr(imem_addr),
        .imem_data(imem_data),
        .dmem_addr(dmem_addr),
        .dmem_write_en(dmem_write_en),
        .dmem_write_strb(dmem_write_strb),
        .dmem_write_data(dmem_write_data),
        .dmem_read_data(dmem_read_data)
    );
    
    // Test stimulus
    initial begin
        // Initialize
        clk = 0;
        rst_n = 0;
        
        // Initialize memories
        for (i = 0; i < 1024; i = i + 1) begin
            instr_mem[i] = 32'b0;
            data_mem[i] = 32'b0;
        end
        
        // Load test program
        // Simple add test: addi x1, x0, 5; addi x2, x1, 3
        instr_mem[0] = 32'h00500093;  // addi x1, x0, 5
        instr_mem[1] = 32'h00308113;  // addi x2, x1, 3
        instr_mem[2] = 32'h002081b3;  // add x3, x1, x2
        instr_mem[3] = 32'h0020a023;  // sw x2, 0(x1)
        instr_mem[4] = 32'h0000a203;  // lw x4, 0(x1)
        instr_mem[5] = 32'h00408863;  // beq x1, x4, 16
        
        // Apply reset
        #10 rst_n = 1;
        
        // Run simulation
        #500;
        
        // Display results
        $display("Test completed");
        $display("Register x1: %h", u_cpu.u_regfile.regfile[1]);
        $display("Register x2: %h", u_cpu.u_regfile.regfile[2]);
        $display("Register x3: %h", u_cpu.u_regfile.regfile[3]);
        $display("Register x4: %h", u_cpu.u_regfile.regfile[4]);
        
        $finish;
    end
    
    // Waveform dumping
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_top);
    end

endmodule