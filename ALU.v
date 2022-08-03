module ALU#(parameter Data_Size ='d32 ,ALU_Decoder_Size='d3) (
    input wire [Data_Size-1:0] SrcA,
    input wire [Data_Size-1:0] SrcB,
    input wire [ALU_Decoder_Size-1:0] ALUControl,
    output reg [Data_Size-1:0] ALUResult,
    output reg ZeroFlag
);
    
always @(*) begin
    case (ALUControl)

        3'b000: begin
            ALUResult=SrcA & SrcB;
        end

         3'b001: begin
            ALUResult=SrcA | SrcB;
        end

         3'b010: begin
            ALUResult=SrcA + SrcB;
        end

         3'b011: begin
            ALUResult=32'b0; // *? Should NOT SET ALUResult to 0
          end

          3'b100: begin
            ALUResult=SrcA - SrcB;
        end

          3'b101: begin
            ALUResult=SrcA * SrcB;
        end

          3'b110: begin
              // *! Last bit is a sign bit 
              // *?  ALUResult=SrcA - SrcB; 
             /* if (ALUResult[31]==1) begin
                  ALUResult=32'b1;
              end 
              else begin
                  ALUResult=32'b0;
              end*/

            if (SrcA < SrcB) begin // *! Large compartor is beign used
                 ALUResult=32'b1;
            end
            else begin
                ALUResult=32'b0;
            end
        end

         3'b111: begin
            ALUResult=32'b0; // *? Should NOT SET ALUResult to 0
        end
   
        default: ALUResult=32'b0; // *? Should The defult be ALUResult = 0
    endcase
end

always @(*) begin
    if(ALUResult==0)
    begin
        ZeroFlag=1'b1;
    end
    else begin
        ZeroFlag=1'b0;
    end
end

endmodule
