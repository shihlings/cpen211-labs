module ALU_tb ();
    // DUT inputs
    reg [15:0] Ain;
    reg [15:0] Bin;
    reg [1:0] ALUop;

    // DUT outputs
    wire [15:0] out;
    wire Z;

    // Error signal
    reg err;

    ALU DUT (Ain,Bin,ALUop,out,Z);

    initial begin
        //iverlog use only
        //$dumpfile("waveform.vcd");
        //$dumpvars(0, ALU_tb);
        
        err = 1'b0;
        
        // Addition - result 0
        Ain = 16'b0;
        Bin = 16'b0;
        ALUop = 2'b00;
        
        #1;
        
        if (out != 16'b0) begin
            err = 1'b1;
            $display("ERROR OUT - Expected %d, actual %d", 16'b0, out);
        end
        if (Z != 1'b1) begin
            err = 1'b1;
            $display("ERROR Z - Expected %d, actual %d", 1'b1, Z);
        end
        
        #1;
        
        // Addition - result non-zero
        Ain = 16'b1001;
        Bin = 16'b0010;
        ALUop = 2'b00;
        
        #1;
        
        if (out != 16'b1011) begin
            err = 1'b1;
            $display("ERROR OUT - Expected %d, actual %d", 16'b1011, out);
        end
        if (Z != 1'b0) begin
            err = 1'b1;
            $display("ERROR Z - Expected %d, actual %d", 1'b0, Z);
        end

        // Addition - result non-zero, with carry
        Ain = 16'b1111;
        Bin = 16'b0001;
        ALUop = 2'b00;
        
        #1;
        
        if (out != 16'b10000) begin
            err = 1'b1;
            $display("ERROR OUT - Expected %d, actual %d", 16'b1011, out);
        end
        if (Z != 1'b0) begin
            err = 1'b1;
            $display("ERROR Z - Expected %d, actual %d", 1'b0, Z);
        end

        #1;

        // Subtraction - result non-zero
        Ain = 16'b1001;
        Bin = 16'b0010;
        ALUop = 2'b01;
        
        #1;
        
        if (out != 16'b0111) begin
            err = 1'b1;
            $display("ERROR OUT - Expected %d, actual %d", 16'b0111, out);
        end
        if (Z != 1'b0) begin
            err = 1'b1;
            $display("ERROR Z - Expected %d, actual %d", 1'b0, Z);
        end

        #1;

        // Subtraction - result 0
        Ain = 16'b1101;
        Bin = 16'b1101;
        ALUop = 2'b01;
        
        #1;
        
        if (out != 16'b0) begin
            err = 1'b1;
            $display("ERROR OUT - Expected %d, actual %d", 16'b0, out);
        end
        if (Z != 1'b1) begin
            err = 1'b1;
            $display( "ERROR Z - Expected %d, actual %d", 1'b1, Z);
        end

        #1;

        // AND - result non-zero
        Ain = 16'b1001;
        Bin = 16'b0011;
        ALUop = 2'b10;
        
        #1;
        
        if (out != 16'b0001) begin
            err = 1'b1;
            $display("ERROR OUT - Expected %d, actual %d", 16'b0001, out);
        end
        if (Z != 1'b0) begin
            err = 1'b1;
            $display( "ERROR Z - Expected %d, actual %d", 1'b0, Z);
        end
        
        #1;
        
        // AND - result 0
        Ain = 16'b1111;
        Bin = 16'b0000;
        ALUop = 2'b10;
        
        #1;
        
        if (out != 16'b0) begin
            err = 1'b1;
            $display("ERROR OUT - Expected %d, actual %d", 16'b0, out);
        end
        if (Z != 1'b1) begin
            err = 1'b1;
            $display( "ERROR Z - Expected %d, actual %d", 1'b1, Z);
        end
        
        #1;

        // NOT - result non-zero
        Ain = 16'b1111;
        Bin = 16'b0110;
        ALUop = 2'b11;
        
        #1;
        
        if (out != 16'b1111_1111_1111_1001) begin
            err = 1'b1;
            $display("ERROR OUT - Expected %d, actual %d", 16'b1111_1111_1111_1001, out);
        end
        if (Z != 1'b0) begin
            err = 1'b1;
            $display( "ERROR Z - Expected %d, actual %d", 1'b0, Z);
        end

        #1;
        
        // NOT - result 0
        Ain = 16'b1111;
        Bin = 16'b1111_1111_1111_1111;
        ALUop = 2'b11;
        
        #1;
        
        if (out != 16'b0) begin
            err = 1'b1;
            $display("ERROR OUT - Expected %d, actual %d", 16'b0, out);
        end
        if (Z != 1'b1) begin
            err = 1'b1;
            $display( "ERROR Z - Expected %d, actual %d", 1'b1, Z);
        end

        if (err)
            $display("alu_tb - ERROR(S) FOUND!");
        else
            $display("alu_tb - TEST PASSED!");
        //$stop;
    end
endmodule
