`timescale 1ns/1ns
module Multicycle_tb (
    
);

reg CLK_tb;
reg RST_tb;
wire [31:0] Test_tb;
Multicycle u_Multicycle(
    .CLK_Top  (CLK_tb  ),
    .RST_Top  (RST_tb  ),
    .Test_Top (Test_tb )
);

parameter clock_period = 10 ;
always #(clock_period/2) CLK_tb=~CLK_tb;
initial begin
    RST_tb='b0;
    CLK_tb='b0;
    #clock_period;
    RST_tb='b1;
    wait(Test_tb=='d69);
    $display("Test case done");
    $stop;

end

    
endmodule