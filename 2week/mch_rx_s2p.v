module mch_rx_s2p
(
    input   rst,
    input   clk,
    input   pls1m,
    input   sy_ok,
    input   rcv_sd,
    //
    output	reg done,
    output  reg [7:0] length,pd0,pd1,pd2,pd3
);

reg sy0,sy1;	// 
reg pl0,pl1;	// 1MHz Pulse Shift
reg [2:0] bcnt,bycnt;
reg [7:0] tpd,pd;	// 

reg flag;	// 
reg [7:0] ilen,d0,d1,d2,d3;	// 

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		done <= 0;
	else if (pl0 & ~pl1)		
		begin
			if (bycnt == 7)
				if ((bcnt == 4) | (bcnt == 5))
					done <= ~flag;
				else
					done <= 0;
		end
end

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		begin
			length <= 0;	pd0 <= 0;	pd1 <= 0;	pd2 <= 0;	pd3 <= 0;
		end
	else if (pl0 & ~pl1)		
		begin
			if (bcnt == 2)
				if (bycnt == 7)
					if (flag == 0)
						begin
							length <= ilen;
							pd0	<= d0;
							pd1 <= d1;
							pd2 <= d2;
							pd3 <= d3;		
						end
		end
end

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		begin
			flag <= 0;	ilen <= 0;	d0 <= 0;	d1 <= 0;	d2 <= 0;	d3 <= 0;
		end
	else if (pl0 & ~pl1)		
		begin
			if (bcnt == 3)
				if (bycnt == 1)
					if (pd == 8'hcc)
						flag <= 0;
					else
						flag <= 1;
				
				else if (bycnt == 2)	ilen <= pd;
				else if (bycnt == 3)	d0 <= pd;
				else if (bycnt == 4)	d1 <= pd;
				else if (bycnt == 5)	d2 <= pd;
				else if (bycnt == 6)	d3 <= pd;			
		end
end

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		begin
			tpd <= 0;	pd <= 0;
		end
	else if (pl0 & ~pl1)		
		begin
			tpd <= {tpd[6:0],rcv_sd};
			if (bcnt == 7)
				pd <= {tpd[6:0],rcv_sd};
		end
end

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		begin
			bcnt <= 7;	bycnt <= 7;
		end
	else if (sy0 & ~sy1)		
		begin
			bcnt <= 0;	bycnt <= 0;		
		end
	else if (pl1 & ~pl0)
		if (bcnt < 7)
			bcnt <= bcnt + 1;
		else if (bycnt < 7)
			begin
				bcnt <= 0;	bycnt <= bycnt + 1;
			end
end

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		begin
			sy0 <= 1;	sy1 <= 1;
			pl0 <= 1;	pl1 <= 1;
		end
	else
		begin
			sy0 <= sy_ok;	sy1 <= sy0;	
			pl0 <= pls1m;	pl1 <= pl0;				
		end
end

endmodule
