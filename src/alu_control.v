// alu_control.v - ALU Control Unit
// Maps ALU_OP and function code to actual ALU control signals

module alu_control (
    input wire [1:0] alu_op,        // ALU operation from main control
    input wire [5:0] funct,         // Function field [5:0] from instruction
    input wire [5:0] opcode,        // Opcode for immediate operations
    output reg [3:0] alu_ctrl       // ALU control signal
);

    // ALU Control codes (same as in alu.v)
    localparam ADD  = 4'b0010;
    localparam SUB  = 4'b0110;
    localparam AND  = 4'b0000;
    localparam OR   = 4'b0001;
    localparam SLT  = 4'b0111;
    localparam SLL  = 4'b1000;
    localparam SRL  = 4'b1001;
    localparam XOR  = 4'b0011;
    localparam NOR  = 4'b1100;

    // Function codes for R-type instructions
    localparam FUNCT_ADD = 6'b100000;  // add
    localparam FUNCT_SUB = 6'b100010;  // sub
    localparam FUNCT_AND = 6'b100100;  // and
    localparam FUNCT_OR  = 6'b100101;  // or
    localparam FUNCT_SLT = 6'b101010;  // slt
    localparam FUNCT_SLL = 6'b000000;  // sll
    localparam FUNCT_SRL = 6'b000010;  // srl
    localparam FUNCT_XOR = 6'b100110;  // xor
    localparam FUNCT_NOR = 6'b100111;  // nor

    // Immediate instruction opcodes
    localparam ORI   = 6'b001101;
    localparam ANDI  = 6'b001100;
    localparam SLTI  = 6'b001010;

    always @(*) begin
        case (alu_op)
            2'b00: begin  // LW, SW, ADDI - Addition
                alu_ctrl = ADD;
            end
            
            2'b01: begin  // BEQ - Subtraction
                alu_ctrl = SUB;
            end
            
            2'b10: begin  // R-type - Use function field
                case (funct)
                    FUNCT_ADD: alu_ctrl = ADD;
                    FUNCT_SUB: alu_ctrl = SUB;
                    FUNCT_AND: alu_ctrl = AND;
                    FUNCT_OR:  alu_ctrl = OR;
                    FUNCT_SLT: alu_ctrl = SLT;
                    FUNCT_SLL: alu_ctrl = SLL;
                    FUNCT_SRL: alu_ctrl = SRL;
                    FUNCT_XOR: alu_ctrl = XOR;
                    FUNCT_NOR: alu_ctrl = NOR;
                    default:   alu_ctrl = ADD;  // Default to ADD
                endcase
            end
            
            2'b11: begin  // Immediate operations - Use opcode
                case (opcode)
                    ORI:  alu_ctrl = OR;
                    ANDI: alu_ctrl = AND;
                    SLTI: alu_ctrl = SLT;
                    default: alu_ctrl = ADD;
                endcase
            end
            
            default: alu_ctrl = ADD;
        endcase
    end

endmodule