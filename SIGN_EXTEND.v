module SIGN_EXTEND #(parameter Repeat =16 )(
    input wire [15:0] Inst,
    output wire [31:0] Signimm
);
wire [Repeat-1:0] Sign;

assign Sign={Repeat {Inst[15]}};

assign Signimm={Sign,Inst};
    
endmodule