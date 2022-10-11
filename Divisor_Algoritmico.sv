module Divisor_Algoritmico
 

#(parameter tamanyo=32)           
(input CLK,
input RSTa,
input Start,
input logic [tamanyo-1:0] Num,
input logic [tamanyo-1:0] Den,

output logic [tamanyo-1:0] Coc,
output logic [tamanyo-1:0] Res,
output reg Done);

enum logic [1:0] {D0, D1, D2,D3} state;

logic SignNum, SignDen;
logic [$clog2(tamanyo)-1:0] CONT; // Especificar tamaño del cont
logic [tamanyo-1:0] ACCU, Q, M;

always_ff @(posedge CLK, negedge RSTa)
	if(!RSTa)
		begin
		Done <= 1'b0;
		state <= D0;
		ACCU <= 0;
		CONT <= 0;
		SignNum <= 1'b0;
		SignDen <= 1'b0;
		Q <= 0;
		M <= 0;
		Coc <= 0;
		Res <= 0;
		end
	else
	
	// Definimos valores por defecto de las salidas
	// Cambio de estados y lógica de salidas
	case(state)
	
		D0:
			begin
			Done <= 1'b0;
			if(Start)
				begin
					state <= D1;
					ACCU <= 1'b0;
					CONT <= tamanyo-1;
					SignNum <= Num[tamanyo-1];
					SignDen <= Num[tamanyo-1];
					Q <= Num[tamanyo-1]? (~Num+1):Num;
					M <= Den[tamanyo-1]? (~Den+1):Den;
				end
			else
				state <= D0;
			end
			
			
		D1: 
			begin
			state <= D2;
			{ACCU,Q} <= {ACCU[tamanyo-2:0], Q, 1'b0};
			end
			
			
		D2:
			begin
			CONT <= CONT-1;
			if(CONT == 0)
				begin
				state <= D3;
				if(ACCU>=M)
					begin
					Q <= Q+1;
					ACCU <= ACCU-M;
					end
				end
			else
				begin
				state <= D1;
				if(ACCU>=M)
					begin                      //OPTIMIZAR
					Q <= Q+1;
					ACCU <= ACCU-M;
					end
				end
			end
			
			
		D3:
			begin
			state <= D0;
			Coc <= (SignNum^SignDen)? (~Q+1):Q;
			Res <= SignNum? (~ACCU+1):ACCU;
			Done <= 1'b1;
			end
		default: state <= D0;		
	endcase
//	
	
	endmodule
