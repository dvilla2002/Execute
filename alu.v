`timescale 1ns / 1ps
/*
ALU: takes in rdata1 and "b" (from top_mux).
Outputs result (aluout) and zero (aluzero).
*/
module alu(
    input  wire [31:0] a,       // source from register
    input  wire [31:0] b,       // target from register or immediate
    input  wire [2:0]  control, // select from alu_control
    output reg  [31:0] result,  // to MEM/Data memory and MEM/WB latch
    output wire        zero     // to MEM/branch
);
    // ALU control encoding
    parameter ALUadd = 3'b010,
              ALUsub = 3'b110,
              ALUand = 3'b000,     
              ALUor  = 3'b001,
              ALUslt = 3'b111;

    // Handles negative inputs (signed comparison logic)
    wire sign_mismatch;
    assign sign_mismatch = a[31] ^ b[31]; // 1 if signs differ

    initial
        result <= 0;

    always @* begin
        case (control)
            ALUadd: result = a + b;
            ALUsub: result = a - b;
            ALUand: result = a & b;
            ALUor:  result = a | b;
            ALUslt: result = (a < b) ? (32'd1 - sign_mismatch)  // your custom SLT logic
                                     : (32'd0 + sign_mismatch);
            default: result = 32'bX; // for ALUx or undefined
        endcase
    end

    // zero flag
    assign zero = (result == 32'd0) ? 1'b1 : 1'b0;
endmodule
