//��˹��Ԫ���P����Ȼ��P��������Ϣλ���˷����ɵõ�У������
`timescale 1 ns/ 1 ps
module ldpc_encoder(
	clk,
	rst_n,
	msg,
	code
	);

	input  		  clk;													// ϵͳʱ�� 50MHz
	input  		  rst_n;												// ��λ�źţ��͵�ƽ��Ч
	input  [3:0]  msg;													// ��Ϣ���� 
	output [11:0] code;													// �������� 

    
	reg clk_count;
	always@(posedge clk or negedge rst_n)
	begin
		if(rst_n == 1'b0)
			clk_count <= #1 1'b0;
		else
			clk_count <= #1 clk_count + 1'b1;
	end
	reg [7:0] check;													// 校验序列
	always@(posedge clk or negedge rst_n)
	begin
		if(rst_n == 1'b0)
			check     <= #1 8'b0;
		else
		begin
			if(clk_count == 1'd0)
			begin														// msg与P矩阵进行运算 获得校验序列								
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
	// 进行列变换还原并输出编码后码�?	|0 0 0 0 0 0 0 9|  u=[c | s] 
	reg [11:0] code;													
	always@(posedge clk or negedge rst_n)
	begin
		if(rst_n == 1'b0)
			code <= #1 12'b0;
		else
		begin
			if(clk_count == 1'b1)
				code <= #1 {check[7:1],msg[3],check[0],msg[2:0]}; 	// 序列�?8位与�?9位进行交�? 从低�?高数 �?后输出编码后码字		
			else
				code  <= #1 code;			
		end
	end
endmodule
