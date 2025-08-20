module imem (
    input wire [31:0] addr,        // Address input (PC)
    output wire [31:0] instruction // 32-bit instruction output
);

    // Instruction memory array - 1024 words (4KB)
    reg [31:0] memory [0:1023];
    
    // Declare loop variable here (outside of initial block)
    integer i;
    
    // Word address calculation (divide by 4 since instructions are 4 bytes)
    wire [9:0] word_addr;
    assign word_addr = addr[11:2];
    
    assign instruction = memory[word_addr];
    
    initial begin
        // Initialize all memory to NOP (add $0, $0, $0)
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = 32'h00000000;  // NOP
        end
        
        // Example instructions
        memory[0] = 32'h2001000A; // addi $1, $0, 10
        memory[1] = 32'h20020014; // addi $2, $0, 20
        memory[2] = 32'h00221820; // add $3, $1, $2
        memory[3] = 32'h00612022; // sub $4, $3, $1
        memory[4] = 32'h00622824; // and $5, $3, $2
        memory[5] = 32'h00853025; // or  $6, $4, $5
        memory[6] = 32'h0022382A; // slt $7, $1, $2
        memory[7] = 32'h1022FFFF; // beq $1, $2, -1
        memory[8] = 32'h08000000; // j 0

        $display("Instruction Memory initialized with test program");
    end

endmodule
