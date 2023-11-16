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
    err = 0;
    reset = 1; s = 0; load = 0; in = 16'b0;
    #10;
    reset = 0; 
    #10;

    // MOV immediate tests
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


    // MOV Reg Tests
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

    if (~err) $display("cpu_tb - PASSED TEST");
    else $display("cpu_tb - ERROR(S) FOUND");
    $stop;
  end
endmodule
