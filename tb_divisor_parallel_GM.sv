`timescale 1 ns/100 ps


module tb_divisor_parallel_GM;
localparam T=20;
localparam tamanyo=32;

//INPUTS
logic CLK, RSTa, Start;
logic  [tamanyo-1:0] Num, Den;

//OUTPUTS
logic  [tamanyo-1:0] Coc, Res;
logic Done;

//Device Under Verification
Divisor_Algoritmico DUV(.*);

initial begin CLK = 1'b0;
forever #(T/2)  CLK = !CLK;
end

initial
begin
    reset();
    Start = 0;

    #(T*5)
    CASO(-50,2,-25,0); // Positivo Postivo / Resto = 0   
    
    #(T*5)
    CASO(7,2,3,1);   // Positivo Postivo / Resto != 0
    
	 
	 #(T*5)
    CASO(25,-5,-5,0);  // Positivo Negativo / Resto = 0
   
	 
	 #(T*5)
    CASO(-50,10,-5,0);  // Negativo Positivo / Resto = 0
	 
	 #(T*5)
    CASO(7,0,3,1);   // Positivo Postivo / Resto != 0
    
	 
	 #(T*5)
    CASO(-8,-4,2,0);  // Negativo Negativo / Resto = 0
   
    $stop;


end

//TASK

//RESET
//Los cambios son realizados en el flanco de bajada del CLK para aportar
//mas estabilidad al hardware
task reset;
begin
	@(negedge CLK)
	RSTa = 0;
	repeat(10) @(negedge CLK);
	RSTa = 1;
	
end
endtask 

task cargar;
input [tamanyo-1:0] Num_user;
input [tamanyo-1:0] Den_user;
begin
    Num = Num_user;
    Den = Den_user;
end 
endtask

task CASO;
input [tamanyo-1:0] Num_user_Case;
input [tamanyo-1:0] Den_user_Case;
input [tamanyo-1:0] Coc_user_Case;
input [tamanyo-1:0] Res_user_Case;
begin
	 @(negedge CLK)
    cargar(Num_user_Case,Den_user_Case);

    @(negedge CLK)
    Start = 1;

    @(posedge Done)
	
    assert(Coc==Coc_user_Case && Res==Res_user_Case)
    else
        $error("Ha habido un error. El resultado no es correcto");
		  
    @(negedge CLK)
	 Start=0;
end
endtask

    
endmodule