module Control_Unit #(
   parameter Opcode_Size ='d6 , Rtypr_Funct_Size='d6 ,ScrB_Mux_Selection_Line_Size='d2,ALU_Decoder_Size='d3
) (
    input  wire                                     clk     ,
    input  wire                                     rst     ,
    input  wire [Opcode_Size-1:0]                   Opcode  ,
    input  wire [Rtypr_Funct_Size-1:0]              Funct   ,
    output wire                                      MemtoReg, // Rather the Data to Reg comes from the Memory(lw and sw  instruction) OR the Alu result (R-type Instruction)
    output wire                                      RegDst  , // Rather the Address of the data to wire is inst[20:16] (lw and sw instr) OR inst[15:11] (R-type Instruction) 
    output wire                                      IorD    , // Rather the Address of the Memory is coming from the PC(Instruction) or the ALU result (lw and sw instructions)
    output wire  [1:0]                               PCSrc   , //
    output wire [ScrB_Mux_Selection_Line_Size-1:0]   ALUScrB , // ALU Source B a 4*1 MUX (R-type rt ,'d4 for pc incr,singlmm lw and sw inst and branch inst )
    output wire                                      ALUSrcA , // ALU Source A a 2*1 MUX (R-type rs and PC )
    //*                      Reg Enable                  ///// ////
    output wire                                      IRWrite , // Instruction Reg Enable
    output wire                                      MemWrite, //Memory Write Enable
    output wire                                      PCWrite , // PC Reg Write Enable
    output wire                                      Branch  , // Branch signal to an and with the zero flag
    output wire                                      RegWrite, // Reg file Write Enable 
    output wire [ALU_Decoder_Size-1:0]                ALUControl

);
wire  [1:0] ALUOp;
ALU_Decoder #(
    .Rtypr_Funct_Size (Rtypr_Funct_Size ),
    .ALU_Decoder_Size (ALU_Decoder_Size )
)
u_ALU_Decoder(
    .Funct      (Funct      ),
    .ALUOp      (ALUOp      ),
    .clk        (clk        ),
    .rst        (rst        ),
    .ALUControl (ALUControl )
);

FSM #(
    .Opcode_Size                  (Opcode_Size                  ),
    .Rtypr_Funct_Size             (Rtypr_Funct_Size             ),
    .ScrB_Mux_Selection_Line_Size (ScrB_Mux_Selection_Line_Size ),
    .ALU_Decoder_Size             (ALU_Decoder_Size             )
)
u_FSM(
    .Opcode   (Opcode   ),
    .clk      (clk      ),
    .rst      (rst      ),
    .MemtoReg (MemtoReg ),
    .RegDst   (RegDst   ),
    .IorD     (IorD     ),
    .PCSrc    (PCSrc    ),
    .ALUScrB  (ALUScrB  ),
    .ALUSrcA  (ALUSrcA  ),
    .IRWrite  (IRWrite  ),
    .MemWrite (MemWrite ),
    .PCWrite  (PCWrite  ),
    .Branch   (Branch   ),
    .RegWrite (RegWrite ),
    .ALUOp    (ALUOp    )
);


    
endmodule