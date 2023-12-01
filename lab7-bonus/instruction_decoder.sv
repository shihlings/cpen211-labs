// Opcode macros
`define ALU_instruction 3'b101
`define Move_instruction 3'b110
`define Load_instruction 3'b011
`define Store_instruction 3'b100
`define Halt_instruction 3'b111
`define Branch_instruction 3'b001
`define Branch_link_instruction 3'b010

// Condition macros
`define always 3'b000
`define equal 3'b001
`define not_equal 3'b010
`define less_than 3'b011
`define less_than_equal 3'b100

module instruction_decoder (instruction, opcode, op, nsel, writenum, readnum, shift, sximm8, sximm5, ALUop, branch_en, status);
   input [15:0] instruction;
   input [1:0]	nsel;
   input [2:0] status;
   output [2:0]	opcode;
   output [1:0]	op;
   output [2:0]	writenum;
   output [2:0]	readnum;
   output reg [1:0]	shift;
   output [15:0] sximm8;
   output [15:0] sximm5;
   output reg [1:0]	 ALUop;
   output reg [1:0] branch_en;

   wire [4:0]	 imm5;
   wire [7:0]	 imm8;

   wire [2:0] cond;
   
   wire [2:0]	 Rn;
   wire [2:0]	 Rd;
   wire [2:0]	 Rm;

   reg [2:0]	 reg_mux_out;
   assign writenum = reg_mux_out;
   assign readnum = reg_mux_out;

   assign opcode = instruction[15:13];
   assign op = instruction[12:11];

   assign Rn = instruction[10:8];
   assign Rd = instruction[7:5];
   assign Rm = instruction[2:0];

   assign imm5 = instruction[4:0];
   assign imm8 = instruction[7:0];

   assign cond = instruction[10:8];

   assign sximm5 = {{11{imm5[4]}}, imm5};
   assign sximm8 = {{8{imm8[7]}}, imm8};

   always_comb begin
      case (nsel)
        2'b00: reg_mux_out = Rm;
        2'b01: reg_mux_out = Rd;
        2'b10: reg_mux_out = Rn;
        default: reg_mux_out = 3'bxxx;
      endcase

      case (opcode)
         `ALU_instruction: shift = instruction[4:3];
         `Move_instruction: shift = instruction[4:3];
         default: shift = 2'b00;
      endcase

      if (opcode == `ALU_instruction)
         ALUop = op;
      else
         ALUop = 2'b00;

      casex ({opcode, op, cond})
        {`Branch_instruction, 2'bxx, `always}: branch_en = 2'b01;
        {`Branch_instruction, 2'bxx, `equal}: branch_en = status[0] ? 2'b01 : 2'b00;
        {`Branch_instruction, 2'bxx,  `not_equal}: branch_en = status[0] ? 2'b00 : 2'b01;
        {`Branch_instruction, 2'bxx,  `less_than}: branch_en = (status[1] != status[2]) ? 2'b01 : 2'b00;
        {`Branch_instruction, 2'bxx,  `less_than_equal}: branch_en = ((status[1] != status[2]) | status[0]) ? 2'b01 : 2'b00;
        {`Branch_link_instruction, 2'b11, 3'bxxx}: branch_en = 2'b01;
        {`Branch_link_instruction, 2'b00, 3'bxxx}: branch_en = 2'b10;
        {`Branch_link_instruction, 2'b10, 3'bxxx}: branch_en = 2'b10;
        default: branch_en = 2'b00;
      endcase
   end
endmodule