//高斯消元获得P矩阵，然后将P矩阵与信息位做乘法即可得到校验码字
`timescale 1 ns/ 1 ps
module ldpc_encoder(
	clk,
	rst_n,
	msg,
	code
	);

	input  		  clk;													// 系统时钟 50MHz
	input  		  rst_n;												// 复位信号，低电平有效
	input  [3:0]  msg;													// 信息序列 
	output [11:0] code;													// 编码序列 

    
	reg clk_count;
	always@(posedge clk or negedge rst_n)
	begin
		if(rst_n == 1'b0)
			clk_count <= #1 1'b0;
		else
			clk_count <= #1 clk_count + 1'b1;
	end
	reg [7:0] check;													// 鏍￠獙搴忓垪
	always@(posedge clk or negedge rst_n)
	begin
		if(rst_n == 1'b0)
			check     <= #1 8'b0;
		else
		begin
			if(clk_count == 1'd0)
			begin														// msg涓嶱鐭╅樀杩涜杩愮畻 鑾峰緱鏍￠獙搴忓垪								
				check[7]  <= #1 msg[3]+msg[2]+msg[1];
				check[6]  <= #1 msg[2]+msg[0];
				check[5]  <= #1 msg[0];
				check[4]  <= #1 msg[3]+msg[2]+msg[1];
				check[3]  <= #1 msg[3]+msg[2]+msg[1];
				check[2]  <= #1 msg[2];
				check[1]  <= #1 msg[2]+msg[1]+msg[0];
				check[0]  <= #1 msg[2]+msg[1]+msg[0];
			end
			else
				check <= #1 8'b0;
		end
	end
	// 杩涜鍒楀彉鎹㈣繕鍘熷苟杈撳嚭缂栫爜鍚庣爜瀛?	|0 0 0 0 0 0 0 9|  u=[c | s] 
	reg [11:0] code;													
	always@(posedge clk or negedge rst_n)
	begin
		if(rst_n == 1'b0)
			code <= #1 12'b0;
		else
		begin
			if(clk_count == 1'b1)
				code <= #1 {check[7:1],msg[3],check[0],msg[2:0]}; 	// 搴忓垪绗?8浣嶄笌绗?9浣嶈繘琛屼氦鎹? 浠庝綆寰?楂樻暟 鏈?鍚庤緭鍑虹紪鐮佸悗鐮佸瓧		
			else
				code  <= #1 code;			
		end
	end
endmodule
