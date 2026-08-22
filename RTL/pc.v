module pc_32 #(parameter width = 32)(
	input  wire clk , rst, 
	input  wire [width - 1 : 0] pc_in_next,
	output reg [width - 1 : 0] pc_out 
);

always @(posedge clk or posedge rst) 
	begin
		if(rst)
			begin
				pc_out <= 32'd0;
			end
		else 
			begin
				pc_out <= pc_in_next;
			end
	end
endmodule