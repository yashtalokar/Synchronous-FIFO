`timescale 1ns / 1ns

module syn_fifo_tb();
    reg clk, rst_n;
    reg wr, rd;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire fifo_full, fifo_empty;
    
    
  fifo_mem uut(.data_out(data_out), .fifo_full(fifo_full), .fifo_empty(fifo_empty), 
               .clk(clk),.rst_n(rst_n), .wr(wr), .rd(rd), .data_in(data_in));
    
    // Clock generation
  always #5 clk = ~clk;
    
  initial begin
    clk = 0; rst_n = 0;
    wr = 0; rd = 0;
        
    #10 rst_n = 1;
      
    // Write data to FIFO
    wr = 1;
      
    for(integer i=0; i<17;i++) begin
     data_in = $urandom_range(1,100);
      #10;
    end
   
        
    // Read data from FIFO
    wr = 0;
    rd = 1;
    #200; // Allow time for reads
        
    $finish();
  end
    
  
  initial begin
    $monitor("Time: %0t, data_in: %b, data_out: %b, fifo_full: %b, fifo_empty: %b", 
              $time, data_in, data_out, fifo_full, fifo_empty);
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
endmodule
