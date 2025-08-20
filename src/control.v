// control.v - Main Control Unit
// Decodes instruction opcode and generates control signals

module control (
    input wire [5:0] opcode,        // Instruction opcode [31:26]
    output reg [1:0] alu_op,        // ALU operation type
    output reg alu_src,             // ALU source: 0=register, 1=immediate
    output reg reg_dst,             // Register destination: 0=rt, 1=rd
    output reg branch,              // Branch control
    output reg mem_read,            // Memory read enable
    output reg mem_write,           // Memory write enable
    output reg mem_to_reg,          // Memory to register: 0=ALU, 1=memory
    output reg reg_write,           // Register write enable
    output reg jump                 // Jump control
);

    // Opcodes
    localparam R_TYPE = 6'b000000;  // R-type instructions
    localparam LW     = 6'b100011;  // Load word
    localparam SW     = 6'b101011;  // Store word
    localparam BEQ    = 6'b000100;  // Branch equal
    localparam ADDI   = 6'b001000;  // Add immediate
    localparam JUMP   = 6'b000010;  // Jump
    localparam ORI    = 6'b001101;  // OR immediate
    localparam ANDI   = 6'b001100;  // AND immediate
    localparam SLTI   = 6'b001010;  // Set less than immediate

    always @(*) begin
        // Default values
        alu_op = 2'b00;
        alu_src = 1'b0;
        reg_dst = 1'b0;
        branch = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        mem_to_reg = 1'b0;
        reg_write = 1'b0;
        jump = 1'b0;
        
        case (opcode)
            R_TYPE: begin
                alu_op = 2'b10;      // R-type ALU operation
                alu_src = 1'b0;      // Use register for ALU input
                reg_dst = 1'b1;      // Write to rd
                reg_write = 1'b1;    // Enable register write
                mem_to_reg = 1'b0;   // ALU result to register
            end
            
            LW: begin
                alu_op = 2'b00;      // Addition for address calculation
                alu_src = 1'b1;      // Use immediate for ALU input
                reg_dst = 1'b0;      // Write to rt
                mem_read = 1'b1;     // Enable memory read
                reg_write = 1'b1;    // Enable register write
                mem_to_reg = 1'b1;   // Memory data to register
            end
            
            SW: begin
                alu_op = 2'b00;      // Addition for address calculation
                alu_src = 1'b1;      // Use immediate for ALU input
                mem_write = 1'b1;    // Enable memory write
            end
            
            BEQ: begin
                alu_op = 2'b01;      // Subtraction for comparison
                branch = 1'b1;       // Enable branch
            end
            
            ADDI: begin
                alu_op = 2'b00;      // Addition
                alu_src = 1'b1;      // Use immediate for ALU input
                reg_dst = 1'b0;      // Write to rt
                reg_write = 1'b1;    // Enable register write
            end
            
            JUMP: begin
                jump = 1'b1;         // Enable jump
            end
            
            ORI: begin
                alu_op = 2'b11;      // OR immediate
                alu_src = 1'b1;      // Use immediate for ALU input
                reg_dst = 1'b0;      // Write to rt
                reg_write = 1'b1;    // Enable register write
            end
            
            ANDI: begin
                alu_op = 2'b11;      // AND immediate (same as ORI, differentiated by funct)
                alu_src = 1'b1;      // Use immediate for ALU input
                reg_dst = 1'b0;      // Write to rt
                reg_write = 1'b1;    // Enable register write
            end
            
            SLTI: begin
                alu_op = 2'b11;      // Set less than immediate
                alu_src = 1'b1;      // Use immediate for ALU input
                reg_dst = 1'b0;      // Write to rt
                reg_write = 1'b1;    // Enable register write
            end
            
            default: begin
                // NOP - all signals remain at default (0)
            end
        endcase
    end

endmodule