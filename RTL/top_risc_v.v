module top_risc_v(
	input  wire 		clk , rst , 
	output wire [31:0] alu_result
	// output logic 
);

wire [31:0] w_read_data;
wire [31:0] w_write_data;
wire [31:0] w_pc_plus_4;
wire [31:0] w_imm_ext;
wire [31:0] w_instr;
wire [31:0] w_result;
wire [31:0] w_pc_target;
wire [31:0] w_pc_out;
wire [31:0] w_pc_in_next; 
wire [31:0] w_rd1_src_a , w_src_b , w_rd2 , w_alu_result , w_addr;

wire [2:0] w_alu_control;
wire [1 :0] w_imm_src;
wire        w_branch , w_result_src , w_en_mem_write , w_alu_src, w_en_reg_write , w_zero;

assign w_pc_plus_4 = w_pc_out + 4;
assign w_src_b = w_alu_src ? w_imm_ext : w_rd2;
assign w_result = w_result_src ? w_read_data : w_alu_result;
assign w_pc_target = w_pc_out + w_imm_ext;
// assign pc_src = w_branch & w_zero;
assign w_pc_in_next = (w_branch & w_zero) ? w_pc_target : w_pc_plus_4;

assign alu_result = w_alu_result;

// assign w_branch = 0;
// assign w_result_src = 0;
// assign w_en_mem_write = 0;
// assign w_alu_src = 1;
// assign w_en_reg_write = 1;
// assign w_imm_src = 2'b00;
// assign w_alu_control = 3'b000;


//////mem_data////////
mem_data mem_data_c(
.clk(clk),
.we(w_en_mem_write),
.addr(w_alu_result),
.wd(w_rd2),
.rd(w_read_data)
);

/////////reg_file//////
reg_file reg_file_c(
.clk(clk),
.rst(rst),
.we3(w_en_reg_write),
.a1(w_instr[19:15]),
.a2(w_instr[24:20]),
.a3(w_instr[11:7]),
.wd3(w_result),
.rd1(w_rd1_src_a),
.rd2(w_rd2)
);

//////pc_32///////
pc_32 pc_c(
.clk(clk),
.rst(rst),
.pc_in_next(w_pc_in_next),
.pc_out(w_pc_out)
);

/////mem_instr/////
mem_instr mem_instr_c(
.in_instr_addr(w_pc_out),
.out_instr_read(w_instr)
);

//////////alu///////
alu alu_c(
.src_a(w_rd1_src_a),
.src_b(w_src_b),
.alu_control(w_alu_control),
.alu_result(w_alu_result),
.zero(w_zero)
);

/////////sign_extend///////
sign_ext sign_ext_c(
.sign_in(w_instr),
.imm_src_control(w_imm_src),
.sign_out(w_imm_ext)
);

//-------------control_unit-----------------//
control_unit control_unit_c(
.opcode(w_instr[6:0]),
.funct3(w_instr[14:12]),
.funct7(w_instr[31:25]),     // في المرجع مكتوب 30 فقط
.branch(w_branch),
.result_src(w_result_src),
.en_mem_write(w_en_mem_write),
.alu_src(w_alu_src),
.en_reg_write(w_en_reg_write),
.imm_src(w_imm_src),
.alu_control(w_alu_control)
);

endmodule