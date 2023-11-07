module proj1( input CLOCK_50, input [9:0] SW, input [0:0] KEY, output reg [1:0] GPIO, 
output reg [7:0] HEX0, output reg [7:0] HEX1, output reg [7:0] HEX2, output reg [7:0] HEX3, 
output reg [7:0] HEX4, output reg [7:0] HEX5, output reg [9:0]  LEDR);


localparam MEM_SIZE1 = 37; 
localparam MEM_SIZE2 = 37 + 1966;
localparam MEM_SIZE3 = 37 + 1966 + 102; 
reg MEM_SIZE_init = 0;
reg MEM_SIZE_fin = 0;


reg [10:0] memory[2200:0];
reg [31:0] ledcounter;
wire stop;

reg clock; 
reg[27:0] count=28'd0;
parameter DIVISOR1 = 28'd50, DIVISOR2 = 28'd250, DIVISOR3 = 28'd700, DIVISOR = 28'd10;

always @(posedge CLOCK_50)
begin
count <= count + 28'd1;
 
case (SW[9:0])
			10'b0000000001: 	begin
						if(count>=(DIVISOR1-1))
						  count <= 28'd0;
						 clock <= (count<DIVISOR1/2)?1'b1:1'b0;
						end
			10'b0000000010:	begin
						 if(count>=(DIVISOR2-1))
						  count <= 28'd0;
						 clock <= (count<DIVISOR2/2)?1'b1:1'b0;
						end
			10'b0000000100:	begin
						if(count>=(DIVISOR3-1))
						  count <= 28'd0;
						clock <= (count<DIVISOR3/2)?1'b1:1'b0;
						end

			default: begin 
							if(count>=(DIVISOR-1))
						  count <= 28'd0;
						  clock <= (count<DIVISOR/2)?1'b1:1'b0;
					end
						
						
			
		endcase
 

end

initial begin

 $readmemh("audio4.mem", memory, 0, MEM_SIZE1-1);
 $readmemh("audio3.mem", memory, MEM_SIZE1, MEM_SIZE2-1);
 $readmemh("jingle.mem", memory, MEM_SIZE2, MEM_SIZE3-1);

end




reg play = 1;

reg [4:0] prescaler; 

reg [10:0] counter;

reg [19:0] address;

reg [10:0] value;

always @(posedge CLOCK_50 or negedge KEY[0])begin
 if ( ~KEY[0]) begin
	 play = 0;
	 
	 end
else

	 
		case (SW[9:0])
			10'b0000000001: 	begin
							MEM_SIZE_init <= 0;
							MEM_SIZE_fin <= MEM_SIZE1;
							play <= 1;
							
						end
			10'b0000000010:	begin
							MEM_SIZE_init <= MEM_SIZE1;
							MEM_SIZE_fin <= MEM_SIZE2;
							play <= 1;
							

						end
			10'b0000000100:	begin
							MEM_SIZE_init <= MEM_SIZE2;
							MEM_SIZE_fin <= MEM_SIZE3;
							play <= 1;
							
							
						end
			default: begin 
							play <= 0;
							
						end
			
		endcase
	
end

always @(posedge CLOCK_50)begin
ledcounter <= (ledcounter<50000000) ? ledcounter +1 : 0;
if(ledcounter == 50000000)	 
		case (SW[9:0])
			10'b0000000001: 	begin
						LEDR [0] =   ~ LEDR[0];
						LEDR [1] =   0;
						LEDR [2] =   0;
						end
			10'b0000000010:	begin
						LEDR [1] =   ~ LEDR [1];
						LEDR [0] =   0;
						LEDR [2] =   0;
						end
			10'b0000000100:	begin
						LEDR [2] =   ~ LEDR [2];
						LEDR [0] =   0;
						LEDR [1] =   0;
						end
			10'b0000000000: begin 
						LEDR [9:0] = 10'b0000000000;
						end
			default: LEDR [9:0] = ~ LEDR [9:0];
					
						
						
			
		endcase
	
	
end

always @(posedge CLOCK_50 or negedge KEY[0])begin
 if ( ~KEY[0] ) begin	
			if((SW[9:0] == 10'b0000000001 | SW[9:0] == 10'b0000000010 | SW[9:0] == 10'b0000000100)) begin			
						HEX5 [7:0] = 8'b10001100;
						HEX4 [7:0] = 8'b10001000;
						HEX3 [7:0] = 8'b11000001;
						HEX2 [7:0] = 8'b10010010;
						HEX1 [7:0] = 8'b10000110;
						HEX0 [7:0] = 8'b10100001;
			end
	 end
else	 
		case (SW[9:0])
			10'b0000000001: 	begin
						HEX0 [7:0] = 8'b11111001;
						HEX5 [7:0] = 8'b10010010;
						HEX4 [7:0] = 8'b11000000;
						HEX3 [7:0] = 8'b11000001;
						HEX2 [7:0] = 8'b11001000;
						HEX1 [7:0] = 8'b10100001;
						end
			10'b0000000010:	begin
						HEX0 [7:0] = 8'b10100100;
						HEX5 [7:0] = 8'b10010010;
						HEX4 [7:0] = 8'b11000000;
						HEX3 [7:0] = 8'b11000001;
						HEX2 [7:0] = 8'b11001000;
						HEX1 [7:0] = 8'b10100001;
						end
			10'b0000000100:	begin
						HEX0 [7:0] = 8'b10110000;	
						HEX5 [7:0] = 8'b10010010;
						HEX4 [7:0] = 8'b11000000;
						HEX3 [7:0] = 8'b11000001;
						HEX2 [7:0] = 8'b11001000;
						HEX1 [7:0] = 8'b10100001;	
						end
			10'b0000000000:	begin							
						HEX5 [7:0] = 8'b11000110;
						HEX4 [7:0] = 8'b10001001;
						HEX3 [7:0] = 8'b11000000;
						HEX2 [7:0] = 8'b11000000;
						HEX1 [7:0] = 8'b10010010;
						HEX0 [7:0] = 8'b10000110;
						end
			default: begin 
						HEX0 [7:0] = 8'b10000110;
						HEX5 [7:0] = 8'b11111111;
						HEX4 [7:0] = 8'b11111111;
						HEX3 [7:0] = 8'b11111111;
						HEX2 [7:0] = 8'b11111111;
						HEX1 [7:0] = 8'b11111111;
					
						
						end
			
		endcase
	
end


always @(posedge clock)

begin


 if (play) begin
	

		 counter <= counter + 1;

		 value <= memory[address + MEM_SIZE_init];

		 GPIO [0] <= (value > counter);
		 
		 GPIO [1] <= (value > counter);

		 if (counter == 700)

			 begin
			 

			 address <= address + 1;
			 
			 counter <= 0;			 
			 

			 if (address  == MEM_SIZE_fin)

				 begin	 
				 		 
				 	 address <= 0;

				 end 

			 end 	

	 end

end

endmodule

