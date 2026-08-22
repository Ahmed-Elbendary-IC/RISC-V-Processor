module alu(
	input  logic [31:0] src_a ,
	input  logic [31:0] src_b , 
	input  logic [2 :0] alu_control,
	output logic [31:0] alu_result,
	output logic zero
);

always @(*)
	begin
		case(alu_control)
			3'b000: alu_result = src_a + src_b;
			3'b001: alu_result = src_a - src_b;
			3'b010: alu_result = src_a & src_b;
			3'b011: alu_result = src_a | src_b;
			3'b100: alu_result = src_a ^ src_b;
			3'b101: alu_result = (src_a < src_b) ? 32'd1 : 32'd0;
		   default: alu_result = 32'd0;
		endcase
	end
	
assign zero = ~| alu_result;	

endmodule