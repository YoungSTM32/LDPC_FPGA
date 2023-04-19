`timescale 1 ns/ 1 ps
module ldpc_top(
	clk,
	rst_n,
	msg,
	code,
	re_msg
);

	input  clk;															// ϵͳʱ�� 50MHz
	input  rst_n;														// ��λ�źţ��͵�ƽ��Ч
	input  [3:0]  msg;													// ��Ϣ���� 
	output [11:0] code;													// �������� 
	output [3:0]  re_msg;												// �����ԭ����Ϣ����
	wire   [11:0] code;
	
	ldpc_encoder    ldpc_encoder_1(
        .clk				(   clk			        ),    
		.rst_n				(   rst_n		        ),  
		.msg				(   msg			        ),  
		.code				(   code		        ) 
		);
		
	ldpc_decoder    ldpc_decoder_1(
        .clk				(   clk			        ),    
		.rst_n				(   rst_n		        ),  
		.code				(   code		        ), 
		.msg				(   re_msg		        )  	
		);
		
endmodule
		