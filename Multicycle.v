module Multicycle #(
    parameter Data_Size ='d32
) (
    input  wire  CLK_Top,
    input  wire  RST_Top,
    output  wire [31:0] Test_Top
    //!output wire [31:0] REData, 
    //!output wire [31:0] Address
);
wire [Data_Size-1:0] instr_Top,Data_Top ,RD2_REG_Top,PC_OUT_Top,ALUOut_Top ;
wire [Data_Size-1:0] Address,REData;
wire IRWrite_Top,MemWrite_Top,IorD_Top,MemtoReg_Top,RegDst_Top,ALUSrcA_Top;
wire [1:0] PCSrc_Top;
wire PCEn_Top,PCWrite_Top,Branch_Top,ZeroFlag_Top,RegWrite_Top;
wire [2:0]ALUControl_Top;
wire [1:0] ALUScrB_Top;
assign PCEn_Top=(Branch_Top & ZeroFlag_Top) |(PCWrite_Top);

MUX uMemoryAdr_MUX(
    .Sel (IorD_Top ),
    .In1 (PC_OUT_Top ),
    .In2 (ALUOut_Top ),
    .Out (Address )
);


MEMORY u_MEMORY(
    .Address  (Address  ), 
    .WRData   (RD2_REG_Top   ),
    .WREnable (MemWrite_Top ),
    .clk      (CLK_Top      ),
    .rst      (RST_Top      ),
    .Test     (Test_Top),
    .REData   (REData   )
);

REGISTER uDATA_REGISTER(
    .WRData   (REData   ),
    .WREnable (1'b1 ),
    .clk      (CLK_Top      ),
    .rst      (RST_Top      ),
    .REData   (Data_Top   )
);
REGISTER uInstr_REGISTER(
    .WRData   (REData   ),
    .WREnable (IRWrite_Top ),
    .clk      (CLK_Top      ),
    .rst      (RST_Top      ),
    .REData   (instr_Top   )
);



Control_Unit u_Control_Unit(
    .clk        (CLK_Top        ),
    .rst        (RST_Top        ),
    .Opcode     (instr_Top[31:26]     ),
    .Funct      (instr_Top[5:0]      ),
    .MemtoReg   (MemtoReg_Top   ),
    .RegDst     (RegDst_Top     ),
    .IorD       (IorD_Top      ),
    .PCSrc      (PCSrc_Top      ),
    .ALUScrB    (ALUScrB_Top    ),
    .ALUSrcA    (ALUSrcA_Top    ),
    .IRWrite    (IRWrite_Top    ),
    .MemWrite   (MemWrite_Top   ),
    .PCWrite    (PCWrite_Top    ),
    .Branch     (Branch_Top     ),
    .RegWrite   (RegWrite_Top   ),
    .ALUControl (ALUControl_Top )
);

    Data_Path u_Data_Path(
    	.instr      (instr_Top[25:0]      ),
        .Data       (Data_Top       ),
        .clk        (CLK_Top        ),
        .rst        (RST_Top        ),
        .MemtoReg   (MemtoReg_Top   ),
        .RegDst     (RegDst_Top     ),
        .PCSrc      (PCSrc_Top      ),
        .ALUScrB    (ALUScrB_Top    ),
        .ALUSrcA    (ALUSrcA_Top    ),
        .RegWrite   (RegWrite_Top   ),
        .ALUControl (ALUControl_Top ),
        .PCEn       (PCEn_Top       ),
        .ZeroFlag   (ZeroFlag_Top   ),
        .RD2_REG    (RD2_REG_Top),
        .ALUOut     (ALUOut_Top),
        .PC_OUT     (PC_OUT_Top     )
    );
    
endmodule