/******************************************************************
* Description
*	This module performs a sign extension operation that is need with
*	in instruction like andi and constructs the immediate constant.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/
module Immediate_Unit
(   
	input [6:0] op_i,
	input [31:0]  Instruction_bus_i,
	
   output reg [31:0] Immediate_o
);



always@(op_i or Instruction_bus_i) begin

	if(op_i == 7'h13 || op_i == 7'h67|| op_i == 7'h03) //jal, lw son tipo I
		Immediate_o = {{20{Instruction_bus_i[31]}},Instruction_bus_i[31:20]};// I format operador de repetición
	else if(op_i == 7'h37) 		//tipo U
		Immediate_o = {Instruction_bus_i[31:12],{12{1'b0}}};
	else if(op_i == 7'h63)		//tipo B												
		Immediate_o = {{19{Instruction_bus_i[31]}},Instruction_bus_i[31],Instruction_bus_i[7],Instruction_bus_i[30:25], Instruction_bus_i[11:8], 1'b0};
	else if(op_i == 7'h23)		//tipo S
		Immediate_o = {{20{Instruction_bus_i[31]}},Instruction_bus_i[31:25], Instruction_bus_i[11:7]};
	else if(op_i == 7'h6F)		//tipo J
		Immediate_o = {{11{Instruction_bus_i[31]}},Instruction_bus_i[31], Instruction_bus_i[19:12],Instruction_bus_i[20],Instruction_bus_i[30:21], 1'b0};
		
	else						//se replica instruction bus[31] por 20 veces, más los 12 de la instrucción 12
		Immediate_o = 0;	//se tienen los 32 de la salida del immediate unit
end


endmodule // signExtend
