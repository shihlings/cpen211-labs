module shifter_tb ();
   reg [15:0] in;
   reg [1:0]  shift;
   
   wire [15:0] sout;

   reg	       err;

   shifter DUT (in,shift,sout);
   
   initial begin 
      // iverilog use only
      $dumpfile("waveform.vcd");
      $dumpvars(0, shifter_tb);
      
      err = 1'b0;

      in = 16'd1;
      shift = 2'b00;
      #1;
      if (sout != 16'd1) begin
         $display ("ERROR sout - Expected %b, actual %b", 16'd1, sout);
         err = 1'b1;
      end

      #1;

      in = 16'd1;
      shift = 2'b01;
      #1;
      if (sout != 16'd2) begin
         $display ("ERROR sout - Expected %b, actual %b", 16'd2, sout);
         err = 1'b1;
      end

      #1;

      in = 16'd1;
      shift = 2'b01;
      #1;
      if (sout != 16'd2) begin
         $display ("ERROR sout - Expected %b, actual %b", 16'd2, sout);
         err = 1'b1;
      end

      #1;

      in = 16'd1;
      shift = 2'b10;
      #1;
      if (sout != 16'd0) begin
         $display ("ERROR sout - Expected %b, actual %b", 16'd0, sout);
         err = 1'b1;
      end

      #1;

      in = 16'd1;
      shift = 2'b11;
      #1;
      if (sout != 16'd0) begin
         $display ("ERROR sout - Expected %b, actual %b", 16'd0, sout);
         err = 1'b1;
      end

      #1;
      
      in = 16'b1111000011001111;
      shift = 2'b00;
      #1;
      if (sout != 16'b1111000011001111) begin
         $display ("ERROR sout - Expected %b, actual %b", 16'b1111000011001111, sout);
         err = 1'b1;
      end

      #1;
      
      shift = 2'b01;
      #1;
      if (sout != 16'b1110000110011110) begin
         err = 1'b1;
         $display ("ERROR sout - Expected %b, actual %b", 16'b1110000110011110, sout);
      end
      
      #1;

      shift = 2'b10;
      #1;
      if (sout != 16'b0111100001100111) begin
         err = 1'b1;
         $display ("ERROR sout - Expected %b, actual %b", 16'b0111100001100111, sout);
      end

      #1;

      shift = 2'b11;
      #1;
      if (sout != 16'b1111100001100111) begin
         err = 1'b1;
         $display ("ERROR sout - Expected %b, actual %b", 16'b1111100001100111, sout);
      end

      if (err)
        $display("shifter_tb - ERROR(S) FOUND!");
      else
        $display("shifter_tb - TEST PASSED!");
      //$stop;
   end
endmodule
