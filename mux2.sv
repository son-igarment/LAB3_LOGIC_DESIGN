module mux2(
input logic [23:0] data_in,
input logic [5:0] fifolen,
input logic sel,
output logic [23:0] mux_out
);

assign mux_out = (sel == 1) ? data_in : fifolen;
endmodule