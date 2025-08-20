// pc_tb.v - Testbench for Program Counter

`timescale 1ns/1ps

module pc_tb;

    // Testbench signals
    reg clk;
    reg rst;
    reg [31:0] next_pc;
    wire [31:0] pc_out;
    
    // Instantiate the PC module
    pc uut (
        .clk(clk),
        .rst(rst),
        .next_pc(next_pc),
        .pc_out(pc_out)
    );
    
    // Clock generation (10ns period = 100MHz)
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end
    
    // Test sequence
    initial begin
        // Initialize signals
        rst = 1;
        next_pc = 32'h00000000;
        
        // Wait for a few clock cycles with reset active
        #20;
        
        // Check reset functionality
        if (pc_out !== 32'h00000000) begin
            $display("ERROR: Reset failed. Expected 0x00000000, got 0x%h", pc_out);
        end else begin
            $display("PASS: Reset successful. PC = 0x%h", pc_out);
        end
        
        // Release reset and start testing
        rst = 0;
        #10;
        
        // Test normal PC increment (PC + 4)
        next_pc = 32'h00000004;
        #10;
        if (pc_out !== 32'h00000004) begin
            $display("ERROR: PC increment failed. Expected 0x00000004, got 0x%h", pc_out);
        end else begin
            $display("PASS: PC increment. PC = 0x%h", pc_out);
        end
        
        // Test another increment
        next_pc = 32'h00000008;
        #10;
        if (pc_out !== 32'h00000008) begin
            $display("ERROR: PC increment failed. Expected 0x00000008, got 0x%h", pc_out);
        end else begin
            $display("PASS: PC increment. PC = 0x%h", pc_out);
        end
        
        // Test jump (non-sequential)
        next_pc = 32'h00001000;
        #10;
        if (pc_out !== 32'h00001000) begin
            $display("ERROR: PC jump failed. Expected 0x00001000, got 0x%h", pc_out);
        end else begin
            $display("PASS: PC jump. PC = 0x%h", pc_out);
        end
        
        // Test reset again
        rst = 1;
        #10;
        if (pc_out !== 32'h00000000) begin
            $display("ERROR: Second reset failed. Expected 0x00000000, got 0x%h", pc_out);
        end else begin
            $display("PASS: Second reset successful. PC = 0x%h", pc_out);
        end
        
        rst = 0;
        #10;
        
        $display("PC testbench completed successfully!");
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time=%0t, rst=%b, next_pc=0x%h, pc_out=0x%h", 
                 $time, rst, next_pc, pc_out);
    end

endmodule