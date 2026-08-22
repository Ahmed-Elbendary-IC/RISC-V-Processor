
/********************************** top_control_unit ********************************/

module control_unit(
	input  wire [6:0] opcode,
	input  wire [2:0] funct3,
	input  wire [6:0] funct7,
	output reg 	   	  branch,
	output reg	   	  result_src,
	output reg	   	  en_mem_write,
	output reg	   	  alu_src,
	output reg 	   	  en_reg_write, 
	output reg [1:0] imm_src , 
	output reg [2:0] alu_control 
	
);

reg [1:0] alu_op;

always @(*)
	begin
		case(opcode)
			7'b0000011: begin en_reg_write = 1; imm_src = 2'b00; alu_src = 1; 
							  en_mem_write = 0; result_src = 1; branch =0; alu_op = 2'b00;  //lw
						end
			7'b0100011: begin en_reg_write = 0; imm_src = 2'b01; alu_src = 1; 
							  en_mem_write = 1; result_src = 0; branch =0; alu_op = 2'b00;  //sw
						end
			7'b0110011: begin en_reg_write = 1; imm_src = 2'b00; alu_src = 0; 
							  en_mem_write = 0; result_src = 0; branch =0; alu_op = 2'b10;  //r_typr
						end
			7'b1100011: begin en_reg_write = 0; imm_src = 2'b10; alu_src = 0; 
							  en_mem_write = 0; result_src = 0; branch =1; alu_op = 2'b01;  //beq
						end
			7'b0010011: begin
							  en_reg_write = 1; imm_src = 2'b00; alu_src = 1;
							  en_mem_write = 0; result_src = 0; branch = 0; alu_op = 2'b00; //addi
                        end
			default: begin en_reg_write = 0; imm_src = 2'b00; alu_src = 0; 
							  en_mem_write = 0; result_src = 0; branch =0; alu_op = 2'b00;  
						end
		endcase
	end
	
	
always @(*)
	begin
		if(alu_op == 2'b00)
			begin
				alu_control = 3'b000;      //add (lw , sw)
			end
		else if(alu_op == 2'b01)
			begin
				alu_control = 3'b001;      //sub (beq)
			end
		else if (alu_op == 2'b10)
			begin
				case(funct3)
					3'b000 : alu_control = (funct7[5] == 1) ? 3'b001 : 3'b000; //sub or add
					3'b010 : alu_control = 3'b101; 			// slt
					3'b110 : alu_control = 3'b011; 			//or
					3'b111 : alu_control = 3'b010; 			//and
					// 3'b100 : alu_control = 3'b100;
				   default : alu_control = 0;
				endcase
			end
			
	end
	

// main_decoder main_decoder_c(
// .opcode(w_opcode),
// .imm_src(w_imm_src),
// .alu_op(w_alu_op),
// .branch(w_branch),
// .result_src(w_result_src),
// .en_mem_write(w_en_mem_write),
// .alu_src(w_alu_src),
// .en_reg_write(w_en_reg_write)
// );

// alu_decoder alu_decoder_c(
// .funct3(w_funct3),
// .funct7(w_funct7),
// .alu_op(w_alu_op),
// .alu_control(w_alu_control)
// );
endmodule

/*----------------------------------- main_decoder------------------------------------ */

// module main_decoder(
	// input  wire [6:0] opcode,
	// output reg [1:0] imm_src ,
	// output reg [1:0] alu_op,
	// output reg  branch , 
	// output reg result_src , 
	// output reg en_mem_write ,
	// output reg alu_src , 
	// output reg en_reg_write 
// );



// endmodule

/*----------------------------------- alu_decoder------------------------------------ */

// module alu_decoder(
	// input  wire [2:0] funct3,
	// input  wire [6:0] funct7,
	// input  wire [1:0] alu_op,
	// output reg  [2:0] alu_control
// );



// endmodule