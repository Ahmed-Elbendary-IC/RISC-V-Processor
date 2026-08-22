module mem_data #(parameter width   = 32,
				  parameter w_depth = 6 )(
	input logic 		   clk,
	input logic 		   we,
	input logic [width -1 :0] addr,
	input logic [width -1 :0] wd ,
	output logic [width -1 :0] rd
);

reg [width -1 :0] m_data [0: 2**w_depth -1];

always @(posedge clk)						
	begin
		if(we)          					 // if (write_enable_memory_data = 1)                  
			begin
				m_data[addr >> 2] <= wd;   // write in memory
			end
	end
	
assign rd = m_data[addr >> 2];			 // read from memory

endmodule