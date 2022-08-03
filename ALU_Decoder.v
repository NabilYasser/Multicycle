module ALU_Decoder #(
    parameter Rtypr_Funct_Size='d6,ALU_Decoder_Size='d3
) (
    input  wire [Rtypr_Funct_Size-1:0]              Funct   ,
    input  wire [1:0]                               ALUOp   ,
    input  wire                                     clk     ,
    input  wire                                     rst     ,
    output reg [ALU_Decoder_Size-1:0]                ALUControl
);
    always @(*) begin
        case (ALUOp)
            'b00: ALUControl='b010;
            'b01: ALUControl='b100;
            'b10: begin
                case (Funct)
                    6'b100000: ALUControl='b010;
                    6'b100010: ALUControl='b100;
                    6'b101010: ALUControl='b110;
                    6'b011100: ALUControl='b101;

                    default: ALUControl='b010;
                endcase
            end
            default: ALUControl='b010;
        endcase
        
    end
endmodule