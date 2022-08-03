module REGISTER #(parameter DataWidth =32) (
    input wire [DataWidth-1:0] WRData,
    input wire                 WREnable,
    input wire                 clk,
    input wire                 rst,
    output reg [DataWidth-1:0] REData
);
    
always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        REData<='b0;
        
    end else begin
        if (WREnable==1'b1) begin
            REData<=WRData;
        end
        
    end
end

endmodule