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
   wire [1:0]	 vsel_1, vsel_2, vsel_3, vsel_4, vsel_5;
   reg [1:0]	 ALUop;
   reg [1:0]	 shift_1, shift_2;
   wire [2:0]	 ReadB_1, ReadB_2;
   wire [2:0]	 ReadA_1, ReadA_2;
   wire [2:0]	 write_num_1, write_num_2, write_num_3, write_num_4, write_num_5;
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
   
   fetch_decode_register IFID_reg (.clk(clk),
                                   .reset(reset),
                                   .op_in(op_1),
                                   .opcode_in(opcode_1),
                                   .asel_in(asel_1),
                                   .bsel_in(bsel_1),
                                   .ReadA_in(ReadA_1),
                                   .ReadB_in(ReadB_1),
                                   .write_num_in(write_num_1),
                                   .shift_in(shift_1),
                                   .sximm8_in(sximm8_1),
                                   .sximm5_in(sximm5_1),
                                   .vsel_in(vsel_1),
                                   .ALUop_in(ALUop_1),
                                   .branch_en_in(branch_en_1),
                                   .opcode_out(opcode_2),
                                   .op_out(op_2), 
                                   .asel_out(asel_2), 
                                   .bsel_out(bsel_2), 
                                   .ReadA_out(ReadA_2), 
                                   .ReadB_out(ReadB_2), 
                                   .write_num_out(write_num_2), 
                                   .shift_out(shift_2), 
                                   .sximm8_out(sximm8_2), 
                                   .sximm5_out(sximm5_2), 
                                   .vsel_out(vsel_2), 
                                   .ALUop_out(ALUop_2), 
                                   .branch_en_out(branch_en_2));

   execute_memory_register EXMEM_reg (.ALU_in(ALU_3),
                                      .Z_in(Z_3),
                                      .B_in(B_3),
                                      .vsel_in(vsel_3),
                                      .write_num_in(write_num_3),
                                      .write_in(write_3),
                                      .ALU(ALU_4),
                                      .Z(Z_4),
                                      .B(B_4),
                                      .vsel(vsel_4),
                                      .write_num(write_num_4),
                                      .write(write_4),
                                      .clk(clk),
                                      .reset(reset));

   memory_writeback_register MEMWB_reg (.mem_in(mem_4),
                                        .ALU_in(ALU_4),
                                        .vsel_in(vsel_4),
                                        .write_num_in(write_num_4),
                                        .write_in(write_4),
                                        .mem_out(mem_5),
                                        .ALU(ALU_5),
                                        .vsel(vsel_5),
                                        .write_num(write_num_5),
                                        .write(write_5),
                                        .clk(clk),
                                        .reset(reset));
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