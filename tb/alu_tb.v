// alu_tb.v - ALU Testbench

`timescale 1ns/1ps

module alu_tb;

    reg [31:0] a, b;
    reg [3:0] alu_ctrl;
    wire [31:0] alu_result;
    wire zero_flag;
    
    // Instantiate ALU
    alu uut (
        .a(a),
        .b(b),
        .alu_ctrl(alu_ctrl),
        .alu_result(alu_result),
        .zero_flag(zero_flag)
    );
    
    initial begin
        $display("Starting ALU Test");
        
        // Test ADD
        a = 32'h00000005; b = 32'h00000003; alu_ctrl = 4'b0010;
        #10;
        if (alu_result == 32'h00000008)
            $display("PASS: ADD 5 + 3 = %d", alu_result);
        else
            $display("FAIL: ADD expected 8, got %d", alu_result);
            
        // Test SUB
        a = 32'h00000005; b = 32'h00000003; alu_ctrl = 4'b0110;
        #10;
        if (alu_result == 32'h00000002)
            $display("PASS: SUB 5 - 3 = %d", alu_result);
        else
            $display("FAIL: SUB expected 2, got %d", alu_result);
            
        // Test AND
        a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; alu_ctrl = 4'b0000;
        #10;
        if (alu_result == 32'h00000000)
            $display("PASS: AND operation");
        else
            $display("FAIL: AND operation");
            
        // Test OR
        a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; alu_ctrl = 4'b0001;
        #10;
        if (alu_result == 32'hFFFFFFFF)
            $display("PASS: OR operation");
        else
            $display("FAIL: OR operation");
            
        // Test SLT (Set Less Than)
        a = 32'h00000003; b = 32'h00000005; alu_ctrl = 4'b0111;
        #10;
        if (alu_result == 32'h00000001)
            $display("PASS: SLT 3 < 5");
        else
            $display("FAIL: SLT 3 < 5");
            
        a = 32'h00000005; b = 32'h00000003; alu_ctrl = 4'b0111;
        #10;
        if (alu_result == 32'h00000000)
            $display("PASS: SLT 5 not < 3");
        else
            $display("FAIL: SLT 5 not < 3");
            
        // Test Zero Flag
        a = 32'h00000005; b = 32'h00000005; alu_ctrl = 4'b0110;
        #10;
        if (zero_flag == 1'b1)
            $display("PASS: Zero flag set for 5-5");
        else
            $display("FAIL: Zero flag not set for 5-5");
            
        $display("ALU test completed");
        $finish;
    end

endmodule