`timescale 1 ns/ 1 ps
module ldpc_decoder(
	clk,
	rst_n,
	code,
	msg
	);

	input  clk;															// ϵͳʱ�� 50MHz
	input  rst_n;														// ��λ�źţ��͵�ƽ��Ч
	input  [11:0] code;													// ��Ϣ���� 
	output [3:0] msg;													// �������� 

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
	
	reg [11:0] code_check;												// �����ֽ��о���������
	reg [4:0]  state;
	reg [2:0]  s; 														// У����
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
			if((clk_count >= 5'd1)&&(clk_count <= 5'd24))				//���д����߼����� ����ÿ�����ص�У���� �������о�
			begin
				case(state)   
				5'd0:begin 												// ����code[11]
					s[2] <= #1 code[11]+code[7];
					s[1] <= #1 code[11]+code[9]+code[5]+code[4];
					s[0] <= #1 1'b0;
					state <= #1 5'd1;				
				end
				5'd1:begin 												// �о�code[11]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[11] <= #1 code[11];  				// code[11]���� �����޸�
					else
						code_check[11] <= #1 ~code[11];	 				// code[11]����
					state <= #1 5'd2;				
				end
				5'd2:begin 												// ����code[10]
					s[2] <= #1 code[10]+code[6]+code[0];
					s[1] <= #1 code[10]+code[5]+code[1];
					s[0] <= #1 code[10]+code[9]+code[2];	
					state <= #1 5'd3;				
				end
				5'd3:begin 												// �о�code[10]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[10] <= #1 code[10];  				// code[10]���� �����޸�
					else
						code_check[10] <= #1 ~code[10];	 				// code[10]����
					state <= #1 5'd4;						
				end
			
				5'd4:begin 												// ����code[9]
					s[2] <= #1 code[9]+code[6]+code[3]+code[1];
					s[1] <= #1 code[9]+code[5]+code[4];
					s[0] <= #1 code[9]+code[10]+code[2];		
					state <= #1 5'd5;				
				end
				5'd5:begin 												// �о�code[9]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[9] <= #1 code[9];  					// code[9]���� �����޸�
					else
						code_check[9] <= #1 ~code[9];	 				// code[9]����
					state <= #1 5'd6;						
				end
			
				5'd6:begin 												// ����code[8]
					s[2] <= #1 code[8]+code[7]+code[6]+code[2];
					s[1] <= #1 code[8]+code[4]+code[3]+code[0];
					s[0] <= #1 1'b0;		
					state <= #1 5'd7;				
				end
				5'd7:begin 												// �о�code[8]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[8] <= #1 code[8];  					// code[8]���� �����޸�
					else
						code_check[8] <= #1 ~code[8];	 				// code[8]����
					state <= #1 5'd8;						
				end
			
				5'd8:begin 												// ����code[7]
					s[2] <= #1 code[7]+code[8]+code[6]+code[2];
					s[1] <= #1 code[7]+code[11];
					s[0] <= #1 1'b0;		
					state <= #1 5'd9;				
				end
				5'd9:begin 												// �о�code[7]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[7] <= #1 code[7];  					// code[7]���� �����޸�
					else
						code_check[7] <= #1 ~code[7];	 				// code[7]����
					state <= #1 5'd10;						
				end
			
				5'd10:begin 											// ����code[6]
					s[2] <= #1 code[6]+code[9]+code[3]+code[1];
					s[1] <= #1 code[6]+code[10]+code[0];
					s[0] <= #1 code[6]+code[8]+code[7]+code[2];		
					state <= #1 5'd11;				
				end
				5'd11:begin 											// �о�code[6]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[6] <= #1 code[6];  					// code[6]���� �����޸�
					else
						code_check[6] <= #1 ~code[6];	 				// code[6]����
					state <= #1 5'd12;						
				end
			
				5'd12:begin 											// ����code[5]
					s[2] <= #1 code[5]+code[10]+code[1];
					s[1] <= #1 code[5]+code[11]+code[9]+code[4];
					s[0] <= #1 1'b0;		
					state <= #1 5'd13;				
				end
				5'd13:begin 											// �о�code[5]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[5] <= #1 code[5];  					// code[5]���� �����޸�
					else
						code_check[5] <= #1 ~code[5];	 				// code[5]����
					state <= #1 5'd14;						
				end
			
				5'd14:begin 											// ����code[4]
					s[2] <= #1 code[4]+code[8]+code[3]+code[0];
					s[1] <= #1 code[4]+code[11]+code[9]+code[5];
					s[0] <= #1 1'b0;		
					state <= #1 5'd15;				
				end
				5'd15:begin 											// �о�code[4]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[4] <= #1 code[4];  					// code[4]���� �����޸�
					else
						code_check[4] <= #1 ~code[4];	 				// code[4]����
					state <= #1 5'd16;						
				end
				
				5'd16:begin 											// ����code[3]
					s[2] <= #1 code[3]+code[9]+code[6]+code[1];
					s[1] <= #1 code[3]+code[8]+code[4]+code[0];
					s[0] <= #1 1'b0;		
					state <= #1 5'd17;				
				end
				5'd17:begin 											// �о�code[3]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[3] <= #1 code[3];  					// code[3]���� �����޸�
					else
						code_check[3] <= #1 ~code[3];	 				// code[3]����
					state <= #1 5'd18;						
				end
				
				5'd18:begin 											// ����code[2]
					s[2] <= #1 code[2]+code[8]+code[7]+code[6];
					s[1] <= #1 code[2]+code[10]+code[9];
					s[0] <= #1 1'b0;		
					state <= #1 5'd19;				
				end
				5'd19:begin 											// �о�code[2]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[2] <= #1 code[2];  					// code[2]���� �����޸�
					else
						code_check[2] <= #1 ~code[2];	 				// code[2]����
					state <= #1 5'd20;						
				end
				
				5'd20:begin 											// ����code[1]
					s[2] <= #1 code[1]+code[9]+code[6]+code[3];
					s[1] <= #1 code[1]+code[10]+code[5];
					s[0] <= #1 1'b0;		
					state <= #1 5'd21;				
				end
				5'd21:begin 											// �о�code[1]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[1] <= #1 code[1];  					// code[1]���� �����޸�
					else
						code_check[1] <= #1 ~code[1];				 	// code[1]����
					state <= #1 5'd22;						
				end
				
				5'd22:begin 											// ����code[0]
					s[2] <= #1 code[0]+code[10]+code[6];
					s[1] <= #1 code[0]+code[8]+code[4]+code[3];
					s[0] <= #1 1'b0;		
					state <= #1 5'd23;				
				end
				5'd23:begin 											// �о�code[0]
					if((s==3'b100)||(s==3'b010)||(s==3'b001)||(s==3'b000))
						code_check[0] <= #1 code[0];  					// code[1]���� �����޸�
					else
						code_check[0] <= #1 ~code[0];	 				// code[1]����
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
	
	// �����б任��ԭ	 |0 0 0 0 0 0 0 9| u=[c | s]
	reg [11:0] code_col;												// �����ֽ����б任�������
	reg 	   decode_finish;											// ��������ź�
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
				code_col <= #1 {code_check[11:5],code_check[3],code_check[4],code_check[2:0]}; // ���е�8λ���9λ���н��� �ӵ�������
				decode_finish <= #1 1'b1;								// �������
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
				msg <= #1 code_col[3:0];								// ��������ԭ����Ϣ����
			else
				msg <= #1 msg;
		end
	end
	
endmodule
