// pc.v - Program Counter Module
// Simple 32-bit program counter with synchronous reset

module pc (
    input wire clk,           // Clock signal
    input wire rst,           // Reset signal (active high)
    input wire [31:0] next_pc, // Next PC value
    output reg [31:0] pc_out   // Current PC output
);

    // On positive edge of clock or reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out <= 32'h00000000;  // Reset PC to 0
        end else begin
            pc_out <= next_pc;       // Load next PC value
        end
    end

endmodule