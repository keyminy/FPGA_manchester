module ascii2hex
(
    input 	rst, // rst. High Active Reset
    input 	clk,  // 100MHz Clock Input
    input 	[7:0] pd0,pd1,pd2,pd3,
    //
    output 	[15:0] rpd
);

reg [3:0] nb0,nb1,nb2,nb3;

assign rpd = {nb0,nb1,nb2,nb3};

always@(negedge rst, posedge clk)
begin
	if (rst == 0)    
		begin
			nb0 <= 0;	nb1 <= 0;	nb2 <= 0;	nb3 <= 0;
		end
	else
		begin
			if ((pd0[7:4] == 3) & (pd0[3:0] < 10))
				nb0 <= pd0[3:0];
			else if ((pd0[7:4] == 4) & (pd0[3:0] > 0) & (pd0[3:0] < 7))
				nb0 <= pd0[3:0] + 9;
					
			if ((pd1[7:4] == 3) & (pd1[3:0] < 10))
				nb1 <= pd1[3:0];
			else if ((pd1[7:4] == 4) & (pd1[3:0] > 0) & (pd1[3:0] < 7))
				nb1 <= pd1[3:0] + 9;
			
			if ((pd2[7:4] == 3) & (pd2[3:0] < 10))
				nb2 <= pd2[3:0];
			else if ((pd2[7:4] == 4) & (pd2[3:0] > 0) & (pd2[3:0] < 7))
				nb2 <= pd2[3:0] + 9;
				
			if ((pd3[7:4] == 3) & (pd3[3:0] < 10))
				nb3 <= pd3[3:0];
			else if ((pd3[7:4] == 4) & (pd3[3:0] > 0) & (pd3[3:0] < 7))
				nb3 <= pd3[3:0] + 9;
				
		end
end

endmodule
