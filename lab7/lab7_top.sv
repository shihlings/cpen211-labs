`define MWRITE 2'b00
`define MREAD 2'b01

module lab7_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
    input [3:0] KEY;
    input [9:0] SW;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    wire [1:0] mem_cmd;
    wire [8:0] mem_addr;
    wire [15:0] read_data;
    wire [15:0] write_data;

    wire msel;
    assign msel = ~mem_addr[8];

    wire write;
    assign write = ((mem_cmd == `MWRITE) & msel) ? 1'b1 : 1'b0;

    wire [15:0] dout;
    assign read_data = ((mem_cmd == `MREAD) & msel) ? dout : {16{1'bz}};
    
    cpu CPU(.clk(~KEY[0]), .reset(~KEY[1]), .mem_cmd(mem_cmd), .mem_addr(mem_addr), .read_data(read_data), .write_data(write_data));
    RAM #(16, 8, "data.txt") MEM (.clk(~KEY[0]), .read_address(mem_addr[7:0]), .write_address(mem_addr[7:0]), .write(write), .din(write_data), .dout(dout));
    SW_controller sw_con (mem_cmd, mem_addr, read_data, SW[7:0]);
    LED_controller led_con (~KEY[0], mem_cmd, mem_addr, LEDR[7:0], write_data[7:0]);
endmodule


// RAM Module from slide set 11
module RAM(clk,read_address,write_address,write,din,dout);
  parameter data_width = 32; 
  parameter addr_width = 4;
  parameter filename = "data.txt";

  input clk;
  input [addr_width-1:0] read_address, write_address;
  input write;
  input [data_width-1:0] din;
  output [data_width-1:0] dout;
  reg [data_width-1:0] dout;

  reg [data_width-1:0] mem [2**addr_width-1:0];

  initial $readmemb(filename, mem);

  always @ (posedge clk) begin
    if (write)
      mem[write_address] <= din;
    dout <= mem[read_address]; // dout doesn't get din in this clock cycle 
                               // (this is due to Verilog non-blocking assignment "<=")
  end 
endmodule

// Memory mapped IO addresses
`define LEDR_base 9'h100
`define SW_base 9'h140

module LED_controller (clk, mem_cmd, mem_addr, LEDR, write_data);
  input clk;
  input [1:0] mem_cmd;
  input [8:0] mem_addr;
  input [7:0] write_data;
  output [7:0] LEDR;

  wire enable;

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