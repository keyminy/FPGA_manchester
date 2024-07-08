module mch_rx_ctl
(
    input   rst,
    input   clk,
    input   rxsd,
    //
    output	reg rcv_sd,sy_ok,pls1m,pls2m
);

reg rd0,rd1;

reg rxing;	// H : Receiving Data.
// rxing : data가 없는 구간에서 대기한다.
// data가 없으면 low였다가 수신되기 시작하면 high...
reg [5:0] cnt; // clock을 만들기위한 counter

reg pl0,pl1;

reg syok;

reg [7:0] acnt;

reg [4:0] sy_cnt;

//

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		sy_ok <= 0;
	else if (pl0 & ~pl1)
		sy_ok <= syok;
end

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		rcv_sd <= 0;
	else if (syok == 0)
		rcv_sd <= 0;
	else if (pl0 & ~pl1)
		rcv_sd <= rd0 ^ pls1m;
end

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		syok <= 0;
	else if (rxing == 0)
		syok <= 0;
	else if (pl1 & ~pl0)
//	else if (pl0 & ~pl1)
		if (acnt >= 136)
			syok <= 0;
		else if (sy_cnt == 24)
			syok <= 1;
		else
			syok <= 0;
end

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		sy_cnt <= 0;
	else if (rxing == 0)
		sy_cnt <= 0;
	else if (pl0 & ~pl1)
		if (sy_cnt < 4)
			if (rd0 == 0)
				sy_cnt <= sy_cnt + 1;
			else
				sy_cnt <= 31;
		else if (sy_cnt < 8)
			if (rd0 == 1)
				sy_cnt <= sy_cnt + 1;
			else
				sy_cnt <= 31;
		else if (sy_cnt < 12)
			if (rd0 == 0)
				sy_cnt <= sy_cnt + 1;
			else
				sy_cnt <= 31;
		else if (sy_cnt < 16)
			if (rd0 == 1)
				sy_cnt <= sy_cnt + 1;
			else
				sy_cnt <= 31;
		else if (sy_cnt < 20)
			if (rd0 == 0)
				sy_cnt <= sy_cnt + 1;
			else
				sy_cnt <= 31;
		else if (sy_cnt < 24)
			if (rd0 == 1)
				sy_cnt <= sy_cnt + 1;
			else
				sy_cnt <= 31;
end

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		pls1m <= 1;
	else if (rxing == 0)
		pls1m <= 1;
	else if (pl1 & ~pl0)
		pls1m <= ~acnt[0];
end

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		acnt <= 0;
	else if (rxing == 0)
		acnt <= 0;
	else if (pl0 & ~pl1)
		if (acnt < 170)
			acnt <= acnt + 1;
end

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		begin
			pl0 <= 1;	pl1 <= 1;	pls2m <= 1;
		end
	else
		begin
			pl1 <= pl0;	pls2m <= pl0;
			if (cnt < 25)
				pl0 <= 0;
			else 
				pl0 <= 1;   
		end
end

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		begin
			rxing <= 0;	cnt <= 63;
		end
	else
		if ((rxing == 0) & (rd1 & ~rd0))
		// 수신신호의 falling이 발생
			begin
				rxing <= 1;	cnt <= 0;
			end
		else if (rxing == 1)
			begin
				if (rd0 ^ rd1)
					cnt <= 0;
				else if (cnt < 49)
					cnt <= cnt + 1;
				else
					cnt <= 0;
				//
				if (acnt == 170)
					rxing <= 0;
			end
		else
			cnt <= 63;
end

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		begin
			rd0 <= 1;	rd1 <= 1;
		end
	else
		begin
			rd0 <= rxsd;	rd1 <= rd0;
		end
end

endmodule
