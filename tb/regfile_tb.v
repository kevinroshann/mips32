// regfile_tb.v - Register File Testbench

`timescale 1ns/1ps

module regfile_tb;

    reg clk;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] write_data;
    reg reg_write_en;
    wire [31:0] read_data1, read_data2;
    
    // Instantiate register file
    regfile uut (
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .reg_write_en(reg_write_en),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    
    // Clock generation
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    initial begin
        $display("Starting Register File Test");
        
        // Initialize
        rs1 = 0; rs2 = 0; rd = 0; write_data = 0; reg_write_en = 0;
        #10;
        
        // Test 1: Read from $0 (should always be 0)
        rs1 = 5'd0; rs2 = 5'd0;
        #10;
        if (read_data1 == 32'h00000000 && read_data2 == 32'h00000000)
            $display("PASS: $0 register reads as 0");
        else
            $display("FAIL: $0 register not zero");
            
        // Test 2: Write to register $1
        rd = 5'd1; write_data = 32'hDEADBEEF; reg_write_en = 1;
        #10; reg_write_en = 0;
        
        // Read from $1
        rs1 = 5'd1;
        #10;
        if (read_data1 == 32'hDEADBEEF)
            $display("PASS: Write/Read to $1");
        else
            $display("FAIL: Write/Read to $1");
            
        // Test 3: Write to $0 (should be ignored)
        rd = 5'd0; write_data = 32'hBADC0DE; reg_write_en = 1;
        #10; reg_write_en = 0;
        
        rs1 = 5'd0;
        #10;
        if (read_data1 == 32'h00000000)
            $display("PASS: $0 remains zero after write attempt");
        else
            $display("FAIL: $0 was modified");
            
        // Test 4: Dual port read
        rd = 5'd2; write_data = 32'hCAFEBABE; reg_write_en = 1;
        #10; reg_write_en = 0;
        
        rs1 = 5'd1; rs2 = 5'd2;
        #10;
        if (read_data1 == 32'hDEADBEEF && read_data2 == 32'hCAFEBABE)
            $display("PASS: Dual port read");
        else
            $display("FAIL: Dual port read");
            
        $display("Register File test completed");
        $finish;
    end

endmodule