module sign_ext(
	input  logic [31:0] sign_in,
	input  logic [1 :0] imm_src_control,
	output logic [31:0] sign_out
);

// assign sign_out = {{20{sign_in[11]}} , sign_in};

always @(*)
	begin
		// if(imm_src_control)				//sw(s_type)
			// begin
				// sign_out = {{20{instr[31]}} , instr[31:25] , instr[11:7]};
			// end
		// else							//lw(i_type)
			// begin
				// sign_out = {{20{instr[31]}} , instr[31:20]};
			// end
		case(imm_src_control)
			2'b00: sign_out = {{20{sign_in[31]}} , sign_in[31:20]};							           //lw(i_type)	12-bit		
			2'b01: sign_out = {{20{sign_in[31]}} , sign_in[31:25] , sign_in[11:7]};                      //sw(s_type) 12-bit
			2'b10: sign_out = {{20{sign_in[31]}} ,sign_in[7]      , sign_in[30:25] , sign_in[11:8], 1'b0}; //beq(b_type)13-bit
		  // default: sign_out = 0;
		endcase
	end

endmodule