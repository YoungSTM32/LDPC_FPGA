`timescale 1 ns/ 1 ps
module ldpc_decoder(
	clk,
	rst_n,
	code,
	msg
	);

	input  clk;															// 系统时钟 50MHz
	input  rst_n;														// 复位信号，低电平有效
	input  [11:0] code;													// 信息序列 
	output [3:0] msg;													// 编码序列 

	reg [4:0] clk_count;
	always@(posedge clk or negedge rst_n)								
	begin
		if(rst_n == 1'b0)
			clk_count <= #1 5'b0;
		else
		begin
			if(clk_count == 5'd25)
				clk_count <= #1 5'b0;
			else
				clk_count <= #1 clk_count + 1'b1;		
		end
	end
	
	reg [11:0] code_check;												// 对码字进行纠错后的码组
	reg [4:0]  state;
	reg [2:0]  s; 														// 校正子
	always@(posedge clk or negedge rst_n)
	begin
		if(rst_n == 1'b0)
		begin
			code_check   <= #1 12'b0;
			state <= #1 5'b0;
			s <= #1 3'b0;
		end
		else
		begin				
			if((clk_count >= 5'd1)&&(clk_count <= 5'd24))				//进行大数逻辑译码 计算每个比特的校正子 并进行判决
			begin
				case(state)   
				5'd0:begin 												// 计算code[11]
					s[2] <= #1 code[11]+code[7];
					s[1] <= #1 code[11]+code[9]+code[5]+code[4];
					s[0] <= #1 1'b0;
					state <= #1 5'd1;				
				end
				5'd1:begin 												// 判决code[11]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[11] <= #1 code[11];  				// code[11]有误 进行修改
					else
						code_check[11] <= #1 ~code[11];	 				// code[11]无误
					state <= #1 5'd2;				
				end
				5'd2:begin 												// 计算code[10]
					s[2] <= #1 code[10]+code[6]+code[0];
					s[1] <= #1 code[10]+code[5]+code[1];
					s[0] <= #1 code[10]+code[9]+code[2];	
					state <= #1 5'd3;				
				end
				5'd3:begin 												// 判决code[10]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[10] <= #1 code[10];  				// code[10]有误 进行修改
					else
						code_check[10] <= #1 ~code[10];	 				// code[10]无误
					state <= #1 5'd4;						
				end
			
				5'd4:begin 												// 计算code[9]
					s[2] <= #1 code[9]+code[6]+code[3]+code[1];
					s[1] <= #1 code[9]+code[5]+code[4];
					s[0] <= #1 code[9]+code[10]+code[2];		
					state <= #1 5'd5;				
				end
				5'd5:begin 												// 判决code[9]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[9] <= #1 code[9];  					// code[9]有误 进行修改
					else
						code_check[9] <= #1 ~code[9];	 				// code[9]无误
					state <= #1 5'd6;						
				end
			
				5'd6:begin 												// 计算code[8]
					s[2] <= #1 code[8]+code[7]+code[6]+code[2];
					s[1] <= #1 code[8]+code[4]+code[3]+code[0];
					s[0] <= #1 1'b0;		
					state <= #1 5'd7;				
				end
				5'd7:begin 												// 判决code[8]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[8] <= #1 code[8];  					// code[8]有误 进行修改
					else
						code_check[8] <= #1 ~code[8];	 				// code[8]无误
					state <= #1 5'd8;						
				end
			
				5'd8:begin 												// 计算code[7]
					s[2] <= #1 code[7]+code[8]+code[6]+code[2];
					s[1] <= #1 code[7]+code[11];
					s[0] <= #1 1'b0;		
					state <= #1 5'd9;				
				end
				5'd9:begin 												// 判决code[7]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[7] <= #1 code[7];  					// code[7]有误 进行修改
					else
						code_check[7] <= #1 ~code[7];	 				// code[7]无误
					state <= #1 5'd10;						
				end
			
				5'd10:begin 											// 计算code[6]
					s[2] <= #1 code[6]+code[9]+code[3]+code[1];
					s[1] <= #1 code[6]+code[10]+code[0];
					s[0] <= #1 code[6]+code[8]+code[7]+code[2];		
					state <= #1 5'd11;				
				end
				5'd11:begin 											// 判决code[6]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[6] <= #1 code[6];  					// code[6]有误 进行修改
					else
						code_check[6] <= #1 ~code[6];	 				// code[6]无误
					state <= #1 5'd12;						
				end
			
				5'd12:begin 											// 计算code[5]
					s[2] <= #1 code[5]+code[10]+code[1];
					s[1] <= #1 code[5]+code[11]+code[9]+code[4];
					s[0] <= #1 1'b0;		
					state <= #1 5'd13;				
				end
				5'd13:begin 											// 判决code[5]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[5] <= #1 code[5];  					// code[5]有误 进行修改
					else
						code_check[5] <= #1 ~code[5];	 				// code[5]无误
					state <= #1 5'd14;						
				end
			
				5'd14:begin 											// 计算code[4]
					s[2] <= #1 code[4]+code[8]+code[3]+code[0];
					s[1] <= #1 code[4]+code[11]+code[9]+code[5];
					s[0] <= #1 1'b0;		
					state <= #1 5'd15;				
				end
				5'd15:begin 											// 判决code[4]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[4] <= #1 code[4];  					// code[4]有误 进行修改
					else
						code_check[4] <= #1 ~code[4];	 				// code[4]无误
					state <= #1 5'd16;						
				end
				
				5'd16:begin 											// 计算code[3]
					s[2] <= #1 code[3]+code[9]+code[6]+code[1];
					s[1] <= #1 code[3]+code[8]+code[4]+code[0];
					s[0] <= #1 1'b0;		
					state <= #1 5'd17;				
				end
				5'd17:begin 											// 判决code[3]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[3] <= #1 code[3];  					// code[3]有误 进行修改
					else
						code_check[3] <= #1 ~code[3];	 				// code[3]无误
					state <= #1 5'd18;						
				end
				
				5'd18:begin 											// 计算code[2]
					s[2] <= #1 code[2]+code[8]+code[7]+code[6];
					s[1] <= #1 code[2]+code[10]+code[9];
					s[0] <= #1 1'b0;		
					state <= #1 5'd19;				
				end
				5'd19:begin 											// 判决code[2]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[2] <= #1 code[2];  					// code[2]有误 进行修改
					else
						code_check[2] <= #1 ~code[2];	 				// code[2]无误
					state <= #1 5'd20;						
				end
				
				5'd20:begin 											// 计算code[1]
					s[2] <= #1 code[1]+code[9]+code[6]+code[3];
					s[1] <= #1 code[1]+code[10]+code[5];
					s[0] <= #1 1'b0;		
					state <= #1 5'd21;				
				end
				5'd21:begin 											// 判决code[1]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[1] <= #1 code[1];  					// code[1]有误 进行修改
					else
						code_check[1] <= #1 ~code[1];				 	// code[1]无误
					state <= #1 5'd22;						
				end
				
				5'd22:begin 											// 计算code[0]
					s[2] <= #1 code[0]+code[10]+code[6];
					s[1] <= #1 code[0]+code[8]+code[4]+code[3];
					s[0] <= #1 1'b0;		
					state <= #1 5'd23;				
				end
				5'd23:begin 											// 判决code[0]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[0] <= #1 code[0];  					// code[1]有误 进行修改
					else
						code_check[0] <= #1 ~code[0];	 				// code[1]无误
					state <= #1 5'd0;						
				end
				
				default: begin
					state 	<= #1 5'b0;
					s 		<= #1 3'b0;
					code_check <= #1 12'b0;
				end
				
				endcase
			end
		
			else
			begin
				state <= #1 5'b0;
				s 	  <= #1 3'b0;
			end
		end
	end
	
	// 进行列变换还原	 |0 0 0 0 0 0 0 9| u=[c | s]
	reg [11:0] code_col;												// 对码字进行列变换后的码组
	reg 	   decode_finish;											// 译码完成信号
	always@(posedge clk or negedge rst_n)
	begin
		if(rst_n == 1'b0)
		begin
			code_col   <= #1 8'b0;
			decode_finish <= #1 1'b0;
		end
			
		else
		begin
			if(clk_count == 5'd25)
			begin
				code_col <= #1 {code_check[11:5],code_check[3],code_check[4],code_check[2:0]}; // 序列第8位与第9位进行交换 从低往高数
				decode_finish <= #1 1'b1;								// 译码完成
			end
			
			else
			begin
				code_col   <= #1 code_col;
				decode_finish <= #1 1'b0;				
			end
		end
	end
	
	reg [3:0] msg;														
	always@(posedge clk or negedge rst_n)
	begin
		if(rst_n == 1'b0)
			msg <= #1 4'b0;
		else
		begin
			if(decode_finish == 1'b1)
				msg <= #1 code_col[3:0];								// 输出译码后还原的信息序列
			else
				msg <= #1 msg;
		end
	end
	
endmodule
