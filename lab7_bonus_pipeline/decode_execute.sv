module decode_execute_register (A_in,B_in,sximm5_in,sximm8_in,vsel_in,write_num_in,write_in,A_out,B_out,sximm5,sximm8,vsel,write_num,write,clk,reset);
    input [15:0] A_in;
    input [15:0] B_in;
    input [15:0] sximm5_in;
    input [15:0] sximm8_in;
    input [1:0] vsel_in;
    input [2:0] write_num_in;
    input write_in;
    output [15:0] A_out;
    output [15:0] B_out;
    output [15:0] sximm5;
    output [15:0] sximm8;
    output [1:0] vsel;
    output [2:0] write_num;
    output write;
    input clk;
    input reset;

    reg [15:0] A_out;
    reg [15:0] B_out;
    reg [4:0] sximm5;
    reg [7:0] sximm8;
    reg [2:0] Rd;
    reg write;

    always @(posedge clk) begin
        if (reset) begin
            A_out = 16'b0;
            B_out = 16'b0;
            sximm5 = 5'b0;
            sximm8 = 8'b0;
            write_num = 3'b0;
            write = 1'b0;
        end
        else begin
            A_out = A_in;
            B_out = B_in;
            sximm5 = sximm5_in;
            sximm8 = sximm8_in;
            write_num = write_num_in;
            write = write_in;
        end
    end
endmodule