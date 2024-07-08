module hex2ascii
(
    input 	rst, // rst. High Active Reset
    input 	clk,  // 100MHz Clock Input
    input 	[15:0] sw,
    //
    output 	reg [7:0] pd0,pd1,pd2,pd3
);

wire [3:0] nb0,nb1,nb2,nb3;

assign nb0 = sw[15:12];
assign nb1 = sw[11:08];
assign nb2 = sw[07:04];
assign nb3 = sw[03:00];

always@(negedge rst, posedge clk)
begin
	if (rst == 0)    
		begin
			pd0 <= 8'hff;	pd1 <= 8'hff;	pd2 <= 8'hff;	pd3 <= 8'hff;
		end
	else
		begin
			if (nb0 < 10)	
				pd0 <= {4'h3, nb0};
			else
				begin
					pd0[7:4] <= 4'h4; 
					pd0[3:0] <= (nb0 - 9);
				end
			
			if (nb1 < 10)	
				pd1 <= {4'h3, nb1};
			else	
				begin
					pd1[7:4] <= 4'h4; 
					pd1[3:0] <= (nb1 - 9);
				end
			
			if (nb2 < 10)	
				pd2 <= {4'h3, nb2};
			else
				begin
					pd2[7:4] <= 4'h4; 
					pd2[3:0] <= (nb2 - 9);
				end
			
			if (nb3 < 10)	
				pd3 <= {4'h3, nb3};
			else			
				begin
					pd3[7:4] <= 4'h4; 
					pd3[3:0] <= (nb3 - 9);
				end
		end
end

endmodule
