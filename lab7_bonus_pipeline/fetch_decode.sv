module fetch_decode_register (clk, reset,
                              op_in, opcode_in, asel_in, bsel_in, ReadB_in, ReadA_in, write_num_in, shift_in, sximm8_in, sximm5_in, vsel_in, ALUop_in, branch_en_in,
                              opcode_out, op_out, asel_out, bsel_out, ReadA_out, ReadB_out, write_num_out, shift_out, sximm8_out, sximm5_out, vsel_out, ALUop_out, branch_en_out);
    input clk, reset;
    input [2:0] opcode_in;
    input [1:0] op_in;
    input asel_in;
    input bsel_in;
    input [2:0] ReadA_in;
    input [2:0] ReadB_in;
    input [2:0] write_num_in;
    input [1:0] shift_in;
    input [15:0] sximm8_in;
    input [15:0] sximm5_in;
    input [1:0] vsel_in;
    input ALUop_in;
    input branch_en_in;

    output reg [2:0] opcode_out;
    output reg [1:0] op_out;
    output reg asel_out;
    output reg bsel_out;
    output reg [2:0] ReadA_out;
    output reg [2:0] ReadB_out;
    output reg [2:0] write_num_out;
    output reg [1:0] shift_out;
    output reg [15:0] sximm8_out;
    output reg [15:0] sximm5_out;
    output reg [1:0] vsel_out;
    output reg ALUop_out;
    output reg branch_en_out;

    always_ff @(posedge clk) begin
        if (reset) begin
            opcode_out = 3'b000;
            op_out = 2'b00;
            asel_out = 1'b0;
            bsel_out = 1'b0;
            ReadA_out = 3'b000;
            ReadB_out = 3'b000;
            write_num_out = 3'b000;
            shift_out = 2'b00;
            sximm8_out = {15{1'b0}};
            sximm5_out = {15{1'b0}};
            vsel_out = 2'b00;
            ALUop_out = 2'b00;
            branch_en_out = 1'b0;
        end
        else begin
            opcode_out = opcode_in;
            op_out = op_in;
            asel_out = asel_in;
            bsel_out = bsel_in;
            ReadA_out = ReadA_in;
            ReadB_out = ReadB_in;
            write_num_out = write_num_in;
            shift_out = shift_in;
            sximm8_out = sximm8_in;
            sximm5_out = sximm5_in;
            vsel_out = vsel_in;
            ALUop_out = ALUop_in;
            branch_en_out = branch_en_in;
        end
    end
endmodule