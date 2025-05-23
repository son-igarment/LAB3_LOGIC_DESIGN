/*
 * Asynchronous FIFO Design and Verification with SystemVerilog Assertions
 * Author: Phạm Lê Ngọc Sơn
 * EE4449 - HCMUT
 */
//top level file of your Lab 3
module  top_lab3(
input logic SW0, KEY0,KEY1,KEY2,clk, 
output logic [23:0]data_in,
output logic LEDR0,LEDR1,LEDR2,
output logic [4:0] wrptr,rdptr,
output logic clkw,clkr,
output logic [23:0] o_data,
output logic [5:0 ] fifo_len,
output logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0

);
wire [23:0]mux_in;
wire [23:0] signal1;
wire [5:0] signal2;
wire [23:0] signal3;
wire clock_05hz;
wire clock_1hz;
wire [23:0] inmem;
wire [4:0] wraddr;
wire [4:0] rdaddr;
wire wren;
wire rden;



assign o_data =signal1;
assign clkw=clock_05hz;
assign clkr=clock_1hz;
assign data_in =inmem;
assign wrptr = wraddr;
assign rdptr = rdaddr;
assign LEDR2 = !LEDR1;
Clock_divider Clock_divider(   
.clock_in(clk), 
.clock_05hz(clock_05hz), 
.clock_1hz(clock_1hz)
); 

lfshr lfshr(
.clk(clock_05hz),
.rst(KEY2),
//.wr_en(KEY0),
//.seed(111111),
.out(inmem)
);

memories memories(
.clkr(clock_1hz),
.clkw(clock_05hz),
.rst(KEY2),
.data_in(inmem),
.addr_wr(wraddr),
.addr_rd(rdaddr),
.wren(wren),
.rden(rden),
.data_out(signal1)
);

mux2 mux2(
.data_in(signal1),
.fifolen(signal2),
.sel(SW0),
.mux_out(signal3)
);


fifoctrl fifoctrl
    (
     .clkw(clock_05hz), //clock write
     .clkr(clock_1hz), //clock read
     .rst(KEY2),
     .fiford(KEY1),    // FIFO control
     .fifowr(KEY0),
	  
     .fifofull(LEDR0),  // high when fifo full
     .notempty(LEDR1),  // high when fifo not empty

     .fifolen(signal2),   // fifo length
     .write(wren),     // enable to write memories
     .wraddr(wraddr),    // write address of memories
     .read(rden),      // enable to read memories
     .rdaddr(rdaddr)     // read address of memories
     );


	bcdtohex hex0(
    .bcd(signal3[3:0]),
    .segment(HEX0)
   );
	
	bcdtohex hex1(
    .bcd(signal3[7:4]),
    .segment(HEX1)
   );
	
	bcdtohex hex2(
    .bcd(signal3[11:8]),
    .segment(HEX2)
   );
	
	bcdtohex hex3(
    .bcd(signal3[15:12]),
    .segment(HEX3)
   );
	
	bcdtohex hex4(
    .bcd(signal3[19:16]),
    .segment(HEX4)
   );
	
	bcdtohex hex5(
    .bcd(signal3[23:20]),
    .segment(HEX5)
   );
	
endmodule