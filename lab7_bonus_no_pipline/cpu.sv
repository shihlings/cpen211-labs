// Common States
`define Reset 5'b00000
`define Decode 5'b00001
`define GetA 5'b00010
`define GetB 5'b00011
`define Add 5'b00100
`define WriteReg 5'b00101
`define WriteImm 5'b00110
`define ALUNoOp 5'b00111
`define CMP 5'b01000
`define BitwiseAND 5'b01001
`define BitwiseNOT 5'b01010
`define IF1 5'b01011
`define IF2 5'b01100
`define UpdatePC 5'b01101
`define Halt 5'b01110
`define WriteDataAddress 5'b01111
`define AddImm 5'b10000
`define RegFromMem 5'b10001
`define RegToMem 5'b10010
`define Delay 5'b10011
`define GetB_Rd 5'b10100
`define PCtoRn 5'b10101
`define RdtoPC 5'b10110
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

   reg		 loada, loadb, loadc, loads, asel, bsel, write;
   reg [1:0]	 vsel;
   reg [1:0]	 ALUop;
   reg [1:0]	 shift;
   reg [2:0]	 readnum;
   reg [2:0]	 writenum;
   reg [15:0]	 sximm5;
   reg [15:0]	 sximm8;
   wire		 reset_pc, load_pc, load_ir, load_addr;
   wire [8:0]	 PC;

   wire [2:0]	 Z_out;
   wire [15:0]	 instruction_reg_out;
   
   // Interface between decoder and state machine
   wire [1:0]	 nsel;
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
                .loada(loada),
                .loadb(loadb),
                .loadc(loadc),
                .loads(loads),
                .asel(asel), 
                .bsel(bsel), 
                .vsel(vsel),
                .write(write),
                .ALUop(ALUop),
                .shift(shift),
                .readnum(readnum),
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
                               .nsel(nsel),
                               .opcode(opcode),
                               .op(op),
                               .writenum(writenum),
                               .readnum(readnum),
                               .shift(shift),
                               .sximm8(sximm8),
                               .sximm5(sximm5),
                               .ALUop(ALUop),
                               .branch_en(branch_en),
                               .status(Z_out));
   
   state_machine controller (.reset(reset), 
                             .opcode(opcode), 
                             .op(op), 
                             .nsel(nsel), 
                             .loada(loada), 
                             .loadb(loadb),
                             .loadc(loadc), 
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
                             .allow_branch(allow_branch));
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
            default: next_pc = 9'bx;
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

module state_machine (clk, reset, opcode, op, nsel, loada, loadb, loadc, loads, asel, bsel, vsel, write, load_pc, load_ir, reset_pc, load_addr, addr_sel, mem_cmd, halt, allow_branch);
   input clk, reset;
   input [2:0] opcode;
   input [1:0] op;
   output reg [1:0] nsel;
   output reg	    asel, bsel, write, loada, loadb, loadc, loads, load_pc, load_ir, reset_pc, load_addr, addr_sel;
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
          {`IF1, {5{1'bx}}}: state = `IF2;
          {`IF2, {5{1'bx}}}: state = `UpdatePC;
          {`UpdatePC, {5{1'bx}}}: state = `Decode;
          {`Halt, `Halt_instruction, 2'b00}: state = `Halt;

          // Start instructions
          {`Decode, `Move_instruction, 2'b00}: state = `GetB;
          {`Decode, `Move_instruction, 2'b10}: state = `WriteImm;
          {`Decode, `ALU_instruction, 2'b00}: state = `GetA;
          {`Decode, `ALU_instruction, 2'b01}: state = `GetA;
          {`Decode, `ALU_instruction, 2'b10}: state = `GetA;
          {`Decode, `ALU_instruction, 2'b11}: state = `GetB;
          {`Decode, `Load_instruction, 2'b00}: state = `GetA;
          {`Decode, `Store_instruction, 2'b00}: state = `GetA;
          {`Decode, `Halt_instruction, 2'b00}: state = `Halt;
          {`Decode, `Branch_instruction, 2'b00}: state = `Branch;
          {`Decode, `Branch_link_instruction, 2'b11}: state = `PCtoRn;
          {`Decode, `Branch_link_instruction, 2'b00}: state = `GetB_Rd;
          {`Decode, `Branch_link_instruction, 2'b10}: state = `PCtoRn;
          
          // Add offset to address moved to A
          {`GetA, `Load_instruction, 2'b00}: state = `AddImm;
          {`GetA, `Store_instruction, 2'b00}: state = `AddImm;

          // Move other number to B in preparation for adding
          {`GetA, `ALU_instruction, 2'bxx}: state = `GetB;
          
          // Decide on what ALU operation to do
          {`GetB, `Move_instruction, 2'b00}: state = `ALUNoOp;
          {`GetB, `ALU_instruction, 2'b00}: state = `Add; 
          {`GetB, `ALU_instruction, 2'b01}: state = `CMP;
          {`GetB, `ALU_instruction, 2'b10}: state = `BitwiseAND;
          {`GetB, `ALU_instruction, 2'b11}: state = `BitwiseNOT;
          
          // Pas the value through the datapath
          {`GetB_Rd, `Store_instruction, 2'b00}: state = `ALUNoOp;
          {`GetB_Rd, `Branch_link_instruction, 2'bxx}: state = `ALUNoOp;
          
          // Stored the calculated address in the data address register
          {`AddImm, `Load_instruction, 2'b00}: state = `WriteDataAddress;
          {`AddImm, `Store_instruction, 2'b00}: state = `WriteDataAddress;

          // These operations feed back to the register file
          {`Add, {5{1'bx}}}: state = `WriteReg;
          {`BitwiseAND, {5{1'bx}}}: state = `WriteReg;
          {`BitwiseNOT, {5{1'bx}}}: state = `WriteReg;
          {`ALUNoOp, `Move_instruction, 2'bxx}: state = `WriteReg;
          {`ALUNoOp, `Branch_link_instruction, 2'bxx}: state = `RdtoPC;

          // Write the value to memory
          {`ALUNoOp, `Store_instruction, 2'b00}: state = `RegToMem;

          // Delay one cycle while waiting for RAM output, then write the register
          {`WriteDataAddress, `Load_instruction, 2'b00}: state = `Delay;
          {`Delay, `Load_instruction, 2'b00}: state = `RegFromMem;

          // Get the value to be stored in memory
          {`WriteDataAddress, `Store_instruction, 2'b00}: state = `GetB_Rd;
          
          // This only writes the status register
          {`CMP, {5{1'bx}}}: state = `IF1;

          // Go back to fetch after memory operation
          {`RegFromMem, `Load_instruction, 2'b00}: state = `IF1;
          {`RegToMem, `Store_instruction, 2'b00}: state = `IF1;
          
          // Once finished writing, always go back to fetch
          {`WriteReg, {5{1'bx}}}: state = `IF1;
          {`WriteImm, {5{1'bx}}}: state = `IF1;

          {`PCtoRn, `Branch_link_instruction, 2'b11}: state = `Branch;
          {`PCtoRn, `Branch_link_instruction, 2'b10}: state = `GetB_Rd;
          
          {`RdtoPC, `Branch_link_instruction, 2'bxx}: state = `IF1;
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
         {write, loada ,loadb, loadc, loads} = 5'b00000;
         load_pc = 1'b1;
	 load_ir = 1'b0;
         reset_pc = 1'b1;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b0;
         {nsel, asel, bsel, vsel} = 6'b000000;
         allow_branch = 1'b0;
      end
      else if (state == `IF1) begin
         {write, loada ,loadb, loadc, loads} = 5'b00000;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
         allow_branch = 1'b0;
      end
      else if (state == `IF2) begin
         {write, loada ,loadb, loadc, loads} = 5'b00000;
         load_pc = 1'b0;
	 load_ir = 1'b1;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
         allow_branch = 1'b0;
      end
      else if (state == `UpdatePC) begin
         {write, loada ,loadb, loadc, loads} = 5'b00000;
         load_pc = 1'b1;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
         allow_branch = 1'b0;
      end
      else if (state == `Decode) begin
         {write, loada ,loadb, loadc, loads} = 5'b00000;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
         allow_branch = 1'b0;
      end
      else if (state == `GetA) begin
         {write, loada ,loadb, loadc, loads} = 5'b01000;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b100000;  
         allow_branch = 1'b0;
      end
      else if (state == `GetB) begin
         {write, loada ,loadb, loadc, loads} = 5'b00100;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
         allow_branch = 1'b0;
      end
      else if (state == `Add) begin
         {write, loada ,loadb, loadc, loads} = 5'b00010;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
         allow_branch = 1'b0;
      end
      else if (state == `CMP) begin
         {write, loada ,loadb, loadc, loads} = 5'b00001;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
         allow_branch = 1'b0;
      end
      else if (state == `BitwiseAND) begin
         {write, loada ,loadb, loadc, loads} = 5'b00010;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
         allow_branch = 1'b0;
      end
      else if (state == `BitwiseNOT) begin
         {write, loada ,loadb, loadc, loads} = 5'b00010;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
         allow_branch = 1'b0;
      end
      else if (state == `ALUNoOp) begin
         {write, loada ,loadb, loadc, loads} = 5'b00010;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b001000;
         allow_branch = 1'b0;
      end
      else if (state == `WriteReg) begin
         {write, loada ,loadb, loadc, loads} = 5'b10000;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b010000;
         allow_branch = 1'b0;
      end
      else if (state == `WriteImm) begin
         {write, loada ,loadb, loadc, loads} = 5'b10000;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b0;
         {nsel, asel, bsel, vsel} = 6'b100010;
         allow_branch = 1'b0;
      end
      else if (state == `Halt) begin
         {write, loada ,loadb, loadc, loads} = 5'b00000;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b0;
         {nsel, asel, bsel, vsel} = 6'b000000;
         allow_branch = 1'b0;
      end
      else if (state == `WriteDataAddress) begin
         {write, loada ,loadb, loadc, loads} = 5'b00000;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b1;
         mem_cmd = `MREAD;
         addr_sel = 1'b0;
         {nsel, asel, bsel, vsel} = 6'b000000;
         allow_branch = 1'b0;
      end
      else if (state == `RegFromMem) begin
         {write, loada ,loadb, loadc, loads} = 5'b10000;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b0;
         {nsel, asel, bsel, vsel} = 6'b010011;
         allow_branch = 1'b0;
      end
      else if (state == `RegToMem) begin
         {write, loada ,loadb, loadc, loads} = 5'b00000;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MWRITE;
         addr_sel = 1'b0;
         {nsel, asel, bsel, vsel} = 6'b010000;
         allow_branch = 1'b0;
      end
      else if (state == `AddImm) begin
         {write, loada ,loadb, loadc, loads} = 5'b00010;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b0;
         {nsel, asel, bsel, vsel} = 6'b000100;
         allow_branch = 1'b0;
      end
      else if (state == `Delay) begin
         {write, loada ,loadb, loadc, loads} = 5'b00000;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b0;
         {nsel, asel, bsel, vsel} = 6'b000000;
         allow_branch = 1'b0;
      end
      else if (state == `GetB_Rd) begin
         {write, loada ,loadb, loadc, loads} = 5'b00100;
         load_pc = 1'b0;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b010000;
         allow_branch = 1'b0;
      end
      else if (state == `PCtoRn) begin
         {write, loada ,loadb, loadc, loads} = 5'b10000;
         load_pc = 1'b0;
	      load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b100001;
         allow_branch = 1'b0;
      end
      else if (state == `RdtoPC) begin
         {write, loada ,loadb, loadc, loads} = 5'b00000;
         load_pc = 1'b1;
	      load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b010000;
         allow_branch = 1'b1;
      end
      else if (state == `Branch) begin
         {write, loada ,loadb, loadc, loads} = 5'b00000;
         load_pc = 1'b1;
	 load_ir = 1'b0;
         reset_pc = 1'b0;
         load_addr = 1'b0;
         mem_cmd = `MREAD;
         addr_sel = 1'b1;
         {nsel, asel, bsel, vsel} = 6'b000000;
         allow_branch = 1'b1;
      end
      else begin // should not end up here
         {write, loada ,loadb, loadc, loads} = {5{1'bx}};
         load_pc = 1'bx;
	 load_ir = 1'bx;
         reset_pc = 1'bx;
         load_addr = 1'bx;
         mem_cmd = 2'bxx;
         addr_sel = 1'bx;
         {nsel, asel, bsel, vsel} = {6{1'bx}};
         allow_branch = 1'bx;
      end
   end
endmodule
