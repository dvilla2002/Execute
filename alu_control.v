`timescale 1ns / 1ps
/*
Takes in 6 bits of funct with aluop and outputs select, which is the control
for alu.v. This bridges machine language with ALU operations.
*/
module alu_control(
    input  wire [5:0] funct,  // from ID/EX latch (R-type funct field)
    input  wire [1:0] aluop,
    output reg  [2:0] select
);
    // ALUOp encodings
    parameter Rtype  = 2'b10; // R-type
    parameter lwsw   = 2'b00; // lw, sw
    parameter Itype  = 2'b01; // beq/branch
    parameter unknown = 2'b11;

    // ALU Control Outputs
    parameter ALUadd = 3'b010,
              ALUsub = 3'b110,
              ALUand = 3'b000,
              ALUor  = 3'b001,
              ALUslt = 3'b111,
              ALUx   = 3'b011; // for invalid

    // Funct field values (R-type)
    parameter FUNCTadd = 6'b100000,
              FUNCTsub = 6'b100010,
              FUNCTand = 6'b100100,
              FUNCTor  = 6'b100101,
              FUNCTslt = 6'b101010;

    initial
        select <= 0;

    always @* begin
        if (aluop == Rtype) begin
            case (funct)
                FUNCTadd: select <= ALUadd;
                FUNCTsub: select <= ALUsub;
                FUNCTand: select <= ALUand;
                FUNCTor:  select <= ALUor;
                FUNCTslt: select <= ALUslt;
                default:  select <= ALUx;
            endcase
        end
        else if (aluop == lwsw) begin
            select <= ALUadd; // lw/sw: base + offset
        end
        else if (aluop == Itype) begin
            select <= ALUsub; // beq: subtract and check zero
        end
        else if (aluop == unknown) begin
            select <= ALUx;
        end
        else begin
            select <= ALUx;
        end
    end
endmodule
