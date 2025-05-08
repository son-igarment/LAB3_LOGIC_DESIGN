/*
 * Linear Feedback Shift Register for Random Data Generation
 * Author: Phạm Lê Ngọc Sơn
 * EE4449 - HCMUT
 */
module lfshr ( //16-bit linear feed back shift register
    input clk,
    input rst,
	// input wr_en,
    //input logic [23:0] seed,
    output logic [23:0] out
);

always @(posedge clk)
begin
	if(!rst)
		begin
			out <= 24'h123456;
		end
	else 
		begin
			//if(wr_en)
				//begin
			out <= {out[22] ^ out[3] ^ out[2] ^ out[0], out[23:1]};
			   //end
		end
end
endmodule