// Common States
`define Reset 5'b00000
`define Decode 5'b00001
// Formerly GetReg
// Formerly GetB
`define AddReg 5'b00100
// Formerly WriteReg
`define WriteImm 5'b00110
`define ALUNoOp_toReg 5'b00111
`define CMP 5'b01000
`define BitwiseAND 5'b01001
`define BitwiseNOT 5'b01010
`define IF1 5'b01011
`define UpdatePC 5'b01101
`define Halt 5'b01110
// Formerly WriteDataAddress
`define AddImm 5'b10000
`define RegFromMem 5'b10001
// Formerly RegToMem
`define ALUNoOp_RdToMem 5'b10011
//Formerly Delay
`define ALUNoOp_RdToPC 5'b10100
`define PCtoRn 5'b10101
`define IF1_fromLoad 5'b10110
// Formerly RdToPC
`define Branch 5'b10111

// Opcode macros
`define ALU_instruction 3'b101
`define Move_instruction 3'b110
`define Load_instruction 3'b011
`define Store_instruction 3'b100
`define Halt_instruction 3'b111
`define Branch_instruction 3'b001
`define Branch_link_instruction 3'b010

// Memory commands
`define MWRITE 2'b00
`define Halt_instruction 3'b111
`define MREAD 2'b01

module cpu(clk,reset, mem_cmd, mem_addr, read_data, write_data, halt);
   input clk, reset;

   output [1:0]	mem_cmd;
   output [8:0]	mem_addr;
   input [15:0]	read_data;
   output [15:0] write_data;
   output halt;

   reg		 loada, loadb, loads, asel, bsel, write;
   reg [1:0]	 vsel;
   reg [1:0]	 ALUop;
   reg [1:0]	 shift;
   wire [2:0]	 readA;
   wire [2:0]	 readB;
   wire [2:0]	 writenum;
   wire [2:0]	 Rn;
   wire [2:0]	 Rd;
   wire [2:0]	 Rm;
   reg [15:0]	 sximm5;
   reg [15:0]	 sximm8;
   wire		 reset_pc, load_pc, load_ir, load_addr;
   wire [8:0]	 PC;

   wire [2:0]	 Z_out;
   wire [15:0]	 instruction_reg_out;
   
   // Interface between decoder and state machine
   wire [2:0]	 opcode;
   wire [1:0]	 op;
   wire [1:0] branch_en;
   wire allow_branch;
   
   wire		 addr_sel;
   wire [8:0]	 data_addr;
   // Address select multiplexer
   assign mem_addr = addr_sel ? PC : data_addr;
   
   reg [8:0] PC_branch_addr_in;
   
   always_comb begin
      case (branch_en)
         2'b01: PC_branch_addr_in = sximm8[8:0];
         2'b10: PC_branch_addr_in = write_data[8:0];  
         default: PC_branch_addr_in = {9{1'bx}};
      endcase
   end

   datapath DP (.clk(clk),
                .loads(loads),
                .asel(asel), 
                .bsel(bsel), 
                .vsel(vsel),
                .write(write),
                .ALUop(ALUop),
                .shift(shift),
                .readA(readA),
                .readB(readB),
                .writenum(writenum),
                .PC(PC),
                .mdata(read_data), 
                .sximm5(sximm5),
                .sximm8(sximm8), 
                .datapath_out(write_data),
                .Z_out(Z_out));

   program_counter PC_reg (.clk(clk),
                           .load_pc(load_pc),
                           .reset_pc(reset_pc),
                           .PC(PC),
                           .branch_en(branch_en),
                           .PC_branch_addr_in(PC_branch_addr_in),
                           .allow_branch(allow_branch));

   data_address data_addr_reg (.clk(clk),
                               .load_addr(load_addr),
                               .in(write_data[8:0]),
                               .out(data_addr));

   instruction_register instruction_reg (.clk(clk),
                                         .load(load_ir),
                                         .in(read_data),
                                         .out(instruction_reg_out));

   instruction_decoder decode (.instruction(instruction_reg_out),
                               .opcode(opcode),
                               .op(op),
                               .Rn(Rn),
                               .Rd(Rd),
                               .Rm(Rm),
                               .shift(shift),
                               .sximm8(sximm8),
                               .sximm5(sximm5),
                               .ALUop(ALUop),
                               .branch_en(branch_en),
                               .status(Z_out));
   
   state_machine controller (.reset(reset), 
                             .opcode(opcode), 
                             .op(op), 
                             .loads(loads), 
                             .asel(asel), 
                             .bsel(bsel), 
                             .vsel(vsel),
                             .write(write),
                             .clk(clk),
                             .load_pc(load_pc),
			                    .load_ir(load_ir),
                             .reset_pc(reset_pc),
                             .load_addr(load_addr),
                             .addr_sel(addr_sel),
                             .mem_cmd(mem_cmd),
                             .halt(halt),
                             .allow_branch(allow_branch),
                             .readA(readA),
                             .readB(readB),
                             .writenum(writenum),
                             .Rn(Rn),
                             .Rd(Rd),
                             .Rm(Rm));
endmodule

module instruction_register (clk, load, in, out);
   input [15:0] in;
   input	load, clk;
   output [15:0] out;

   vDFFE #(16) instr_reg (clk, load, in, out);
endmodule

module program_counter (clk, load_pc, reset_pc, PC, branch_en, PC_branch_addr_in, allow_branch);
   output [8:0] PC;
   input	reset_pc;
   input allow_branch;
   input [1:0] branch_en;
   input [8:0] PC_branch_addr_in;
   input	load_pc, clk;
   reg [8:0] next_pc;

   always_comb begin
      if (reset_pc)
         next_pc = 9'b0;
      else begin
         casex ({allow_branch, branch_en})
            {1'b0, 2'bxx}: next_pc = PC + 9'b1;
            {1'b1, 2'b00}: next_pc = PC;
            {1'b1, 2'b01}: next_pc = PC + PC_branch_addr_in;
            {1'b1, 2'b10}: next_pc = PC_branch_addr_in;
            default: next_pc = {9{1'bx}};
         endcase
      end
   end
   vDFFE #(9) PC_DFF(clk, load_pc, next_pc, PC);
endmodule

module data_address (clk, load_addr, in, out);
   input [8:0]	 in;
   input	 load_addr, clk;
   output [8:0]	 out;
   
   vDFFE #(9) data_addr_DFF(clk, load_addr, in, out);
endmodule

module state_machine (clk, reset, opcode, op, Rn, Rd, Rm, readA, readB, writenum, loads, asel, bsel, vsel, write, load_pc, load_ir, reset_pc, load_addr, addr_sel, mem_cmd, halt, allow_branch);
   input clk, reset;
   input [2:0] opcode;
   input [1:0] op;
   input [2:0] Rn;
   input [2:0] Rd;
   input [2:0] Rm;
   output reg [2:0] readA;
   output reg [2:0] readB;
   output reg [2:0] writenum;
   output reg	    asel, bsel, write, loads, load_pc, load_ir, reset_pc, load_addr, addr_sel;
   output reg [1:0] vsel;
   output reg [1:0] mem_cmd;
   output reg halt;
   output reg allow_branch;
   
   reg [4:0]	    state;

   always_ff @(posedge clk) begin
      if (reset)
        state = `Reset;
      else
        casex ({state, opcode, op})
          {`Reset, {5{1'bx}}}: state = `IF1;
          {`IF1, {5{1'bx}}}: state = `UpdatePC;
	  {`IF1_fromLoad, {5{1'bx}}}: state = `UpdatePC;
          {`UpdatePC, {5{1'bx}}}: state = `Decode;
          {`Halt, `Halt_instruction, 2'b00}: state = `Halt;

          // Start instructions
          {`Decode, `Move_instruction, 2'b00}: state = `ALUNoOp_toReg;
          {`Decode, `Move_instruction, 2'b10}: state = `WriteImm;
          {`Decode, `ALU_instruction, 2'b00}: state = `AddReg;
          {`Decode, `ALU_instruction, 2'b01}: state = `CMP;
          {`Decode, `ALU_instruction, 2'b10}: state = `BitwiseAND;
          {`Decode, `ALU_instruction, 2'b11}: state = `BitwiseNOT;
          {`Decode, `Load_instruction, 2'b00}: state = `AddImm;
          {`Decode, `Store_instruction, 2'b00}: state = `AddImm;
          {`Decode, `Halt_instruction, 2'b00}: state = `Halt;
          {`Decode, `Branch_instruction, 2'b00}: state = `Branch;
          {`Decode, `Branch_link_instruction, 2'b11}: state = `PCtoRn;
          {`Decode, `Branch_link_instruction, 2'b00}: state = `ALUNoOp_RdToPC;
          {`Decode, `Branch_link_instruction, 2'b10}: state = `PCtoRn;
                    
          // Pas the value through the datapath
          //{`ALUNoOp_Rd, `Store_instruction, 2'b00}: state = `RegToMem;
          //{`ALUNoOp_Rd, `Branch_link_instruction, 2'bxx}: state = `RdtoPC;
          
          // Stored the calculated address in the data address register
          {`AddImm, `Load_instruction, 2'b00}: state = `RegFromMem;
          {`AddImm, `Store_instruction, 2'b00}: state = `ALUNoOp_RdToMem;

          {`ALUNoOp_RdToMem, `Store_instruction, 2'b00}: state = `IF1;

          {`ALUNoOp_RdToPC, `Branch_link_instruction, 2'b10}: state = `IF1;
          {`ALUNoOp_RdToPC, `Branch_link_instruction, 2'b00}: state = `IF1;

          // These operations feed back to the register file
          {`AddReg, {5{1'bx}}}: state = `IF1;
          {`BitwiseAND, {5{1'bx}}}: state = `IF1;
          {`BitwiseNOT, {5{1'bx}}}: state = `IF1;
          {`ALUNoOp_toReg, `Move_instruction, 2'bxx}: state = `IF1;
          //{`ALUNoOp, `Branch_link_instruction, 2'bxx}: state = `RdtoPC;

          // Write the value to memory
          //{`ALUNoOp, `Store_instruction, 2'b00}: state = `RegToMem;

          // Get the value to be stored in memory
          //{`WriteDataAddress, `Store_instruction, 2'b00}: state = `ALUNoOp_Rd;
          
          // This only writes the status register
          {`CMP, {5{1'bx}}}: state = `IF1;

          // Go back to fetch after memory operation
          {`RegFromMem, `Load_instruction, 2'b00}: state = `IF1_fromLoad;
          //{`RegToMem, `Store_instruction, 2'b00}: state = `IF1;
          
          // Once finished writing, always go back to fetch
          //{`WriteReg, {5{1'bx}}}: state = `IF1;
          {`WriteImm, {5{1'bx}}}: state = `IF1;

          {`PCtoRn, `Branch_link_instruction, 2'b11}: state = `Branch;
          {`PCtoRn, `Branch_link_instruction, 2'b10}: state = `ALUNoOp_RdToPC;
          
          //{`RdtoPC, `Branch_link_instruction, 2'bxx}: state = `IF1;
          {`Branch, {5{1'bx}}}: state = `IF1;

          // should not end up here
          default: state = {5{1'bx}};
        endcase
   end

   always_comb begin
      if (state == `Halt) begin
         halt = 1'b1;
      end
      else begin
         halt = 1'b0;
      end

      // Control outputs for each state
      if (state == `Reset) begin
         {write, loads} = 2'b00;
         load_pc = 1'b1;
	 load_ir = 1'bx;
         reset_pc = 1'b1;
         load_addr = 1'bx;
         mem_cmd = `MREAD;
         addr_sel = 1'bx;
         {asel, bsel, vsel} = 4'bxxxx;
         readA = 3'bxxx;
         readB = 3'bxxx;
         writenum = 3'bxxx;
         allow_branch = 1'b0;
      end
      else if (state == `IF1) begin
         {write, loads} = 2'b00;
         load_pc = 1'b0;
	 load_ir = 1'b1;
         reset_pc = 1'b0;
         load_addr = 1'bx;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {asel, bsel, vsel} = 4'bxxxx;
         readA = 3'bxxx;
         readB = 3'bxxx;
         writenum = 3'bxxx;
         allow_branch = 1'b0;
      end // if (state == `IF1)
      else if (state == `IF1_fromLoad) begin
         {write, loads} = 2'b10;
         load_pc = 1'b0;
	 load_ir = 1'b1;
         reset_pc = 1'b0;
         load_addr = 1'bx;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {asel, bsel, vsel} = 4'bxx11;
         readA = 3'bxxx;
         readB = 3'bxxx;
         writenum = Rd;
         allow_branch = 1'b0;
      end
      else if (state == `UpdatePC) begin
         {write, loads} = 2'b00;
         load_pc = 1'b1;
	 load_ir = 1'b1;
         reset_pc = 1'b0;
         load_addr = 1'bx;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {asel, bsel, vsel} = 4'bxxxx;
         readA = 3'bxxx;
         readB = 3'bxxx;
         writenum = 3'bxxx;
         allow_branch = 1'b0;
      end
      else if (state == `Decode) begin
         {write, loads} = 2'b00;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'bx;
         mem_cmd = `MREAD;
         addr_sel = 1'bx;
         {asel, bsel, vsel} = 4'bxxxx;
         readA = 3'bxxx;
         readB = 3'bxxx;
         writenum = 3'bxxx;
         allow_branch = 1'b0;
      end
      else if (state == `AddReg) begin
         {write, loads} = 2'b10;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'bx;
         mem_cmd = `MREAD;
         addr_sel = 1'bx;
         {asel, bsel, vsel} = 4'b0000;
         readA = Rn;
         readB = Rm;
         writenum = Rd;
         allow_branch = 1'b0;
      end
      else if (state == `CMP) begin
         {write, loads} = 2'b01;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'bx;
         mem_cmd = `MREAD;
         addr_sel = 1'bx;
         {asel, bsel, vsel} = 4'b0000;
         readA = Rn;
         readB = Rm;
         writenum = 3'bxxx;
         allow_branch = 1'b0;
      end
      else if (state == `BitwiseAND) begin
         {write, loads} = 2'b10;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'bx;
         mem_cmd = `MREAD;
         addr_sel = 1'bx;
         {asel, bsel, vsel} = 4'b0000;
         readA = Rn;
         readB = Rm;
         writenum = Rd;
         allow_branch = 1'b0;
      end
      else if (state == `BitwiseNOT) begin
         {write, loads} = 2'b10;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'bx;
         mem_cmd = `MREAD;
         addr_sel = 1'bx;
         {asel, bsel, vsel} = 4'b0000;
         readA = 3'bxxx;
         readB = Rm;
         writenum = Rd;
         allow_branch = 1'b0;
      end
      else if (state == `ALUNoOp_toReg) begin
         {write, loads} = 2'b10;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'bx;
         mem_cmd = `MREAD;
         addr_sel = 1'bx;
         {asel, bsel, vsel} = 4'b1000;
         readA = 3'bxxx;
         readB = Rm;
         writenum = Rd;
         allow_branch = 1'b0;
      end
      else if (state == `WriteImm) begin
         {write, loads} = 2'b10;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'bx;
         mem_cmd = `MREAD;
         addr_sel = 1'bx;
         {asel, bsel, vsel} = 4'bxx10;
         readA = 3'bxxx;
         readB = 3'bxxx;
         writenum = Rn;
         allow_branch = 1'b0;
      end
      else if (state == `Halt) begin
         {write, loads} = 2'b00;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'bx;
         mem_cmd = `MREAD;
         addr_sel = 1'bx;
         {asel, bsel, vsel} = 4'bxxxx;
         readA = 3'bxxx;
         readB = 3'bxxx;
         writenum = 3'bxxx;
         allow_branch = 1'b0;
      end
      else if (state == `RegFromMem) begin
         {write, loads} = 2'b10;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b0;
         {asel, bsel, vsel} = 4'bxx11;
         readA = 3'bxxx;
         readB = 3'bxxx;
         writenum = Rd;
         allow_branch = 1'b0;
      end
      else if (state == `AddImm) begin
         {write, loads} = 2'b00;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b1;
         mem_cmd = `MREAD;
         addr_sel = 1'b0;
         {asel, bsel, vsel} = 4'b01xx;
         readA = Rn;
         readB = 3'bxxx;
         writenum = 3'bxxx;
         allow_branch = 1'b0;
      end
      else if (state == `PCtoRn) begin
         {write, loads} = 2'b10;
         load_pc = 1'b0;
	      load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {asel, bsel, vsel} = 4'bxx01;
         readA = 3'bxxx;
         readB = 3'bxxx;
         writenum = Rn;
         allow_branch = 1'b0;
      end
      else if (state == `ALUNoOp_RdToPC) begin
         {write, loads} = 2'b00;
         load_pc = 1'b1;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'bx;
         mem_cmd = `MREAD;
         addr_sel = 1'bx;
         {asel, bsel, vsel} = 4'b10xx;
         readA = 3'bxxx;
         readB = Rd;
         writenum = 3'bxxx;
         allow_branch = 1'b1;
      end
      else if (state == `ALUNoOp_RdToMem) begin
         {write, loads} = 2'b00;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MWRITE;
         addr_sel = 1'b0;
         {asel, bsel, vsel} = 4'b10xx;
         readA = 3'bxxx;
         readB = Rd;
         writenum = 3'bxxx;
         allow_branch = 1'b1;
      end
      else if (state == `Branch) begin
         {write, loads} = 2'b00;
         load_pc = 1'b1;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {asel, bsel, vsel} = 4'bxxxx;
         readA = 3'bxxx;
         readB = 3'bxxx;
         writenum = 3'bxxx;
         allow_branch = 1'b1;
      end
      else begin // should not end up here
         {write, loads} = 2'bxx;
         load_pc = 1'bx;
	 load_ir = 1'bx;
         reset_pc = 1'bx;
         load_addr = 1'bx;
         mem_cmd = 2'bxx;
         addr_sel = 1'bx;
         {asel, bsel, vsel} = {6{1'bx}};
         readA = 3'bxxx;
         readB = 3'bxxx;
         writenum = 3'bxxx;
         allow_branch = 1'bx;
      end
   end
endmodule
