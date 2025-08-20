// imem_tb.v - Testbench for Instruction Memory

`timescale 1ns/1ps

module imem_tb;

    // Testbench signals
    reg [31:0] addr;
    wire [31:0] instruction;
    
    // Instantiate the instruction memory
    imem uut (
        .addr(addr),
        .instruction(instruction)
    );
    
    // Test vectors - expected instructions at each address
    reg [31:0] expected_instructions [0:8];
    
    initial begin
        // Initialize expected instructions
        expected_instructions[0] = 32'h2001000A;  // addi $1, $0, 10
        expected_instructions[1] = 32'h20020014;  // addi $2, $0, 20
        expected_instructions[2] = 32'h00221820;  // add $3, $1, $2
        expected_instructions[3] = 32'h00612022;  // sub $4, $3, $1
        expected_instructions[4] = 32'h00622824;  // and $5, $3, $2
        expected_instructions[5] = 32'h00853025;  // or $6, $4, $5
        expected_instructions[6] = 32'h0022382A;  // slt $7, $1, $2
        expected_instructions[7] = 32'h1022FFFF;  // beq $1, $2, -1
        expected_instructions[8] = 32'h08000000;  // j 0
        
        $display("Starting Instruction Memory Test");
        $display("=====================================");
        
        // Test sequential instruction fetching
        for (integer i = 0; i < 9; i = i + 1) begin
            addr = i * 4;  // Word addresses are multiples of 4
            #10;  // Wait for combinational delay
            
            if (instruction === expected_instructions[i]) begin
                $display("PASS: Address 0x%04X -> Instruction 0x%08X ✓", addr, instruction);
            end else begin
                $display("FAIL: Address 0x%04X -> Expected 0x%08X, Got 0x%08X ✗", 
                        addr, expected_instructions[i], instruction);
            end
        end
        
        $display("\n--- Testing Random Access ---");
        
        // Test random access patterns
        addr = 32'h00000008;  // Address 8 (3rd instruction)
        #10;
        if (instruction === 32'h00221820) begin
            $display("PASS: Random access to 0x0008 -> 0x%08X ✓", instruction);
        end else begin
            $display("FAIL: Random access to 0x0008 -> Expected 0x00221820, Got 0x%08X ✗", instruction);
        end
        
        addr = 32'h00000014;  // Address 20 (6th instruction)
        #10;
        if (instruction === 32'h00853025) begin
            $display("PASS: Random access to 0x0014 -> 0x%08X ✓", instruction);
        end else begin
            $display("FAIL: Random access to 0x0014 -> Expected 0x00853025, Got 0x%08X ✗", instruction);
        end
        
        // Test uninitialized memory (should return NOP)
        addr = 32'h00000100;  // Address 256 (uninitialized)
        #10;
        if (instruction === 32'h00000000) begin
            $display("PASS: Uninitialized memory -> NOP (0x00000000) ✓");
        end else begin
            $display("FAIL: Uninitialized memory -> Expected 0x00000000, Got 0x%08X ✗", instruction);
        end
        
        // Test edge cases
        $display("\n--- Testing Edge Cases ---");
        
        // Test maximum valid address within our memory size
        addr = 32'h00000FFC;  // Last word in 4KB memory (1023 * 4)
        #10;
        if (instruction === 32'h00000000) begin
            $display("PASS: Max address access -> 0x%08X ✓", instruction);
        end else begin
            $display("INFO: Max address access -> 0x%08X", instruction);
        end
        
        // Test word alignment (addresses should be multiples of 4)
        addr = 32'h00000001;  // Unaligned address
        #10;
        $display("INFO: Unaligned address 0x0001 -> 0x%08X (same as 0x0000)", instruction);
        
        addr = 32'h00000002;  // Unaligned address
        #10;
        $display("INFO: Unaligned address 0x0002 -> 0x%08X (same as 0x0000)", instruction);
        
        addr = 32'h00000003;  // Unaligned address
        #10;
        $display("INFO: Unaligned address 0x0003 -> 0x%08X (same as 0x0000)", instruction);
        
        $display("\n--- Instruction Decode Test ---");
        
        // Decode a few instructions to verify they're correct
        addr = 32'h00000000;  // First instruction: addi $1, $0, 10
        #10;
        $display("Instruction at 0x0000: 0x%08X", instruction);
        $display("  Opcode: %b (%d)", instruction[31:26], instruction[31:26]);
        $display("  RS: $%d", instruction[25:21]);
        $display("  RT: $%d", instruction[20:16]);
        $display("  Immediate: %d", $signed(instruction[15:0]));
        
        addr = 32'h00000008;  // Third instruction: add $3, $1, $2
        #10;
        $display("\nInstruction at 0x0008: 0x%08X", instruction);
        $display("  Opcode: %b (%d)", instruction[31:26], instruction[31:26]);
        $display("  RS: $%d", instruction[25:21]);
        $display("  RT: $%d", instruction[20:16]);
        $display("  RD: $%d", instruction[15:11]);
        $display("  Shamt: %d", instruction[10:6]);
        $display("  Funct: %b (%d)", instruction[5:0], instruction[5:0]);
        
        $display("\nInstruction Memory testbench completed!");
        $finish;
    end
    
    // Monitor address and instruction changes
    initial begin
        $monitor("Time=%0t, Address=0x%08X, Instruction=0x%08X", $time, addr, instruction);
    end

endmodule