module mch_tx
(
    input   rst,
    input   clk,
    input   start,
    input   [7:0] pd0,pd1,pd2,pd3, // 전송할 8bit ascii 4개
    output  reg txsd // txsd출력
);

wire [7:0] d_sync,length;
// length : 몇 byte까지 수신할 것인지
reg [7:0] pd_sel;

wire [1:0] stm;
wire [6:0] q80;

wire pls1m,pls2m;
// 2mhz pulse : serial data가 나왔을때
// 100mhz clock과 바로 xor하는 것은 위험하다.
// 한 clock정도, sd와 clock이 

reg pl0,pl1;	// 2MHz Pulse Shift

wire sdo;
reg p2s_start;

assign d_sync = 8'hcc;
assign length = 8'd04;

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		pd_sel <= 8'hff;
	else
		case (q80)
		7'd10 :		pd_sel <= d_sync ;
		7'd18 :		pd_sel <= length ;
		7'd26 :		pd_sel <= pd0    ;
		7'd34 :		pd_sel <= pd1    ;
		7'd42 :		pd_sel <= pd2    ;
		7'd50 :		pd_sel <= pd3    ;
		7'd58 :		pd_sel <= d_sync ;
		7'd66 :		pd_sel <= 8'hff ;
	//	default :	null;
		endcase
end


always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		p2s_start <= 0;
	else
		case (q80)
		7'd11 :		p2s_start <= 1;
		7'd19 :		p2s_start <= 1;
		7'd27 :		p2s_start <= 1;
		7'd35 :		p2s_start <= 1;
		7'd43 :		p2s_start <= 1;
		7'd51 :		p2s_start <= 1;
		7'd59 :		p2s_start <= 1;
		default :	p2s_start <= 0;
		endcase
end

//

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		begin
			pl0 <= 1;	pl1 <= 1;
			txsd <= 1;
		end
	else
		begin
			pl0 <= pls2m;	pl1 <= pl0;
			if (pl0 & ~pl1)
				case (stm)
				2'd0	:	txsd <= q80[1];		// A-Sync
				2'd1	:	txsd <= sdo;		// Manchester Encoded Data
				2'd2	: 	txsd <= ~q80[1];
				default	:	txsd <= 1;
				endcase
		end
end

mch_enc_p2s u_mch_enc_p2s
(
.rst        (rst        ),
.clk        (clk        ),
.pls_1m    	(pls1m     	),
.start      (p2s_start  ),
.pd         (pd_sel     ),
.sdo        (sdo        )
);
        
mch_enc_ctl u_mch_enc_ctl
(
.rst        (rst        ),
.clk        (clk        ),
.start  	(start  	),
//
.pls1m     	(pls1m     	),
.pls2m     	(pls2m     	),
.stm     	(stm     	),
.q80    	(q80    	)
);

endmodule
