module execute_memory_register(ALU_in,Z_in,B_in,vsel_in,write_num_in,write_in,ALU,Z,B,vsel,write_num,write,clk,reset);
    input [15:0] ALU_in;
    input Z_in;
    input [15:0] B_in;
    input [1:0] vsel_in;
    input [2:0] write_num_in;
    input write_in;
    output [15:0] ALU;
    output Z;
    output [15:0] B;
    output [1:0] vsel;
    output [2:0] write_num;
    output write;
    input clk;
    input reset;

    reg [15:0] ALU;
    reg [15:0] Z;
    reg [15:0] B;
    reg [2:0] Rd;
    reg write;

    always @(posedge clk) begin
        if (reset) begin
            ALU = 16'b0;
            Z = 1'b0;
            B = 16'b0;
            write_num = 3'b0;
            write = 1'b0;
        end
        else begin
            ALU = ALU_in;
            Z = Z_in;
            B = B_in;
            write_num = write_num_in;
            write = write_in;
        end
    end
endmodule