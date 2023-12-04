`define MWRITE 2'b00
`define MREAD 2'b01

// Memory mapped IO addresses
`define LEDR_base 9'h100
`define SW_base 9'h140

module lab7bonus_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,clk);
   input [3:0] KEY;
   input [9:0] SW;
   output [9:0]	LEDR;
   output [6:0]	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
   input clk;

   wire [1:0]	mem_cmd;
   wire [8:0]	mem_addr;
   wire [15:0]	read_data;
   wire [15:0]	write_data;

   wire		msel;
   assign msel = ~mem_addr[8];

   wire		write;
   assign write = ((mem_cmd == `MWRITE) & msel) ? 1'b1 : 1'b0;

   wire [15:0]	dout;
   assign read_data = ((mem_cmd == `MREAD) & msel) ? dout : {16{1'bz}};
   
   cpu CPU(.clk(clk), .reset(~KEY[1]), .mem_cmd(mem_cmd), .mem_addr(mem_addr), .read_data(read_data), .write_data(write_data), .halt(LEDR[8]));
   RAM #(16, 8, "data.txt") MEM (.clk(clk), .read_address(mem_addr[7:0]), .write_address(mem_addr[7:0]), .write(write), .din(write_data), .dout(dout));
   SW_controller sw_con (mem_cmd, mem_addr, read_data, SW[7:0]);
   LED_controller led_con (clk, mem_cmd, mem_addr, LEDR[7:0], write_data[7:0]);
endmodule

module LED_controller (clk, mem_cmd, mem_addr, LEDR, write_data);
   input clk;
   input [1:0] mem_cmd;
   input [8:0] mem_addr;
   input [7:0] write_data;
   output [7:0]	LEDR;

   wire		enable;

   assign enable = ((mem_cmd == `MWRITE) & (mem_addr == `LEDR_base)) ? 1'b1 : 1'b0;

   vDFFE #(8) LEDR_reg (.clk(clk), .en(enable), .in(write_data), .out(LEDR));
endmodule

module SW_controller (mem_cmd, mem_addr, read_data, SW);
   input [1:0] mem_cmd;
   input [8:0] mem_addr;
   input [7:0] SW;
   output [15:0] read_data;

   assign read_data = ((mem_cmd == `MREAD) & (mem_addr == `SW_base)) ? {{8{1'b0}}, SW} : {16{1'bz}};
endmodule
