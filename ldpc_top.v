`timescale 1 ns/ 1 ps
module ldpc_top(
	clk,
	rst_n,
	msg,
	code,
	re_msg
);

	input  clk;															// 系统时钟 50MHz
	input  rst_n;														// 复位信号，低电平有效
	input  [3:0]  msg;													// 信息序列 
	output [11:0] code;													// 编码序列 
	output [3:0]  re_msg;												// 译码后还原的信息序列
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
		