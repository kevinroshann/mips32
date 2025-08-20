// regfile.v - Register File Module
// 32 x 32-bit registers with dual read ports and one write port
// Register $0 is hardwired to 0

module regfile (
    input wire clk,                    // Clock
    input wire [4:0] rs1,              // Read address 1 (rs)
    input wire [4:0] rs2,              // Read address 2 (rt)
    input wire [4:0] rd,               // Write address (rd)
    input wire [31:0] write_data,      // Data to write
    input wire reg_write_en,           // Write enable
    output wire [31:0] read_data1,     // Data from rs1
    output wire [31:0] read_data2      // Data from rs2
);

    // 32 registers, each 32 bits wide
    reg [31:0] registers [0:31];

    // Declare loop variable outside (Verilog-2001 requirement)
    integer i;

    // Initialize registers
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'h00000000;
        end
    end
    
    // Continuous read (combinational)
    assign read_data1 = (rs1 == 5'b00000) ? 32'h00000000 : registers[rs1];
    assign read_data2 = (rs2 == 5'b00000) ? 32'h00000000 : registers[rs2];
    
    // Synchronous write
    always @(posedge clk) begin
        if (reg_write_en && rd != 5'b00000) begin  // Don't write to $0
            registers[rd] <= write_data;
        end
    end

endmodule
