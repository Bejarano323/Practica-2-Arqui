/******************************************************************
* Description
*	This is an 32-bit arithetic logic unit that can execute the next set of operations:
*		add

* This ALU is written by using behavioral description.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/

module ALU 
(
	input [3:0] ALU_Operation_i,
	input signed [31:0] A_i,
	input signed [31:0] B_i,
	input [31:0] pc_p_4,
	output reg Zero_o,
	output reg [31:0] ALU_Result_o,
	output reg Jal_Alu_o,
	output reg Jalr_Alu_o
);

localparam ADD =4'b0000;
//vienen del ALu control
localparam LUI	=4'b0001;
localparam ORI = 4'b0010;
localparam SLLI= 4'b0011;
localparam SRLI= 4'b0100;
localparam SUB = 4'b0101;

localparam And = 4'b0110;
localparam Xor = 4'b0111;

localparam Beq = 4'b1000;
localparam Bne = 4'b1001;
localparam Bge = 4'b1010;
localparam Blt = 4'b1011;

localparam Jal  = 4'b1100;
localparam Jalr = 4'b1101;

localparam Lw 	 = 4'b1110;
localparam Sw 	 = 4'b1111;

   
   always @ (A_i or B_i or ALU_Operation_i)
     begin
	  Jal_Alu_o=0;
	  Jalr_Alu_o=0;
		case (ALU_Operation_i)
		ADD: ALU_Result_o = A_i+B_i;
		LUI: ALU_Result_o = B_i;
		ORI: ALU_Result_o = A_i|B_i;
		
		SLLI:ALU_Result_o = A_i<<B_i[4:0];
		SRLI:ALU_Result_o = A_i>>B_i[4:0];
		SUB: ALU_Result_o = A_i-B_i;
		
		And:	ALU_Result_o = A_i & B_i;
		Xor: ALU_Result_o = A_i ^ B_i;
		
		Beq: ALU_Result_o = (A_i == B_i) ? 32'b0 : 32'b1;
		Bne: ALU_Result_o = (A_i != B_i) ? 32'b0 : 32'b1;
		Bge: ALU_Result_o = (A_i >= B_i) ? 1'b1 : 1'b0;
		Blt: ALU_Result_o = (A_i < B_i) ? 32'b1 : 32'b0;
		
		Jal: ALU_Result_o = 32'b0;
		Jalr: ALU_Result_o = A_i + B_i;
		
		Lw: ALU_Result_o = A_i + B_i;
		Sw: ALU_Result_o = A_i + B_i;
		
		default:
			ALU_Result_o = 0;
		endcase // case(control)
		
		Zero_o = (ALU_Result_o == 0) ? 1'b1 : 1'b0;
		
     end // always @ (A or B or control)
endmodule // ALU