/*
 * Asynchronous FIFO Design and Verification with SystemVerilog Assertions
 * Author: Phạm Lê Ngọc Sơn
 * EE4449 - HCMUT
 */
`timescale 1ps/1ps
module top_lab3_tb
();
 
    reg SW0, i_rst_n, rd_en, wr_en;  
    wire o_full, o_empty, LEDR1;
    reg i_clk;
    wire [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
    wire [4:0] rd_ptr, wr_ptr;
    logic [23:0]i_data,o_data;
    logic clk,clkw,clkr;
    logic [5:0] fifo_len;
    top_lab3 uut (
        .SW0(SW0),
        .KEY0(wr_en),
        .KEY1(rd_en),
        .KEY2(i_rst_n),
        .LEDR0(o_full),
        .LEDR1(LEDR1),
        .LEDR2(o_empty),
	.data_in(i_data),
        .clk(i_clk),
        .clkw(clkw),
	.clkr(clkr),
	.rdptr(rd_ptr), 
	.wrptr(wr_ptr),
	.o_data(o_data),
.fifo_len(fifo_len),
        .HEX5(HEX5),
        .HEX4(HEX4),
        .HEX3(HEX3),
        .HEX2(HEX2),
        .HEX1(HEX1),
        .HEX0(HEX0)
            );

    // Clock generation
  initial begin
 #0  i_clk = 1'b0;
 forever #10 i_clk = !i_clk;
 end
//assign clk = i_clk;

  initial begin
        #0 i_rst_n = 1;
        #10 i_rst_n = 0; 
        #15 i_rst_n = 1;
  end
  
 initial begin
    #1;
    wr_en = 1'b1; 
     #66000 wr_en=1'b0; 
      
end

  
  initial begin
    #1;
    rd_en = 1'b0;
    #66000;
    
    rd_en = 1'b1; 
end

//case 1
 property async_rst_startup ;
    @(posedge i_clk) !i_rst_n |-> ##1 (wr_ptr==0 && rd_ptr == 0 && o_empty);

endproperty

assert property (async_rst_startup); 



//case 2

 // rst check in general
 property async_rst_chk;
 @(negedge i_rst_n) !i_rst_n |-> ##1 @(posedge i_clk) (wr_ptr==0 &&rd_ptr == 0 && o_empty);
 endproperty
assert property (async_rst_chk); 
 
//case 3
 sequence rd_detect(ptr);
 ##[0:$] (rd_en && !o_empty && (rd_ptr == ptr));
 endsequence
 
 property data_wr_rd_chk(wr_ptr);
 // local variable
 integer ptr, data;
 @(posedge clkw) disable iff(!i_rst_n)
 (wr_en && !o_full, ptr = wr_ptr, data = i_data, $display($time, "wr_ptr=%h, i_fifo=%h",wr_ptr, i_data)) |-> ##1 first_match(rd_detect(ptr+1), $display($time, " rd_ptr=%h,o_fifo=%h",rd_ptr, o_data)) ##0 o_data == data;
 endproperty
assert property(data_wr_rd_chk(wr_ptr));

//case 4
 property dont_write_if_full;
 // @(posedge i_clk) disable iff(!i_rst_n) o_full |-> ##1 $stable(wr_ptr);
 // alternative way of writing the same assertion
 @(posedge i_clk) disable iff(!i_rst_n) wr_en && o_full |-> ##1 wr_ptr == $past(wr_ptr);
 endproperty
assert property(dont_write_if_full);

//case 5
property dont_read_if_empty;
 @(posedge clkr) disable iff(!i_rst_n) rd_en &	& o_empty |-> ##1 $stable(rd_ptr);
 endproperty
assert property(dont_read_if_empty);

//case 6
 property inc_wr_one;
 @(posedge clkw) disable iff(!i_rst_n) wr_en && !o_full |-> ##1 (wr_ptr-1'b1 == $past(wr_ptr));
 endproperty
assert property(inc_wr_one);

//case 7
property inc_rd_one;
@(posedge clkr) disable iff(!i_rst_n) rd_en && !o_empty|-> ##1 (rd_ptr -1'b1 == $past(rd_ptr));
endproperty
assert property(inc_rd_one);


//case 8
property default_rd_wr;
@(posedge i_clk) disable iff(!i_rst_n) rd_en && wr_en |-> ##1 (fifo_len ==$past(fifo_len));
endproperty
assert property (default_rd_wr);


//case 9
 property rst_fifo_len;
 @(negedge i_rst_n) !i_rst_n |-> ##1 @(posedge i_clk) (fifo_len ==  6'b000000);
 endproperty
assert property (rst_fifo_len); 


//case 10
property fifolen_when_full;
		@(posedge i_clk) disable iff(!i_rst_n) rd_en && o_full |-> ##1 $stable(fifo_len);
	endproperty
	assert property(fifolen_when_full);



endmodule





