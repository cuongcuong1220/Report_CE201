typedef enum bit [2:0] 
{
    ADD_SEL = 3'b000,
    SUB_SEL = 3'b001,
    SHR_SEL = 3'b010,
    SHL_SEL = 3'b011,
	AND_SEL = 3'b100,
    OR_SEL =  3'b101,
    XOR_SEL = 3'b110,
    NOT_SEL = 3'b111
}   alu_sel_t;  
module alu(in0 , in1 , en, sel, out);
  input [7:0] in0, in1;
  input en;
  input alu_sel_t sel;
  output [15:0] out;
  reg [15:0] y;
  always@(sel,in1,in0) begin
    case(sel)
		ADD_SEL : y = in0 + in1;
        SUB_SEL : y = in0 - in1;
        SHR_SEL : y = in0 >> 1;
        SHL_SEL : y = in0 <<1;
        AND_SEL : y = in0 & in1;
        OR_SEL  : y = in0 | in1; 
        XOR_SEL : y = in0 ^ in1;
        NOT_SEL : y = ~in0;
endcase
end
assign out = (en == 1)? y:16'bz;
endmodule