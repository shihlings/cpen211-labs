module memory_writeback_register(mem_in,ALU_in,vsel_in,write_num_in,write_in,mem_out,ALU,vsel,write_num,write,clk,reset);
    input [15:0] mem_in;
    input [15:0] ALU_in;
    input [1:0] vsel_in;
    input [2:0] write_num_in;
    input write_in;
    output [15:0] mem_out;
    output [15:0] ALU;
    output [1:0] vsel;
    output [2:0] write_num;
    output write;
    input clk;
    input reset;

    reg [15:0] mem_out;
    reg [15:0] ALU;
    reg [2:0] Rd;
    reg write;

    always @(posedge clk) begin
        if (reset) begin
            mem_out = 16'b0;
            ALU = 16'b0;
            write_num = 3'b0;
            write = 1'b0;
        end
        else begin
            mem_out = mem_in;
            ALU = ALU_in;
            write_num = write_num_in;
            write = write_in;
        end
    end
endmodule