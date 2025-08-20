// sign_extend.v - Sign Extension Module
// Extends 16-bit immediate to 32 bits

module sign_extend (
    input wire [15:0] imm_in,       // 16-bit immediate input
    input wire sign_ext_ctrl,       // 0 = zero extend, 1 = sign extend
    output wire [31:0] imm_out      // 32-bit extended output
);

    // Sign extension: replicate MSB or zero-fill
    assign imm_out = sign_ext_ctrl ? {{16{imm_in[15]}}, imm_in} : {16'h0000, imm_in};

endmodule