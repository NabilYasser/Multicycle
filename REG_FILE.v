module REG_FILE #(
    parameter DataWidth =32, parameter Depth =32 ,parameter Addres_depth=5
) (
    input wire [Addres_depth-1:0] A1,
    input wire [Addres_depth-1:0] A2,
    input wire [Addres_depth-1:0] A3,
    input wire [DataWidth-1:0]    WD3,
    input wire                    WE3,
    input wire                    clk,
    input wire                    rst,
    output reg [DataWidth-1:0]    RD1, 
    output reg [DataWidth-1:0]    RD2
);
    reg [DataWidth-1:0] RegFile [0:Depth-1];
    integer i;
always @(*) begin
    RD1=RegFile[A1];
end

always @(*) begin
    RD2=RegFile[A2];
end

always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        for ( i=0 ;i <Depth ;i=i+1 ) begin
            RegFile[i]<='b0;
        end
    end else if(WE3==1'b1) begin
        RegFile[A3]<=WD3;
    end
end

endmodule