// mux.v - Parametric Multiplexer Modules

// 2:1 Multiplexer
module mux2 #(parameter WIDTH = 32) (
    input wire [WIDTH-1:0] in0,     // Input 0
    input wire [WIDTH-1:0] in1,     // Input 1
    input wire sel,                 // Select signal
    output wire [WIDTH-1:0] out     // Output
);
    
    assign out = sel ? in1 : in0;
    
endmodule

// 3:1 Multiplexer
module mux3 #(parameter WIDTH = 32) (
    input wire [WIDTH-1:0] in0,     // Input 0
    input wire [WIDTH-1:0] in1,     // Input 1
    input wire [WIDTH-1:0] in2,     // Input 2
    input wire [1:0] sel,           // 2-bit select signal
    output reg [WIDTH-1:0] out      // Output
);
    
    always @(*) begin
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            default: out = in0;
        endcase
    end
    
endmodule

// 4:1 Multiplexer
module mux4 #(parameter WIDTH = 32) (
    input wire [WIDTH-1:0] in0,     // Input 0
    input wire [WIDTH-1:0] in1,     // Input 1
    input wire [WIDTH-1:0] in2,     // Input 2
    input wire [WIDTH-1:0] in3,     // Input 3
    input wire [1:0] sel,           // 2-bit select signal
    output reg [WIDTH-1:0] out      // Output
);
    
    always @(*) begin
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
        endcase
    end
    
endmodule