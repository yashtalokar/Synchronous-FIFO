`timescale 1ns / 1ps

module syn_fifo_tb();
    reg clk, rst_n;
    reg wr, rd;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire fifo_full, fifo_empty;
    
    // Instantiation of FIFO
    sync_fifo uut(
        .data_out(data_out),
        .full(fifo_full),
        .empty(fifo_empty),
        .clk(clk),
        .rst_n(rst_n),
        .wr(wr),
        .rd(rd),
        .data_in(data_in)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; rst_n = 0;
        wr = 0; rd = 0;
        
        // Apply reset
        #10 rst_n = 1;
        
        // Write data to FIFO
        wr = 1;
        data_in = 1;
        #10;
        
        data_in = 2;
        #10;
        
        data_in = 3;
        #10;
        
        data_in = 4;
        #10;
        
        data_in = 5;
        #10;
        
        data_in = 155;
        #10;
        
        data_in = 218;
        #10;
        
        data_in = 60;
        #10;
        
        
        // Read data from FIFO
        wr = 0;
        rd = 1;
        #100; // Allow time for reads
        
        // End simulation
      $monitor("Simulation finished.");
        
        $finish();
    end
    
    // Monitor signals
    initial begin
      $dumpfile("dump.vcd"); $dumpvars;
    end
endmodule
