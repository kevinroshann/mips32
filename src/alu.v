// alu.v - Arithmetic Logic Unit
// Supports basic MIPS operations

module alu (
    input wire [31:0] a,           // First operand
    input wire [31:0] b,           // Second operand
    input wire [3:0] alu_ctrl,     // ALU control signal
    output reg [31:0] alu_result,  // ALU result
    output wire zero_flag          // Zero flag (result == 0)
);

    // ALU Control codes
    localparam ADD  = 4'b0010;  // Addition
    localparam SUB  = 4'b0110;  // Subtraction
    localparam AND  = 4'b0000;  // Bitwise AND
    localparam OR   = 4'b0001;  // Bitwise OR
    localparam SLT  = 4'b0111;  // Set less than
    localparam SLL  = 4'b1000;  // Shift left logical
    localparam SRL  = 4'b1001;  // Shift right logical
    localparam XOR  = 4'b0011;  // Bitwise XOR
    localparam NOR  = 4'b1100;  // Bitwise NOR

    // ALU operations
    always @(*) begin
        case (alu_ctrl)
            ADD:  alu_result = a + b;
            SUB:  alu_result = a - b;
            AND:  alu_result = a & b;
            OR:   alu_result = a | b;
            SLT:  alu_result = ($signed(a) < $signed(b)) ? 32'h00000001 : 32'h00000000;
            SLL:  alu_result = b << a[4:0];  // Shift amount in lower 5 bits of a
            SRL:  alu_result = b >> a[4:0];  // Shift amount in lower 5 bits of a
            XOR:  alu_result = a ^ b;
            NOR:  alu_result = ~(a | b);
            default: alu_result = 32'h00000000;
        endcase
    end
    
    // Zero flag
    assign zero_flag = (alu_result == 32'h00000000);

endmodule