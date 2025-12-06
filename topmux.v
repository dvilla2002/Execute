`timescale 1ns / 1ps
/*
32-bit mux used for ALUSrc.
Selects between register operand (rdata2) and sign-extended immediate.
*/
module top_mux(
    output wire [31:0] y,      // mux output to ALU input B
    input  wire [31:0] a,      // sign-extended immediate
    input  wire [31:0] b,      // register value (rdata2)
    input  wire        alusrc  // 1: use immediate, 0: use register
);
    assign y = alusrc ? a : b;
endmodule
