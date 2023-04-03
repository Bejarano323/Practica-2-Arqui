/******************************************************************
* Description
*	This is control unit for the RISC-V Microprocessor. The control unit is 
*	in charge of generation of the control signals. Its only input 
*	corresponds to opcode from the instruction bus.
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/
module Control
(
	input [6:0]OP_i,
	
	
	output Branch_o,
	output Mem_Read_o,
	output Mem_to_Reg_o,
	output Mem_Write_o,
	output ALU_Src_o,
	output Reg_Write_o,
	output [2:0]ALU_Op_o,
	output Jalr_o
);

localparam R_Type =7'h33; /*valor del upcode de las instrucciones tipo R*/	//add, sub, and, or, xor, sll, srl
localparam I_Type_LOGIC= 7'h13; //addi, ori, slli, srli, andi, xori
//agregamos las intrucciones de tipo U
localparam U_Type=7'h37; //lui
//practica 2
//instrucciones necesarias
localparam B_Type=7'h63; 		//beq, bne, bge, blt, tipo branch
localparam I_Type_Lw=7'h03;	//lw
localparam S_Type_Sw=7'h23; 	//sw
localparam J_Type=7'h6F; 		//jal
localparam I_Type_Jalr= 7'h67;	//jalr



reg [9:0] control_values;

always@(OP_i) begin
	case(OP_i)//                          	9_876_54_3_210
		R_Type: 			control_values = 10'b0_001_00_0_000; /*los 3 primeros bits se asignan al alu_op, tercero va al alu source, cuarto a memory write, etc.*/
		I_Type_LOGIC:	control_values = 10'b0_001_00_1_001;
		U_Type:			control_values = 10'b0_001_00_1_010;
		//practica 2
		B_Type: 			control_values = 10'b0_100_00_0_011;
		I_Type_Lw:		control_values = 10'b0_011_10_1_100; 
		S_Type_Sw:		control_values = 10'b0_000_01_1_101; 
		J_Type:			control_values = 10'b0_101_00_1_110; 
		I_Type_Jalr:	control_values = 10'b1_101_00_1_111;
		
		default:
			control_values= 10'b0_000_00_000;
		endcase
end	

assign Jalr_o = control_values[9];

assign Branch_o = control_values[8];

assign Mem_to_Reg_o = control_values[7];

assign Reg_Write_o = control_values[6];

assign Mem_Read_o = control_values[5];

assign Mem_Write_o = control_values[4];

assign ALU_Src_o = control_values[3];

assign ALU_Op_o = control_values[2:0];	

endmodule


