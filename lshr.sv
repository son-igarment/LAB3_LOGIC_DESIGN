module lfshr_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // ??nh ngh?a chu k? clock (trong ??n v? time unit)

    // Inputs
    reg clk = 0;
    reg rst = 1; // ??t reset ban ??u
  //  reg [23:0] seed = 24'h123456; // Giá tr? seed ban ??u

    // Outputs
    wire [23:0] out;

    // Instantiate the module under test
    lfshr uut (
        .clk(clk),
        .rst(rst),
 //       .seed(seed),
        .out(out)
    );

    // Generate clock
    always #(CLK_PERIOD/2) clk = ~clk;

    // Reset sequence
    initial begin
        #10; // Ch? 100 time unit
        rst = 0; // Reset b?ng 0
        #10; // Ch? thêm 100 time unit
        rst = 1; // K?t thúc reset
        #10; // Ch? thêm m?t th?i gian sau khi reset
        $finish; // K?t thúc mô ph?ng
    end

endmodule
