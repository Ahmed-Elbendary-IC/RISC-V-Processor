module mem_instr #(parameter width   = 32,
				   parameter w_depth = 6 )(
	input  wire  [31:0] in_instr_addr,
	output wire  [31:0] out_instr_read
);

reg [width -1 :0] m_instr [0: 2**w_depth -1];

integer i;

initial 
	begin
		// for(i = 0 ; i < (2**w_depth) ; i++) begin
			// mem_instr[i] = 32'h00000000; end
	
		m_instr[0] = 32'h00500093;  // addi x1, x0, 5
		m_instr[1] = 32'h00300113;  // addi x2, x0, 3
		
		// R-type
		m_instr[2]  = 32'h002081B3;  // add  x3, x1, x2       => 8
		m_instr[3]  = 32'h40208233;  // sub  x4, x1, x2       => 2
		m_instr[4]  = 32'h0020F2B3;  // and  x5, x1, x2       => 1
		m_instr[5]  = 32'h0020E333;  // or   x6, x1, x2       => 7
		m_instr[6]  = 32'h0020C3B3;  // xor  x7, x1, x2       => 6
		m_instr[7]  = 32'h0020A433;  // slt  x8, x1, x2       => 0
		
		// ADDI negative
		m_instr[8]  = 32'hFFF00293;  // addi x5, x0, -1       => -1

		// LW / SW
		m_instr[9]  = 32'h00102223;  // sw x1, 4(x0)
		m_instr[10] = 32'h00402303;  // lw x6, 4(x0)

		// NOP
		m_instr[11] = 32'h00000000;
		

	end


assign out_instr_read = m_instr[in_instr_addr >> 2];

endmodule
