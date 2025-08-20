// control_tb.v - Control Unit Testbench

`timescale 1ns/1ps

module control_tb;

    reg [5:0] opcode;
    wire [1:0] alu_op;
    wire alu_src, reg_dst, branch, mem_read, mem_write;
    wire mem_to_reg, reg_write, jump;
    
    // Instantiate control unit
    control uut (
        .opcode(opcode),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .reg_dst(reg_dst),
        .branch(branch),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write),
        .jump(jump)
    );
    
    initial begin
        $display("Starting Control Unit Test");
        $display("==========================");
        
        // Test R-type instruction (ADD, SUB, etc.)
        opcode = 6'b000000; #10;
        $display("R-type: alu_op=%b, alu_src=%b, reg_dst=%b, reg_write=%b", 
                 alu_op, alu_src, reg_dst, reg_write);
        if (alu_op == 2'b10 && !alu_src && reg_dst && reg_write && !mem_read && !mem_write && !jump)
            $display("PASS: R-type control signals");
        else
            $display("FAIL: R-type control signals");
            
        // Test ADDI
        opcode = 6'b001000; #10;
        $display("ADDI: alu_op=%b, alu_src=%b, reg_dst=%b, reg_write=%b", 
                 alu_op, alu_src, reg_dst, reg_write);
        if (alu_op == 2'b00 && alu_src && !reg_dst && reg_write)
            $display("PASS: ADDI control signals");
        else
            $display("FAIL: ADDI control signals");
            
        // Test LW
        opcode = 6'b100011; #10;
        $display("LW: mem_read=%b, mem_to_reg=%b, reg_write=%b", 
                 mem_read, mem_to_reg, reg_write);
        if (mem_read && mem_to_reg && reg_write && alu_src)
            $display("PASS: LW control signals");
        else
            $display("FAIL: LW control signals");
            
        // Test SW
        opcode = 6'b101011; #10;
        $display("SW: mem_write=%b, reg_write=%b", mem_write, reg_write);
        if (mem_write && !reg_write && alu_src)
            $display("PASS: SW control signals");
        else
            $display("FAIL: SW control signals");
            
        // Test BEQ
        opcode = 6'b000100; #10;
        $display("BEQ: branch=%b, alu_op=%b", branch, alu_op);
        if (branch && alu_op == 2'b01 && !reg_write)
            $display("PASS: BEQ control signals");
        else
            $display("FAIL: BEQ control signals");
            
        // Test JUMP
        opcode = 6'b000010; #10;
        $display("JUMP: jump=%b", jump);
        if (jump && !reg_write && !mem_write && !mem_read)
            $display("PASS: JUMP control signals");
        else
            $display("FAIL: JUMP control signals");
            
        $display("Control Unit test completed");
        $finish;
    end

endmodule