module LEFT_SHIFTER #(
    parameter NumOfShifts=2,
    parameter InputDataWidth=32,
    parameter OutputDataWidth=32

) (
    input wire [InputDataWidth-1:0] In,
    output wire  [OutputDataWidth-1:0] Out
);
    assign Out=In<<NumOfShifts;


endmodule