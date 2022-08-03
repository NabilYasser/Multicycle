module MUX #(
    parameter DataWidth=32,Selectionline_size='d1

) (
    input wire [Selectionline_size-1:0] Sel,
    input wire [DataWidth-1:0] In1,
    input wire [DataWidth-1:0] In2,
    output reg [DataWidth-1:0] Out
);

  always @(*) begin
    case (Sel)
        'b0: Out=In1;
        'b1: Out=In2;
    endcase
  end  
endmodule