`timescale 1ns / 1ps
/*
5-bit mux: selects destination register.
Inputs are instrout_1511 (rd), instrout_2016 (rt), and regdst.
Output muxout goes to EX/MEM latch.
*/
module bottom_mux(
    output wire [4:0] y,  // destination register
    input  wire [4:0] a,  // rd (instr[15:11])
    input  wire [4:0] b,  // rt (instr[20:16])
    input  wire       sel // RegDst
);
    assign y = sel ? a : b;
endmodule
