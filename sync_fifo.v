`timescale 1ns/1ps

`define size 128 
`define width 30

module fifo_mem(  
  input fifo_rd,fifo_wr,clk,
  input [$clog2(`size):0] wptr,rptr,
  input [`width-1:0] data_in,
  output reg [`width-1:0] data_out
);
  reg [`width-1:0]memory[`size-1:0];
  
  always @(posedge clk) begin
    if(fifo_wr)
      memory[wptr[$clog2(`size)-1:0]] <= data_in;
    else if(fifo_rd)
      data_out <= memory[rptr[$clog2(`size)-1:0]];
  end
endmodule
  
module fifo_wptr(
  input wr,clk,rst_n,full,
  output reg [$clog2(`size):0] wptr,
  output fifo_wr 
);
  assign fifo_wr = (~full) & wr;
  
  always@ (posedge clk or negedge rst_n) begin
    if(~rst_n)
      wptr <= 0;
    else if(fifo_wr)
      wptr <= wptr + 1;
    else 
      wptr <= wptr;
  end
endmodule

module fifo_rptr(
  input rd,clk,rst_n,empty,
  output reg [$clog2(`size):0] rptr,
  output fifo_rd 
);
  assign fifo_rd = (~empty) & rd;
  
  always@ (posedge clk or negedge rst_n) begin
    if(~rst_n)
      rptr <= 0;
    else if(fifo_rd)
      rptr <= rptr + 1;
    else 
      rptr <= rptr;
  end
endmodule

module fifo_full_empty(
  input clk,
  input [$clog2(`size):0] wptr,rptr,
  output reg full,empty
);

  always@ (posedge clk) begin
    full = (wptr[$clog2(`size)] ^ rptr[$clog2(`size)]) & (wptr[$clog2(`size)-1:0] == rptr[$clog2(`size)-1:0]);
    empty = (~wptr[$clog2(`size)] ^ rptr[$clog2(`size)]) & (wptr[$clog2(`size)-1:0] == rptr[$clog2(`size)-1:0]);
end
endmodule


module sync_fifo(
  input [`width-1:0] data_in,
  input clk,rst_n,wr,rd,
  output [`width-1:0] data_out,
  output full,empty
);
  
  wire [$clog2(`size):0] wptr,rptr;
  wire fifo_wr,fifo_rd;
  
  fifo_mem top1(fifo_rd,fifo_wr,clk,wptr,rptr,data_in, data_out);
  fifo_wptr top2 (wr,clk,rst_n,full,wptr,fifo_wr);
  fifo_rptr top3 (rd,clk,rst_n,empty,rptr,fifo_rd);
  fifo_full_empty top4 (clk,wptr,rptr,full,empty);
  
endmodule
