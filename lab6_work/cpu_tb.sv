module cpu_tb();
  reg clk, reset, s, load;
  reg [15:0] in;
  wire [15:0] out;
  wire N,V,Z,w;

  reg err;

  cpu DUT(clk,reset,s,load,in,out,N,V,Z,w);

  initial begin
    clk = 0; #5;
    forever begin
      clk = 1; #5;
      clk = 0; #5;
    end
  end

  initial begin
    // iverilog use only
    //$dumpfile("waveform.vcd");
    //$dumpvars(0, cpu_tb);

    err = 0;
    reset = 1; s = 0; load = 0; in = 16'b0;
    #10;
    reset = 0; 
    #10;

    /* ----------- Move Immediate Tests ------------ */
    // MOV R0, #42
    in = {8'b11010000, 8'd42};
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'd42) begin
      err = 1;
      $display("FAILED: MOV R0, #42");
      $stop;
    end

    @(negedge clk); // wait for falling edge of clock before changing inputs
    
    // MOV R1, #10
    in = {8'b11010001, 8'd10};
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R1 !== 16'd10) begin
      err = 1;
      $display("FAILED: MOV R1, #10");
      $stop;
    end

    @(negedge clk); // wait for falling edge of clock before changing inputs
    
    // MOV R2, #254 (-2)
    in = {8'b11010010, 8'd254};
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'd65534) begin
      err = 1;
      $display("FAILED: MOV R2, #254");
      $stop;
    end


    /* ----------- Move Register Tests ------------ */
    // MOV R3, R0
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1100000001100000;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R3 !== cpu_tb.DUT.DP.REGFILE.R0) begin
      err = 1;
      $display("FAILED: MOV R3, R0");
      $stop;
    end
    
    // MOV R4, R1, LSL #1
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1100000010001001;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R4 !== {cpu_tb.DUT.DP.REGFILE.R1[14:0], 1'b0}) begin
      err = 1;
      $display("FAILED: MOV R4, R1, LSL #1");
      $stop;
    end

    // MOV R0, R2, LSR #1
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1100000000011010;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== {cpu_tb.DUT.DP.REGFILE.R2[15], cpu_tb.DUT.DP.REGFILE.R2[15:1]}) begin
      err = 1;
      $display("FAILED: MOV R0, R2, LSR #1");
      $stop;
    end

    /* ----------- ADD Tests ------------ */
    // ADD R5, R3, R4
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1010001110100100;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R5 !== (cpu_tb.DUT.DP.REGFILE.R3 + cpu_tb.DUT.DP.REGFILE.R4)) begin
      err = 1;
      $display("FAILED: ADD R5, R3, R4");
      $stop;
    end

    // ADD R6, R0, R2, LSL #1
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1010000011001010;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R6 !== (cpu_tb.DUT.DP.REGFILE.R0 + {cpu_tb.DUT.DP.REGFILE.R2[14:0], 1'b0})) begin
      err = 1;
      $display("FAILED: ADD R6, R0, R2, LSL #1");
      $stop;
    end

    // ADD R7, R1, R5, LSR #1
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1010000111111101;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R7 !== (cpu_tb.DUT.DP.REGFILE.R1 + {cpu_tb.DUT.DP.REGFILE.R5[15], cpu_tb.DUT.DP.REGFILE.R5[15:1]})) begin
      err = 1;
      $display("FAILED: ADD R7, R1, R5, LSR #1");
      $stop;
    end
    
    /* ----------- CMP Tests ------------ */
    // CMP R1, R4
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1010100100000100;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.Z_out !== 3'b010) begin
      err = 1;
      $display("FAILED: CMP R1, R4");
      $stop;
    end

    // CMP R1, R4, LSR #1
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1010100100011100;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.Z_out !== 3'b001) begin
      err = 1;
      $display("FAILED: CMP R1, R4, LSR #1");
      $stop;
    end

    // Force R7 to most negative number possible to test overflow
    force cpu_tb.DUT.DP.REGFILE.R7 = {1'b1, 15'b0};
    // CMP R7, R3
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1010111100000011;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.Z_out !== 3'b100) begin
      err = 1;
      $display("FAILED: CMP R1, R4");
      $stop;
    end
    release cpu_tb.DUT.DP.REGFILE.R7;

    /* ----------- AND Tests ------------ */
    // AND R4, R3, R6
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1011001110000110;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R4 !== (cpu_tb.DUT.DP.REGFILE.R3 & cpu_tb.DUT.DP.REGFILE.R6)) begin
      err = 1;
      $display("FAILED: AND R4, R3, R6, expecting: %b", cpu_tb.DUT.DP.REGFILE.R3 & cpu_tb.DUT.DP.REGFILE.R6);
      $stop;
    end

    // AND R0, R0, R2, LSL #1
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1011000000001010;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== (cpu_tb.DUT.DP.REGFILE.R0 & {cpu_tb.DUT.DP.REGFILE.R2[14:0], 1'b0})) begin
      err = 1;
      $display("FAILED: AND R0, R0, R2, LSL #1");
      $stop;
    end

    // AND R7, R1, R5, LSR #1
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1011000111111101;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R7 !== (cpu_tb.DUT.DP.REGFILE.R1 & {cpu_tb.DUT.DP.REGFILE.R5[15], cpu_tb.DUT.DP.REGFILE.R5[15:1]})) begin
      err = 1;
      $display("FAILED: AND R7, R1, R5, LSR #1");
      $stop;
    end
    
    /* ----------- MVN Tests ------------ */
    // MVN R5, R5
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1011100010100101;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R5 !== ~{16'd62}) begin
      err = 1;
      $display("FAILED: MVN R5, R5");
      $stop;
    end

    // MVN R6, R5
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1011100011000101;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R6 !== 16'd62) begin
      err = 1;
      $display("FAILED: MVN R6, R5");
      $stop;
    end

    // MVN R3, R2, LSL #1
    @(negedge clk); // wait for falling edge of clock before changing inputs
    in = 16'b1011100001101010;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R3 !== ~{16'd65532}) begin // NOT -4
      err = 1;
      $display("FAILED: MVN R3, R2, LSL #1");
      $stop;
    end

    if (~err) $display("cpu_tb - PASSED TEST");
    else $display("cpu_tb - ERROR(S) FOUND");
    $stop;
  end
endmodule
