module Data_Path #(
    parameter Data_Size ='d32 ,ALU_Decoder_Size='d3, NumOfShifts_Sign='d2, 
    Addres_depth=5, Repeat =16,NumOfShifts_JUMP='d2,ScrB_Mux_Selection_Line_Size='d2
) (
    input  wire [25:0]                               instr   ,
    input  wire [Data_Size-1:0]                      Data    ,
    input  wire                                      clk     ,
    input  wire                                      rst     ,
    input  wire                                      MemtoReg, // Rather the Data to Reg comes from the Memory(lw and sw  instruction) OR the Alu result (R-type Instruction)
    input  wire                                      RegDst  , // Rather the Address of the data to wire is inst[20:16] (lw and sw instr) OR inst[15:11] (R-type Instruction) 
    input  wire  [1:0]                               PCSrc   , //
    input  wire [ScrB_Mux_Selection_Line_Size-1:0]   ALUScrB , // ALU Source B a 4*1 MUX (R-type rt ,'d4 for pc incr,singlmm lw and sw inst and branch inst )
    input  wire                                      ALUSrcA , // ALU Source A a 2*1 MUX (R-type rs and PC )
    //*                      Reg Enable                  ///// ////
    
    input  wire                                      RegWrite, // Reg file Write Enable 
    input  wire [ALU_Decoder_Size-1:0]               ALUControl,
    input  wire                                      PCEn,
    output wire                                      ZeroFlag,
    output wire [Data_Size-1:0]                      RD2_REG ,
    output wire [Data_Size-1:0]                      ALUOut ,
    output wire [Data_Size-1:0]                      PC_OUT  
);
wire [Data_Size-1:0] SrcA,SrcB,PC,RD1,RD2,RD1_REG,SignImm,SignImm_Shifted;
wire [Data_Size-1:0] ALUResult,WD3,PC_IN;
wire [Addres_depth-1:0]A3;
wire [27:0]Jump_shifter_out;



REG_FILE #(
    .DataWidth    (Data_Size    ),
    .Depth        (Data_Size    ),
    .Addres_depth (Addres_depth )
)
u_REG_FILE(
    .A1  (instr[25:21]  ),
    .A2  (instr[20:16]  ),
    .A3  (A3  ),
    .WD3 (WD3 ),
    .WE3 (RegWrite ),
    .clk (clk ),
    .rst (rst ),
    .RD1 (RD1 ),
    .RD2 (RD2 )
);

REGISTER #(
    .DataWidth (Data_Size )
)
uRD1_REGISTER(
    .WRData   (RD1   ),
    .WREnable (1'b1 ),
    .clk      (clk      ),
    .rst      (rst      ),
    .REData   (RD1_REG   )
);


REGISTER #(
    .DataWidth (Data_Size )
)
u0_REGISTER(
    .WRData   (RD2   ),
    .WREnable (1'b1 ),
    .clk      (clk      ),
    .rst      (rst      ),
    .REData   (RD2_REG   )
);


//* MUX for the DATA WRITE RIG FILE
MUX uWD3_MUX(
    .Sel (MemtoReg ),
    .In1 (ALUOut ),
    .In2 (Data ),
    .Out (WD3 )
);


 //* MUX FOR A3 REG FILE
MUX #(
    .DataWidth  ('d5 ))
uA3_MUX(
    .Sel (RegDst ),
    .In1 (instr[20:16] ),
    .In2 (instr[15:11] ),
    .Out (A3 )
);

//* REG after the alu
REGISTER #(
    .DataWidth (Data_Size )
)
uALU_REGISTER(
    .WRData   (ALUResult   ),
    .WREnable (1'b1 ),
    .clk      (clk      ),
    .rst      (rst      ),
    .REData   (ALUOut   )
);



ALU #(
    .Data_Size        (Data_Size        ),
    .ALU_Decoder_Size (ALU_Decoder_Size )
)
u_ALU(
    .SrcA       (SrcA       ),
    .SrcB       (SrcB       ),
    .ALUControl (ALUControl ),
    .ALUResult  (ALUResult  ),
    .ZeroFlag   (ZeroFlag   )
);

MUX uSrcA_MUX(
    .Sel (ALUSrcA ),
    .In1 (PC_OUT ),
    .In2 (RD1_REG ),
    .Out (SrcA )
);

SIGN_EXTEND #(
    .Repeat (Repeat )
)
u_SIGN_EXTEND(
    .Inst    (instr[15:0]    ),
    .Signimm (SignImm )
);

MUX4 u_MUX4(
    .Sel (ALUScrB ),
    .In1 (RD2_REG ),
    .In2 (32'd1 ), //! TODO 
    .In3 (SignImm ),
    .In4 (SignImm_Shifted ),
    .Out (SrcB )
);

LEFT_SHIFTER #(
    .NumOfShifts     (NumOfShifts_Sign     ),
    .InputDataWidth  (Data_Size  ),
    .OutputDataWidth (Data_Size )
)
u_LEFT_SHIFTER(
    .In  (SignImm  ),
    .Out (SignImm_Shifted )
);


PC #(
    .DataWidth (Data_Size )
)
u_PC(
    .PC_IN  (PC_IN  ),
    .PCEn   (PCEn   ),
    .clk    (clk    ),
    .rst    (rst    ),
    .PC_OUT (PC_OUT )
);

MUX4 uPC_IN_MUX4(
    .Sel (PCSrc ),
    .In1 (ALUResult ),
    .In2 (ALUOut ),
    .In3 ({PC_OUT[31:28],Jump_shifter_out}),
    .In4 (ALUResult ),
    .Out (PC_IN )
);

LEFT_SHIFTER #(
    .NumOfShifts     (NumOfShifts_JUMP     ),
    .InputDataWidth  ('d26  ),
    .OutputDataWidth ('d28 )
)
uJump_LEFT_SHIFTER(
    .In  (instr[25:0]  ),
    .Out (Jump_shifter_out )
);




    
endmodule