module tb_top_risc_v;

reg clk , rst;
wire [31:0] alu_out;

top_risc_v top_uut(
.clk(clk),
.rst(rst),
.alu_result(alu_out)
);

always #5 clk = ~clk;

//======================task========================//
task check;

	input [31:0] expected;
	input [31:0] actual;
		begin
			if(expected == actual)
				$display("pass");
			else
				$display("fail: expected = %d , actual =%d" , expected , alu_out);
		end
endtask


initial 
	begin
		clk = 0;
		rst = 1;
		
		#10;
		rst = 0;
		
		#10;
		check(5, top_uut.reg_file_c.rf[1]);				 //addi x1 = 5
		
		#10;
		check(3, top_uut.reg_file_c.rf[2]); 			//addi x2 = 3
		
		#10;
		check(8, top_uut.reg_file_c.rf[3]); 			//add
		
		#10;
		check(2, top_uut.reg_file_c.rf[4]); 			//sub
		
		#10;
		check(1, top_uut.reg_file_c.rf[5]); 			//and
		
		#10;
		check(7, top_uut.reg_file_c.rf[6]); 			//or 
		
		#10;
		check(6, top_uut.reg_file_c.rf[7]); 			//xor
		
		#10;
		check(0, top_uut.reg_file_c.rf[8]); 			//slt x8 =0
		
		#10;
		check(32'hffffffff, top_uut.reg_file_c.rf[5]);  //addi x5 = -1
		
		#10;
		check(5, top_uut.reg_file_c.rf[6]);             // lw x6 =5
		
		#200;
		$finish;
	end
	
initial begin
	$monitor("time = %0t | rst=%b |pc=%h | instr=%h | rd1=%d | rd2=%d | imm=%d | alu_out = %d | x1=%d | x2=%d | x3=%d | x4=%d | x5=%d | x6=%d | x7=%d | x8=%d", 
			$time , rst , top_uut.w_pc_out, top_uut.w_instr,  top_uut.w_rd1_src_a, top_uut.w_rd2 , top_uut.w_imm_ext , top_uut.w_alu_result,
			    top_uut.reg_file_c.rf[1],
				top_uut.reg_file_c.rf[2],
				top_uut.reg_file_c.rf[3],
				top_uut.reg_file_c.rf[4],
				top_uut.reg_file_c.rf[5],
				top_uut.reg_file_c.rf[6],
				top_uut.reg_file_c.rf[7],
				top_uut.reg_file_c.rf[8]);
		end
// initial begin
	// $monitor("",
				// );
	// end

	
endmodule

