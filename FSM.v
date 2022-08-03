module FSM #(
    parameter Opcode_Size ='d6 , Rtypr_Funct_Size='d6 ,ScrB_Mux_Selection_Line_Size='d2,ALU_Decoder_Size='d3
) (
    input  wire [Opcode_Size-1:0]                   Opcode  ,
    //input  wire [Rtypr_Funct_Size-1:0]              Funct   ,
    input  wire                                     clk     ,
    input  wire                                     rst     ,
    //*                      MUX Selections Line           ///
    output reg                                      MemtoReg, // Rather the Data to Reg comes from the Memory(lw and sw  instruction) OR the Alu result (R-type Instruction)
    output reg                                      RegDst  , // Rather the Address of the data to reg is inst[20:16] (lw and sw instr) OR inst[15:11] (R-type Instruction) 
    output reg                                      IorD    , // Rather the Address of the Memory is coming from the PC(Instruction) or the ALU result (lw and sw instructions)
    output reg  [1:0]                               PCSrc   , //
    output reg [ScrB_Mux_Selection_Line_Size-1:0]   ALUScrB , // ALU Source B a 4*1 MUX (R-type rt ,'d4 for pc incr,singlmm lw and sw inst and branch inst )
    output reg                                      ALUSrcA , // ALU Source A a 2*1 MUX (R-type rs and PC )
    //*                      Reg Enable                  ///// ////
    output reg                                      IRWrite , // Instruction Reg Enable
    output reg                                      MemWrite, //Memory Write Enable
    output reg                                      PCWrite , // PC Reg Write Enable
    output reg                                      Branch  , // Branch signal to an and with the zero flag
    output reg                                      RegWrite, // Reg file Write Enable 
    output reg  [1:0]                               ALUOp
    //output reg [ALU_Decoder_Size-1:]                ALUControl
);

reg [3:0] CurrentState,NextState;

localparam  Fetch= 4'b0000, // Fetch the Data and increment the PC  
            Decode=4'b0001,
            //* Lw or SW
            MemAdr=4'b0011,
            // Lw
            MemRead=4'b0010,
            MemWriteback=4'b0110,
            // Sw
            MemWrite_s=4'b0111  ,
            //* R-type
            Execute=4'b0101     ,
            ALUWriteback=4'b0100 ,
            //*Branch
            Branch_s=4'b1100,
            //
            Jump=4'b1110, // jump

            ADDi_Exectute=4'b1111, // add
            ADDi_Writeback=4'b1101;





always @(posedge clk  or negedge rst) begin
    if (!rst) begin
        CurrentState<='b0;
    end else begin
        CurrentState<=NextState;
    end
end

always @(*) begin
    MemtoReg='b0 ;// Rather the Data to Reg comes from the Memory(lw and sw  instruction) OR the Alu result (R-type Instruction)
    RegDst='b0  ; // Rather the Address of the data to reg is inst[20:16] (lw and sw instr) OR inst[15:11] (R-type Instruction) 
    IorD='b0    ; // Rather the Address of the Memory is coming from the PC(Instruction) or the ALU result (lw and sw instructions)
    PCSrc='b00   ; //
    ALUScrB='b00 ; // ALU Source B a 4*1 MUX (R-type rt ;'d4 for pc incr;singlmm lw and sw inst and branch inst )
    ALUSrcA='b0 ; // ALU Source A a 2*1 MUX (R-type rs and PC )
    //*                      Reg Enable                  ///// ////
    IRWrite='b0 ; // Instruction Reg Enable
    MemWrite='b0; //Memory Write Enable
    PCWrite='b0 ; // PC Reg Write Enable
    Branch='b0  ; // Branch signal to an and with the zero flag
    RegWrite='b0 ; // Reg file Write Enable 
    ALUOp='b00; 



    case (CurrentState)
       Fetch : begin
        ALUSrcA='b0;
        ALUScrB='b01;
        PCSrc='b00;
        PCWrite='b1;
        IorD='b0;
        IRWrite='b1;
        ALUOp='b00; 

        NextState=Decode;
       end

       Decode:begin
        ALUSrcA='b0;
        ALUScrB='b11;
        ALUOp='b00;
        case (Opcode)
            6'b100011,6'b101011:NextState=MemAdr; // lw and sw
            6'b000000: NextState=Execute; // R-type
            6'b001000: NextState=ADDi_Exectute;
            6'b000100:NextState=Branch_s; // Breanch
            6'b000010:NextState=Jump;//jump state
            default: NextState=Fetch;
        endcase

       end

       MemAdr:begin
        ALUSrcA='b1;
        ALUScrB='b10;
        ALUOp='b00;
        if (Opcode== 6'b100011) begin
            NextState=MemRead;
        end else begin
            NextState=MemWrite_s;
        end
       end

       MemRead:begin
        IorD='b1;
        NextState=MemWriteback;
       end

       MemWriteback:begin
        MemtoReg='b1;
        RegDst='b0;
        RegWrite='b1;
        NextState=Fetch;
       end

       MemWrite_s:begin
        IorD='b1;
        MemWrite='b1;
        NextState=Fetch;
       end

       Execute:begin
        ALUSrcA='b1;
        ALUScrB='b00;
        ALUOp=2'b10;
        NextState=ALUWriteback;
       end

       ALUWriteback:begin
        MemtoReg='b0;
        RegDst='b1;
        RegWrite='b1;
        NextState=Fetch;
       end

       Branch_s:begin
        ALUScrB='b00;
        ALUSrcA='b1;
        ALUOp='b01;
        PCSrc='b01;
        Branch='b1;
        NextState=Fetch;
       end

       ADDi_Exectute:begin
        ALUSrcA='b1;
        ALUScrB='b10;
        ALUOp='b00;
        NextState=ADDi_Writeback;
        
       end
       ADDi_Writeback:begin
        MemtoReg='b0;
        RegDst='b0;
        RegWrite='b1;
        NextState=Fetch;
    
       end

       Jump:begin
        PCSrc='b10;
        PCWrite='b1;
        NextState=Fetch;
       end

        default:NextState=Fetch; 
    endcase

end
    
endmodule