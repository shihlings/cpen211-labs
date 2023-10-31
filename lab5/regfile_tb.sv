module regfile_tb ();
    reg [15:0] data_in;
    reg [2:0] writenum, readnum;
    reg write, clk;
    wire [15:0] data_out;

    regfile DUT (data_in,writenum,write,readnum,clk,data_out);
    
endmodule