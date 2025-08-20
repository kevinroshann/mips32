// mips_cpu.v - Top-Level Single-Cycle MIPS CPU
// Instantiates and connects all CPU modules

module mips_cpu (
    input wire clk,                 // Clock
    input wire rst                  // Reset
);

    // Internal wires
    wire [31:0] pc_out, next_pc;
    wire [31:0] instruction;
    wire [31:0] read_data1, read_data2, write_data;
    wire [31:0] alu_result, alu_input_b;
    wire [31:0] mem_read_data;
    wire [31:0] sign_extended;
    wire [31:0] pc_plus_4, branch_target, jump_target;
    wire [31:0] pc_branch_mux, pc_jump_mux;
    
    // Control signals
    wire [1:0] alu_op;
    wire [3:0] alu_ctrl;
    wire alu_src, reg_dst, branch, mem_read, mem_write;
    wire mem_to_reg, reg_write, jump, zero_flag;
    wire pc_src;
    
    // Instruction fields
    wire [5:0] opcode, funct;
    wire [4:0] rs, rt, rd, reg_write_addr;
    wire [15:0] immediate;
    wire [25:0] jump_addr;
    
    // Extract instruction fields
    assign opcode = instruction[31:26];
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];
    assign immediate = instruction[15:0];
    assign funct = instruction[5:0];
    assign jump_addr = instruction[25:0];
    
    // PC logic
    assign pc_plus_4 = pc_out + 4;
    assign branch_target = pc_plus_4 + (sign_extended << 2);
    assign jump_target = {pc_plus_4[31:28], jump_addr, 2'b00};
    assign pc_src = branch & zero_flag;
    
    // Program Counter
    pc pc_inst (
        .clk(clk),
        .rst(rst),
        .next_pc(next_pc),
        .pc_out(pc_out)
    );
    
    // PC source multiplexers
    mux2 #(32) pc_branch_mux_inst (
        .in0(pc_plus_4),
        .in1(branch_target),
        .sel(pc_src),
        .out(pc_branch_mux)
    );
    
    mux2 #(32) pc_jump_mux_inst (
        .in0(pc_branch_mux),
        .in1(jump_target),
        .sel(jump),
        .out(next_pc)
    );
    
    // Instruction Memory
    imem imem_inst (
        .addr(pc_out),
        .instruction(instruction)
    );
    
    // Register write address multiplexer
    mux2 #(5) reg_dst_mux (
        .in0(rt),
        .in1(rd),
        .sel(reg_dst),
        .out(reg_write_addr)
    );
    
    // Register File
    regfile regfile_inst (
        .clk(clk),
        .rs1(rs),
        .rs2(rt),
        .rd(reg_write_addr),
        .write_data(write_data),
        .reg_write_en(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    
    // Sign Extension
    sign_extend sign_ext_inst (
        .imm_in(immediate),
        .sign_ext_ctrl(1'b1),  // Always sign extend for this simple CPU
        .imm_out(sign_extended)
    );
    
    // ALU input B multiplexer
    mux2 #(32) alu_src_mux (
        .in0(read_data2),
        .in1(sign_extended),
        .sel(alu_src),
        .out(alu_input_b)
    );
    
    // Main Control Unit
    control control_inst (
        .opcode(opcode),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .reg_dst(reg_dst),
        .branch(branch),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write),
        .jump(jump)
    );
    
    // ALU Control Unit
    alu_control alu_ctrl_inst (
        .alu_op(alu_op),
        .funct(funct),
        .opcode(opcode),
        .alu_ctrl(alu_ctrl)
    );
    
    // ALU
    alu alu_inst (
        .a(read_data1),
        .b(alu_input_b),
        .alu_ctrl(alu_ctrl),
        .alu_result(alu_result),
        .zero_flag(zero_flag)
    );
    
    // Data Memory
    dmem dmem_inst (
        .clk(clk),
        .addr(alu_result),
        .write_data(read_data2),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(mem_read_data)
    );
    
    // Write data multiplexer (ALU result or memory data)
    mux2 #(32) mem_to_reg_mux (
        .in0(alu_result),
        .in1(mem_read_data),
        .sel(mem_to_reg),
        .out(write_data)
    );

endmodule