module ultimate_test();
  reg [3:0] KEY;
  reg [9:0] SW;
  wire [9:0] LEDR; 
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  reg err;
  reg CLOCK_50;

  lab7bonus_top DUT(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,CLOCK_50);

  initial forever begin
    CLOCK_50 = 0; #5;
    CLOCK_50 = 1; #5;
  end

  initial begin
    err = 0;
    KEY[1] = 1'b0; // reset asserted
    // check if program from Figure 2 in Lab 8 handout can be found loaded in memory

    #10; // wait until next falling edge of clock
    KEY[1] = 1'b1; // reset de-asserted, PC still undefined if as in Figure 4

    #10; // waiting for RST state to cause reset of PC
    if (DUT.CPU.PC !== 9'h0) begin err = 1; $display("FAILED: PC did not reset to 0."); $stop; end

    // If your simlation never gets past the the line below, check if your CMP instruction is working
    @(posedge LEDR[8]); // set LEDR[8] to one when executing HALT
    $display("Program Halted.");
    $stop;
  end
endmodule
