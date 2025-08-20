// dmem.v - Data Memory Module
// Simple RAM for load/store instructions

module dmem (
    input wire clk,                 // Clock
    input wire [31:0] addr,         // Memory address
    input wire [31:0] write_data,   // Data to write
    input wire mem_write,           // Write enable
    input wire mem_read,            // Read enable
    output wire [31:0] read_data    // Data read from memory
);

    // Data memory array - 1024 words (4KB)
    reg [31:0] memory [0:1023];
    
    // Word address calculation
    wire [9:0] word_addr;
    assign word_addr = addr[11:2];  // Word addressing
    
    // Initialize memory
    integer i;
    initial begin
        
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = 32'h00000000;
        end
        
        // Initialize some test data
        memory[0] = 32'hDEADBEEF;   // Test pattern at address 0
        memory[1] = 32'hCAFEBABE;   // Test pattern at address 4
        memory[2] = 32'h12345678;   // Test pattern at address 8
    end
    
    // Synchronous write
    always @(posedge clk) begin
        if (mem_write) begin
            memory[word_addr] <= write_data;
        end
    end
    
    // Asynchronous read
    assign read_data = mem_read ? memory[word_addr] : 32'h00000000;

endmodule