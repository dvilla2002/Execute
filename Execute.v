`timescale 1ns / 1ps
/*
Execute Stage: This uses the outputs of Fetch and Decode Stages as well as combining the modules:
adder, bottom_mux(5-bit), alu_control, alu, top_mux (32-bit), and ex_mem.
*/
module EXECUTE(
    input  wire [1:0] wb_ctl,      // from ID/EX (WB control)
    input  wire [2:0] m_ctl,       // from ID/EX (MEM control)
    input  wire       regdst,      // from ID/EX EX control
    input  wire       alusrc,      // from ID/EX EX control
    input  wire [1:0] aluop,       // from ID/EX EX control
    input  wire [31:0] npcout, 
    input  wire [31:0] rdata1, 
    input  wire [31:0] rdata2, 
    input  wire [31:0] s_extendout,
    input  wire [4:0]  instrout_2016, 
    input  wire [4:0]  instrout_1511,

    output wire [1:0] wb_ctlout,   // to MEM/WB
    output wire       branch, 
    output wire       memread, 
    output wire       memwrite,
    output wire [31:0] EX_MEM_NPC,
    output wire        zero,
    output wire [31:0] alu_result, 
    output wire [31:0] rdata2out,
    output wire [4:0]  five_bit_muxout
);
    // internal wires
    wire [31:0] adder_out;
    wire [31:0] b;
    wire [31:0] aluout;
    wire [4:0]  muxout;
    wire [2:0]  control;
    wire        aluzero;

    adder adder3(
        .add_in1(npcout),
        .add_in2(s_extendout),
        .add_out(adder_out)
    );

    bottom_mux bottom_mux3(
        .a(instrout_1511),   // rd
        .b(instrout_2016),   // rt
        .sel(regdst),  
        .y(muxout)
    ); 

    alu_control alu_control3(
        .funct(s_extendout[5:0]),
        .aluop(aluop),
        .select(control)
    );

    alu alu3(
        .a(rdata1),
        .b(b), // b <= output of top_mux
        .control(control),
        .result(aluout),
        .zero(aluzero)
    );

    top_mux top_mux3(
        .y(b),           // output of mux is 32-bit "b" wire
        .a(s_extendout), // sign-extended immediate
        .b(rdata2),      // register operand
        .alusrc(alusrc)
    );

    ex_mem ex_mem3(
        .ctlwb_out(wb_ctl),      // inputs from ID/EX
        .ctlm_out(m_ctl),
        .adder_out(adder_out),
        .aluzero(aluzero),
        .aluout(aluout), 
        .readdat2(rdata2),
        .muxout(muxout), 

        .wb_ctlout(wb_ctlout),   // outputs to later stages
        .branch(branch), 
        .memread(memread), 
        .memwrite(memwrite), 
        .add_result(EX_MEM_NPC),
        .zero(zero),
        .alu_result(alu_result), 
        .rdata2out(rdata2out),
        .five_bit_muxout(five_bit_muxout)
    );
    
endmodule // EXECUTE
