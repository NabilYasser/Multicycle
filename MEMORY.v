module MEMORY #(parameter DataWidth =32, parameter Depth =200  ) (
    
    input wire [DataWidth-1:0] Address,
    input wire [DataWidth-1:0] WRData,
    input wire                 WREnable,
    input wire                 clk,
    input wire                 rst,

    output reg  [DataWidth-1:0]Test,
    output reg  [DataWidth-1:0] REData
   
);
integer i;
 reg [DataWidth-1:0] MEMORY [Depth-1:0];
 initial begin
    $readmemb ("Machine_Code.txt",MEMORY);
    //$readmemb ("Machine_Code_Data.txt",MEMORY);
 end

always @(*) begin
    REData=MEMORY[Address];
end
always @(*) begin
    Test=MEMORY['d101];
end


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        for (i =100 ; i < Depth ;i=i+1 ) begin
           MEMORY[i]<='b0; 
        end
    end else if (WREnable==1) begin
         MEMORY[Address]<=WRData;
        
    end 
end

endmodule