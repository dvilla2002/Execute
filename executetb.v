module executeTB();
	reg clk, rst;
	reg [1:0] wb;
	reg [2:0] mem;
	reg [3:0] execute;
	reg [31:0] npc, readdat1, readdat2, sign_ext;
	reg [4:0] instr_2016, instr_1511;
	wire [1:0] wb_out;
	wire branch, memread, memwrite;
	wire [31:0] addOUT;
	wire zero;
	wire [31:0] aluOUT, readdat2OUT;
	wire [4:0] mux5OUT;

    execute uut (
	    clk, rst, wb, mem, execute, npc, readdat1, readdat2,
	    sign_ext, instr_2016, instr_1511, wb_out, branch, memread,
	    memwrite, addOUT, zero, aluOUT, readdat2OUT, mux5OUT
            );
 initial begin
   $dumpfile("dump.vcd");
   $dumpvars(0, executeTB);
   end
    
    initial begin
        clk = 0;
        repeat (75)#5 clk = ~clk;
    end

    initial begin
	    wb = 2'b00;
	mem = 2'b00;
	npc = 32'd000;
	readdat1 = 32'd00;
	readdat2 = 32'd00;
	sign_ext = 32'd00;
	instr_2016 = 5'd0;
	instr_1511 = 5'd0;
	execute = 4'b0000;

	rst = 1;
	    #10;
	rst = 0;
	#15;
	wb = 2'b10;
	mem = 2'b01;
	npc = 32'd100;
	readdat1 = 32'd10;
	readdat2 = 32'd20;
	sign_ext = 32'd2080;
	instr_2016 = 5'd5;
	instr_1511 = 5'd10;
	execute = 4'b1011;

                #15;
	execute = 4'b0101;
	sign_ext = 32'd546;
	
    end
endmodule
