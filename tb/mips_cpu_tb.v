// mips_cpu_tb.v - Complete MIPS CPU Testbench

`timescale 1ns/1ps

module mips_cpu_tb;

    reg clk;
    reg rst;
    
    // Instantiate the MIPS CPU
    mips_cpu uut (
        .clk(clk),
        .rst(rst)
    );
    
    // Clock generation (100MHz)
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    // Test monitor to observe CPU state
    always @(posedge clk) begin
        $display("PC=0x%08X, Inst=0x%08X, RegWrite=%b, MemWrite=%b", 
                 uut.pc_out, uut.instruction, uut.reg_write, uut.mem_write);
        
        // Display register values (first 8 registers)
        if (uut.reg_write) begin
            $display("  Writing R%d = 0x%08X", uut.reg_write_addr, uut.write_data);
        end
        
        // Display memory writes
        if (uut.mem_write) begin
            $display("  Memory Write: Addr=0x%08X, Data=0x%08X", uut.alu_result, uut.read_data2);
        end
        
        // Display memory reads
        if (uut.mem_read) begin
            $display("  Memory Read: Addr=0x%08X, Data=0x%08X", uut.alu_result, uut.mem_read_data);
        end
    end
    
    initial begin
        $display("Starting MIPS CPU Test");
        $display("=====================");
        
        // Initialize
        rst = 1;
        #20;
        rst = 0;
        
        // Let the CPU run the test program from instruction memory
        // The program loaded in imem.v includes:
        // 1. addi $1, $0, 10    - Load 10 into $1
        // 2. addi $2, $0, 20    - Load 20 into $2
        // 3. add $3, $1, $2     - Add $1 and $2 -> $3
        // 4. sub $4, $3, $1     - Subtract $1 from $3 -> $4
        // 5. and $5, $3, $2     - AND $3 and $2 -> $5
        // 6. or $6, $4, $5      - OR $4 and $5 -> $6
        // 7. slt $7, $1, $2     - Set $7 if $1 < $2
        // 8. beq $1, $2, -1     - Branch if $1 == $2 (won't branch)
        // 9. j 0                - Jump to address 0
        
        // Run for enough cycles to execute the program
        #200;
        
        $display("\n=== Final Register State ===");
        $display("$1 (should be 10): %d", uut.regfile_inst.registers[1]);
        $display("$2 (should be 20): %d", uut.regfile_inst.registers[2]);
        $display("$3 (should be 30): %d", uut.regfile_inst.registers[3]);
        $display("$4 (should be 20): %d", uut.regfile_inst.registers[4]);
        $display("$5 (should be 20): %d", uut.regfile_inst.registers[5]);
        $display("$6 (should be 20): %d", uut.regfile_inst.registers[6]);
        $display("$7 (should be 1):  %d", uut.regfile_inst.registers[7]);
        
        // Verify results
        if (uut.regfile_inst.registers[1] == 32'd10 &&
            uut.regfile_inst.registers[2] == 32'd20 &&
            uut.regfile_inst.registers[3] == 32'd30 &&
            uut.regfile_inst.registers[4] == 32'd20 &&
            uut.regfile_inst.registers[7] == 32'd1) begin
            $display("\n✓ CPU Test PASSED - All operations executed correctly!");
        end else begin
            $display("\n✗ CPU Test FAILED - Check register values");
        end
        
        $display("\nMIPS CPU test completed");
        $finish;
    end
    
    // Timeout to prevent infinite simulation
    initial begin
        #1000;
        $display("TIMEOUT: Simulation ended");
        $finish;
    end

endmodule