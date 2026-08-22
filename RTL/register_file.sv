module reg_file #(parameter width   = 32,
				  parameter w_depth = 6 )(
	input  logic 	   clk, rst,
	input  logic 	   we3,
	input  logic [4 :0] a1 , a2 , a3,
	input  logic [31:0] wd3,
	output logic [31:0] rd1,
	output logic [31:0] rd2
);

reg [width -1 :0] rf [0: 2**w_depth -1];
integer i;

always @(posedge clk or posedge rst )
	begin
		if(rst)
			begin 
				for(i = 0 ; i < (2**w_depth) ; i = i +1)
					rf[i] <= 0;
			end
			
		else if(we3) 							// if (write_enable_register_file = 1)   
			begin
				rf[a3] <= wd3;				// write in register_file depending on address (a3) 
			end
	end
	
assign rd1 = rf[a1];		 // read from port rd1
assign rd2 = rf[a2];		 // read from port rd2

endmodule