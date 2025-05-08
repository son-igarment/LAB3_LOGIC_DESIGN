/*
 * Memory Module for Asynchronous FIFO
 * Author: Phạm Lê Ngọc Sơn
 * EE4449 - HCMUT
 */
module memories(
input logic clkr,clkw,rst,
input logic [23:0] data_in,
input logic [4:0] addr_wr,
input logic [4:0] addr_rd,
input logic wren,rden,
output logic [23:0]data_out
);
reg [23:0] regs [31:0];
always @(posedge clkw )
begin
 	if (!rst) 
		begin
			for (int i = 0 ; i<32; i= i+1)
				begin
					regs[i]<= 24'h000000;
				end
		end
 	else if(rst)
		begin
		if (wren )
		begin
			regs[addr_wr] <= data_in;
		end
		end
end

always @(posedge clkr)

	begin
		if(rden)	
		begin
			data_out <= regs[addr_rd];
		end
		else
			begin 
			data_out <= data_out;
			end
	end	


//assign data_out = regs[addr_rd];
endmodule