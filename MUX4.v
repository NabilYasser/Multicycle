module MUX4 #(
    parameter DataWidth=32,Selectionline_size='d2

) (
    input wire [Selectionline_size-1:0] Sel,
    input wire [DataWidth-1:0] In1,
    input wire [DataWidth-1:0] In2,
    input wire [DataWidth-1:0] In3,
    input wire [DataWidth-1:0] In4,
    output reg [DataWidth-1:0] Out
);

  always @(*) begin
    case (Sel)
        'b00: Out=In1;
        'b01: Out=In2;
        'b10: Out=In3;
        'b11: Out=In4;
    endcase
  end  
endmodule