module datapath_tb ();
   reg err, clk, loada, loadb, loadc, loads, asel, bsel, vsel, write;
   reg [1:0] ALUop;
   reg [1:0] shift;
   reg [2:0] readnum;
   reg [2:0] writenum;
   reg [15:0] datapath_in;
   wire [15:0] datapath_out;
   wire	       Z_out;

   datapath DUT (clk, loada, loadb, loadc, loads, asel, bsel, vsel, write, ALUop, shift, readnum, writenum, datapath_in, datapath_out, Z_out);
   
   initial begin
      // iverilog use only
      $dumpfile("waveform.vcd");
      $dumpvars(0, datapath_tb);
      
      // reset everything to 0
      err = 1'b0;
      clk = 1'b0;
      loada = 1'b0;
      loadb = 1'b0;
      loadc = 1'b0;
      loads = 1'b0;
      asel = 1'b0;
      bsel = 1'b0;
      vsel = 1'b0;
      write = 1'b0;
      ALUop = 2'b00;
      shift = 2'b00;
      readnum = 3'b000;
      writenum = 3'b000;
      datapath_in = 16'b0;
      #1;

      /* ---------- <Video test case> ---------- */
      // mov R3, #42
      vsel = 1'b1;
      datapath_in = 16'd42;
      write = 1'b1;
      writenum = 3'b011;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      write = 1'b0;
      vsel = 1'b0;
      if (datapath_tb.DUT.REGFILE.R3 != 16'd42) begin
         err = 1'b1;
         $display("Error R3 - expected %h, actual %h", 16'd42, datapath_tb.DUT.REGFILE.R3);
      end

      // mov R5, #13
      vsel = 1'b1;
      datapath_in = 16'd13;
      write = 1'b1;
      writenum = 3'b101;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      write = 1'b0;
      vsel = 1'b0;
      if (datapath_tb.DUT.REGFILE.R5 != 16'd13) begin
         err = 1'b1;
         $display("Error R5 - expected %h, actual %h", 16'd13, datapath_tb.DUT.REGFILE.R5);
      end

      // move R3 to A
      readnum = 3'b011;
      loada = 1'b1;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      loada = 1'b0;
      if (datapath_tb.DUT.A != datapath_tb.DUT.REGFILE.R3) begin
         err = 1'b1;
         $display("Error A - expected %h, actual %h", datapath_tb.DUT.REGFILE.R5, datapath_tb.DUT.A);
      end

      // move R5 to B
      readnum = 3'b101;
      loadb = 1'b1;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      loadb = 1'b0;
      if (datapath_tb.DUT.B != datapath_tb.DUT.REGFILE.R5) begin
         err = 1'b1;
         $display("Error B - expected %h, actual %h", datapath_tb.DUT.REGFILE.R5, datapath_tb.DUT.B);
      end
      
      // add R2, R5, R3
      asel = 1'b0;
      bsel = 1'b0;
      ALUop = 2'b00;
      loadc = 1'b1;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      loadc = 1'b0;
      vsel = 1'b0;
      write = 1'b1;
      writenum = 3'b010;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      write = 1'b0;
      writenum = 3'b0;
      if (datapath_tb.DUT.REGFILE.R2 != datapath_tb.DUT.REGFILE.R3 + datapath_tb.DUT.REGFILE.R5) begin
         err = 1'b1;
         $display("Error R2 - expected %h, actual %h", datapath_tb.DUT.REGFILE.R3 + datapath_tb.DUT.REGFILE.R5, datapath_tb.DUT.REGFILE.R2);
      end

      // mov R7, R3
      readnum = 3'b011;
      loadb = 1'b1;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1; 
      loadb = 1'b0;
      asel = 1'b1;
      bsel = 1'b0;
      ALUop = 2'b00;
      loadc = 1'b1;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      asel = 1'b0;
      bsel = 1'b0;
      loadc = 1'b0;
      vsel = 1'b0;
      write = 1'b1;
      writenum = 3'b111;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      write = 1'b0;
      writenum = 3'b0;
      if (datapath_tb.DUT.REGFILE.R7 != datapath_tb.DUT.REGFILE.R3) begin
         err = 1'b1;
         $display("Error R7 - expected %h, actual %h", datapath_tb.DUT.REGFILE.R3, datapath_tb.DUT.REGFILE.R7);
      end
      /* ---------- </Video test Case> ---------- */
      
      // test shifter 01
      shift = 2'b01;
      #1;
      if (datapath_tb.DUT.sout != datapath_tb.DUT.B << 1) begin
         err = 1'b1;
         $display("Error sout - expected %h, actual %h", datapath_tb.DUT.B << 1, datapath_tb.DUT.sout);
      end

      // test shifter 10, MSB = 0
      shift = 2'b10;
      #1;
      if (datapath_tb.DUT.sout != {1'b0, datapath_tb.DUT.B[15:1]}) begin
         err = 1'b1;
         $display("Error sout - expected %b, actual %b", {1'b0, datapath_tb.DUT.B[15:1]}, datapath_tb.DUT.sout);
      end

      // test shifter 11, MSB = 0
      shift = 2'b11;
      #1;
      if (datapath_tb.DUT.sout != {datapath_tb.DUT.B[15], datapath_tb.DUT.B[15:1]}) begin
         err = 1'b1;
         $display("Error sout - expected %b, actual %b", {datapath_tb.DUT.B[15], datapath_tb.DUT.B[15:1]}, datapath_tb.DUT.sout);
      end

      // test shifter 10, MSB = 1
      force datapath_tb.DUT.B = {1'b1, 15'b0};
      shift = 2'b10;
      #1;
      if (datapath_tb.DUT.sout != {1'b0, datapath_tb.DUT.B[15:1]}) begin
         err = 1'b1;
         $display("Error sout - expected %b, actual %b", {1'b0, datapath_tb.DUT.B[15:1]}, datapath_tb.DUT.sout);
      end
      
      // test shifter 11, MSB = 1
      shift = 2'b11;
      #1;
      if (datapath_tb.DUT.sout != {2'b11, 14'b0}) begin
         err = 1'b1;
         $display("Error sout - expected %h, actual %h", {2'b11, 4'b0}, datapath_tb.DUT.sout);
      end
      release datapath_tb.DUT.B;
      
      // test bsel 1, datapath_in [15:5] = 0
      bsel = 1'b1;
      #1;
      if (datapath_tb.DUT.Bin != {11'b0, datapath_in[4:0]}) begin
         err = 1'b1;
         $display("Error Bin - expected %h, actual %h", {11'b0, datapath_in[4:0]}, datapath_tb.DUT.Bin);
      end

      // test bsel 1, datapath_in [15:5] = 1
      datapath_in = 16'b1111_1111_1110_1010;
      vsel = 1'b1;
      #1;
      if (datapath_tb.DUT.Bin != {11'b0, datapath_in[4:0]}) begin
         err = 1'b1;
         $display("Error Bin - expected %h, actual %h", {11'b0, datapath_in[4:0]}, datapath_tb.DUT.Bin);
      end
      datapath_in = 16'b0;
      vsel = 1'b0;
      bsel = 1'b0;
      
      // test ALU 01 and status reg
      force datapath_tb.DUT.Ain = 16'b0001_1001_1010_0010;
      force datapath_tb.DUT.Bin = 16'b1100_0100_0101_1111;
      ALUop = 2'b01;
      loads = 1'b1;
      #1;
      if (datapath_tb.DUT.out != 16'b0101_0101_0100_0011) begin
	 err = 1'b1;
	 $display("Error ALU - expected %h, actual %h", 16'b0101_0101_0100_0011, datapath_tb.DUT.out);
      end
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      if (Z_out != 1'b0) begin
	 err = 1'b1;
	 $display("Error Z_out - expected %b, actual %b", 1'b0, Z_out);
      end
      
      // test ALU 10
      force datapath_tb.DUT.Ain = 16'b0001_1001_1010_0010;
      force datapath_tb.DUT.Bin = 16'b1100_0100_0101_1101;
      ALUop = 2'b10;
      loads = 1'b1;
      #1;
      if (datapath_tb.DUT.out != 16'b0) begin
	 err = 1'b1;
	 $display("Error ALU - expected %h, actual %h", 16'b0, datapath_tb.DUT.out);
      end
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      if (Z_out != 1'b1) begin
	 err = 1'b1;
	 $display("Error Z_out - expected %b, actual %b", 1'b1, Z_out);
      end
      
      // test ALU 11
      force datapath_tb.DUT.Ain = 16'b0001_1001_1010_0010;
      force datapath_tb.DUT.Bin = 16'b1100_0100_0101_1111;
      ALUop = 2'b11;
      loads = 1'b1;
      #1;
      if (datapath_tb.DUT.out != 16'b0011_1011_1010_0000) begin
	 err = 1'b1;
	 $display("Error ALU - expected %h, actual %h", 16'b0011_1011_1010_0000, datapath_tb.DUT.out);
      end
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      if (Z_out != 1'b0) begin
	 err = 1'b1;
	 $display("Error Z_out - expected %b, actual %b", 1'b0, Z_out);
      end

      release datapath_tb.DUT.Ain;
      release datapath_tb.DUT.Bin;

      /* ------------- <Instruction Sequence Test 2> -------------
       mov R6, #11121
       mov R0, #65515
       mvn R1, R0
       sub R4, R1, lsr #1
      */
      
      // mov R6, #11121
      vsel = 1'b1;
      datapath_in = 16'd11121;
      write = 1'b1;
      writenum = 3'b110;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      write = 1'b0;
      vsel = 1'b0;
      if (datapath_tb.DUT.REGFILE.R6 != 16'd11121) begin
         err = 1'b1;
         $display("Error R6 - expected %h, actual %h", 16'd11121, datapath_tb.DUT.REGFILE.R6);
      end

      // mov R0, #65515
      vsel = 1'b1;
      datapath_in = 16'd65515;
      write = 1'b1;
      writenum = 3'b000;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      write = 1'b0;
      vsel = 1'b0;
      if (datapath_tb.DUT.REGFILE.R0 != 16'd65515) begin
         err = 1'b1;
         $display("Error R0 - expected %h, actual %h", 16'd65515, datapath_tb.DUT.REGFILE.R0);
      end

      // move R0 to B
      readnum = 3'b000;
      loadb = 1'b1;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      loadb = 1'b0;
      if (datapath_tb.DUT.B != datapath_tb.DUT.REGFILE.R0) begin
         err = 1'b1;
         $display("Error B - expected %h, actual %h", datapath_tb.DUT.REGFILE.R0, datapath_tb.DUT.B);
      end

      // ALU ~B -> C
      shift = 2'b00;
      bsel = 1'b0;
      ALUop = 2'b11;
      loadc = 1'b1;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      loadc = 1'b0;
      if (datapath_tb.DUT.C != 16'd20) begin
	 err = 1'b1;
	 $display("Error C - expected %h, actual %h", 16'd20, datapath_tb.DUT.C);
      end

      // Store C in R1
      vsel = 1'b0;
      writenum = 3'b001;
      write = 1'b1;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      write = 1'b0;
      if (datapath_tb.DUT.REGFILE.R1 != 16'd20) begin
	 err = 1'b1;
	 $display("Error R1 - expected %h, actual %h", 16'd20, datapath_tb.DUT.REGFILE.R1);
      end

      // Move R6 to A
      readnum = 3'b110;
      loada = 1'b1;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      loada = 1'b0;
      if (datapath_tb.DUT.A != datapath_tb.DUT.REGFILE.R6) begin
         err = 1'b1;
         $display("Error A - expected %h, actual %h", 16'd11121, datapath_tb.DUT.A);
      end

      // Move R1 to B
      readnum = 3'b001;
      loadb = 1'b1;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      loadb = 1'b0;
      if (datapath_tb.DUT.B != datapath_tb.DUT.REGFILE.R1) begin
         err = 1'b1;
         $display("Error B - expected %h, actual %h", 16'd20, datapath_tb.DUT.B);
      end

      // A - B/2 -> C
      ALUop = 2'b01;
      asel = 1'b0;
      bsel = 1'b0;
      shift = 2'b10;
      loadc = 1'b1;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      loadc = 1'b0;
      if (datapath_tb.DUT.C != 16'd11111) begin
	 err = 1'b1;
	 $display("Error C - expected %h, actual %h", 16'd11111, datapath_tb.DUT.C);
      end

      // Store C in R4
      vsel = 1'b0;
      writenum = 3'b100;
      write = 1'b1;
      #1;
      clk = 1'b1;
      #1;
      clk = 1'b0;
      #1;
      write = 1'b0;
      if (datapath_tb.DUT.REGFILE.R4 != 16'd11111) begin
	 err = 1'b1;
	 $display("Error R4 - expected %h, actual %h", 16'd11111, datapath_tb.DUT.REGFILE.R4);
      end
      /* ------------- </Instruction Sequence Test 2> ------------- */
      
      // Check for error
      if (err) begin
         $display("datapath_tb - ERROR(S) FOUND!");
      end else begin
         $display("datapath_tb - TEST PASSED!");
      end
      $stop;
   end
endmodule
