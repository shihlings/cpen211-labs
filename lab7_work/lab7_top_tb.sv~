module lab7_top_tb ();
   reg [3:0] KEY;
   reg [9:0] SW;
   reg [9:0] LEDR;
   wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
   reg	      err;

   lab7_top DUT (.KEY(KEY),.SW(SW),.LEDR(LEDR),.HEX0(HEX0),.HEX1(HEX1),.HEX2(HEX2),.HEX3(HEX3),.HEX4(HEX4),.HEX5(HEX5));

   initial forever begin
      KEY[0] = 0; #5;
      KEY[0] = 1; #5;
   end

   initial begin
      err = 1'b0;
      KEY[1] = 1'b0;

      #10;

      KEY[1] = 1'b1;

      #1; 
      if (lab7_top_tb.DUT.CPU.PC != 9'd0) begin
         $display("Program counter reset error");
         err = 1'b1;
      end

      @(posedge lab7_top_tb.DUT.CPU.PC or negedge lab7_top_tb.DUT.CPU.PC); // Wait until program counter changes
      
      #1;
      if (lab7_top_tb.DUT.CPU.PC != 9'd1) begin
         err = 1'b1;
         $display("FAILED: PC should be 1.");
      end
      
      @(posedge lab7_top_tb.DUT.CPU.PC or negedge lab7_top_tb.DUT.CPU.PC); // Wait until program counter changes
      
      #1;
      if (lab7_top_tb.DUT.CPU.PC != 9'd2) begin
         err = 1'b1;
         $display("FAILED: PC should be 2.");
      end

      // By now, R4 should be set
      if (lab7_top_tb.DUT.CPU.DP.REGFILE.R4 != 16'd100) begin
         err = 1'b1;
         $display("FAILED: R4 should be 100.");
      end
      
      @(posedge lab7_top_tb.DUT.CPU.PC or negedge lab7_top_tb.DUT.CPU.PC); // Wait until program counter changes
      
      #1;
      if (lab7_top_tb.DUT.CPU.PC != 9'd3) begin
         err = 1'b1;
         $display("FAILED: PC should be 3.");
      end

      if (lab7_top_tb.DUT.CPU.DP.REGFILE.R5 != 16'd200) begin
         err = 1'b1;
         $display("FAILED: R4 should be 200.");
      end

      #100; // Let many clock cycles pass
      
      if (lab7_top_tb.DUT.CPU.PC != 9'd3) begin
         err = 1'b1;
         $display("FAILED: PC should be 3. Program did not halt.");
      end
      
      if (err) begin
         $display("lab7_top_tb - ERRORS FOUND");
      end else begin
         $display("lab7_top_tb - PASSED");
      end
      $stop;
   end
endmodule
