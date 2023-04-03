/******************************************************************
* Description
*	This is the control unit for the ALU. It receves a signal called 
*	ALUOp from the control unit and signals called funct7 and funct3  from
*	the instruction bus.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/
module ALU_Control
(
	input funct7_i, 
	input [2:0] ALU_Op_i,
	input [2:0] funct3_i,
	

	output [3:0] ALU_Operation_o

);
localparam R_Type_ADD =7'b0_000_000; /*valor del upcode de las instrucciones tipo R*/
localparam I_Type_ADDI= 7'bx_001_000; /*al no existir valor de funct7 la x indica que puede tomar el valor que sea (0 o 1)*/
//modificaciones de las instrucciones
//7'b(bit 30)_(numeros del tip de insrtucción definidos en control)_funct3
localparam U_Type_LUI	=7'bx_010_xxx;
localparam I_Type_ORI	=7'bx_001_110;
localparam I_Type_SLLI	=7'b0_001_001;
localparam I_Type_SRLI	=7'b0_001_101;
localparam R_Type_SUB	=7'b1_000_000;
//practica 2
//and y andi
localparam R_Type_And	=7'b0_000_111;
localparam I_Type_Andi	=7'bx_001_111;
//or, xor y xori
localparam R_Type_Or		=7'b0_000_110;
localparam R_Type_XOr	=7'b0_000_100;
localparam I_Type_Xori	=7'bx_001_100;
//srl y sll
localparam R_Type_Sll	=7'b0_000_001;
localparam R_Type_Srl	=7'b0_000_101;
//branching
localparam B_Type_Beq	=7'bx_011_000;
localparam B_Type_Bne	=7'bx_011_001;
localparam B_Type_Bge	=7'bx_011_101;
localparam B_Type_Blt	=7'bx_011_100;
//load y store
localparam I_Type_Lw		=7'bx_100_010;
localparam S_Type_Sw		=7'bx_101_010;
//jal y jalr
localparam J_Type_Jal	=7'bx_110_xxx; //no tiene opcode
localparam I_Type_Jalr	=7'bx_111_000;



reg [3:0] alu_control_values;
wire [6:0] selector;

assign selector = {funct7_i, ALU_Op_i, funct3_i};

always@(selector)begin
	casex(selector)
		R_Type_ADD: 	alu_control_values=4'b0000;
		I_Type_ADDI:	alu_control_values=4'b0000;
		//las añadimos al selector par decidir la operación
		U_Type_LUI:		alu_control_values=4'b0001;
		R_Type_Or:		alu_control_values=4'b0001;
		I_Type_ORI:		alu_control_values=4'b0010;
		I_Type_SLLI:	alu_control_values=4'b0011;
		R_Type_Sll:		alu_control_values=4'b0011;
		I_Type_SRLI:	alu_control_values=4'b0100;
		R_Type_Srl:		alu_control_values=4'b0100;//identica a los immediate
		R_Type_SUB:		alu_control_values=4'b0101;
		//and y andi
		R_Type_And:		alu_control_values=4'b0110;
		I_Type_Andi:	alu_control_values=4'b0110;
		//xor y xori
		R_Type_XOr:		alu_control_values=4'b0111;
		I_Type_Xori:	alu_control_values=4'b0111;
		
		//branching
		B_Type_Beq:		alu_control_values=4'b1000;
		B_Type_Bne:		alu_control_values=4'b1001;
		B_Type_Bge:		alu_control_values=4'b1010;
		B_Type_Blt:		alu_control_values=4'b1011;
		//jal
		J_Type_Jal:		alu_control_values=4'b1100;
		I_Type_Jalr:	alu_control_values=4'b1101;
		//load y store
		I_Type_Lw:		alu_control_values=4'b1110;
		S_Type_Sw:		alu_control_values=4'b1111;
		
		

		default: alu_control_values = 4'b00_00;
	endcase
end


assign ALU_Operation_o = alu_control_values;



endmodule
