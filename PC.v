module PC #(parameter DataWidth =32) (
    input wire [DataWidth-1:0] PC_IN,
    input wire                 PCEn,
    input wire        clk ,
    input wire        rst ,
    output reg [DataWidth-1:0] PC_OUT
);

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        PC_OUT<='b0;
    end
    else if (PCEn) begin
        PC_OUT<=PC_IN;
    end
    
end
    
endmodule