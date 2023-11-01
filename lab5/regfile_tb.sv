module regfile_tb ();
   reg [15:0]  data_in;
   reg [15:0]  test_value;
   reg [2:0]   writenum, readnum;
   reg	       write, clk, err;
   wire [15:0] data_out;

   regfile DUT (data_in, writenum, write, readnum, clk, data_out);

   initial begin
      repeat(120) begin
	 clk = 1'b0;
	 #1;
	 clk = 1'b1;
	 #1;
	 clk = 1'b0;
      end
   end

   task write_registers;
      input [15:0] value;
      begin
	 // set value and enable writing to registers
	 data_in = value;
	 write = 1'b1;
	 writenum = 3'b0;

	 // iterate through all registers
	 repeat(8) begin
	    #2;
	    
		data_in = data_in + 16'b1;
	    writenum += 3'b001; // Increment to write a different value to each register
	 end

	 if(regfile_tb.DUT.R0 != value) begin
	    err = 1'b1;
	    $display("ERROR-R0 WRITE,     value incorrect, expected %b, actual %b", value, regfile_tb.DUT.R0);
	 end
	 
	 if(regfile_tb.DUT.R1 != value + 16'd1) begin
	    err = 1'b1;
	    $display("ERROR-R1 WRITE,     value incorrect, expected %b, actual %b", value + 1, regfile_tb.DUT.R1);
	 end
	 	
	 if(regfile_tb.DUT.R2 != value + 16'd2) begin
	    err = 1'b1;
	    $display("ERROR-R2 WRITE,     value incorrect, expected %b, actual %b", value + 2, regfile_tb.DUT.R2);
	 end
	 
	 if(regfile_tb.DUT.R3 != value + 16'd3) begin
	    err = 1'b1;
	    $display("ERROR-R3 WRITE,     value incorrect, expected %b, actual %b", value + 3, regfile_tb.DUT.R3);
	 end
	 
	 if(regfile_tb.DUT.R4 != value + 16'd4) begin
	    err = 1'b1;
	    $display("ERROR-R4 WRITE,     value incorrect, expected %b, actual %b", value + 4, regfile_tb.DUT.R4);
	 end
	 
	 if(regfile_tb.DUT.R5 != value + 16'd5) begin
	    err = 1'b1;
	    $display("ERROR-R5 WRITE,     value incorrect, expected %b, actual %b", value + 5, regfile_tb.DUT.R5);
	 end
	 
	 if(regfile_tb.DUT.R6 != value + 16'd6) begin
	    err = 1'b1;
	    $display("ERROR-R6 WRITE,     value incorrect, expected %b, actual %b", value + 6, regfile_tb.DUT.R6);
	 end

	 if(regfile_tb.DUT.R7 != value + 16'd7) begin
	    err = 1'b1;
	    $display("ERROR-R7 WRITE,     value incorrect, expected %b, actual %b", value + 7, regfile_tb.DUT.R7);
	 end
	    
	 // reset the variables back to their original state
	 write = 1'b0;
	 writenum = 3'b0;
	 data_in = 16'b0;
      end
   endtask // reset_registers

   task check_registers;
      input [15:0] value;
      begin
	 readnum = 3'b0;

	 // iterate through every register
	 repeat(8) begin
	    #1;
	    	    
	    // check if the value in the register is on data_out
	    if(data_out != value) begin
	       err = 1'b1;
	       $display("ERROR-REG READ,     value incorrect, expected %b, actual $b", value, data_out);
	    end

		value = value + 1;
	    readnum += 3'b001;
	 end
      end
   endtask // check_registers
     
   initial begin
      // iverilog & GTKWave use only
      //$dumpfile("waveform.vcd");
      //$dumpvars(0, regfile_tb);

      // initialize variables
      err = 1'b0;
      write = 1'b0;
      readnum = 3'b0;
      writenum = 3'b0;
      data_in = 16'b0;

      // test for writing each register starting from 0
      test_value = 16'b0;
      write_registers(test_value);
      check_registers(test_value);

      // check for some different start values
      test_value = 16'b1111_1111_1111_1111;
      write_registers(test_value);
      check_registers(test_value);

      test_value = 16'b0000_0000_0000_1111;
      repeat (8) begin
	 write_registers(test_value);
	 check_registers(test_value);
	 test_value += 16'b0000_1100_0101_1001;
      end

      if (err)
	$display("regfile_tb - ERROR(S) FOUND!");
      else
	$display("regfile_tb - TEST PASSED!");

      //$stop;
   end // initial begin
endmodule
