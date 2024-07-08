module mch_rx
(
    input   rst,
    input   clk,
    input   rxsd,
    output	rcv_done,
    output  [7:0] length,pd0,pd1,pd2,pd3
);

reg pl0,pl1;

wire pls1m,pls2m;

wire sy_ok,rcv_sd;

reg dsy_ok,drcv_sd; // timing을 맞추기 위한 delay(위상 맞추기)

//

mch_rx_s2p u_mch_rx_s2p
(
.rst		(rst		),
.clk		(clk		),
.pls1m		(pls1m		),
.sy_ok		(dsy_ok		),
.rcv_sd		(drcv_sd	),
//
.done		(rcv_done	),
.length		(length		),
.pd0		(pd0		),
.pd1		(pd1		),
.pd2		(pd2		),
.pd3		(pd3		)
);

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		begin
			dsy_ok <= 0;	drcv_sd <= 0;
		end
	else if (pl1 & ~pl0)
		begin
			dsy_ok <= sy_ok;	drcv_sd <= rcv_sd;
		end
end

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		begin
			pl0 <= 1;	pl1 <= 1;
		end
	else
		begin
			pl1 <= pl0;	pl0 <= pls2m;
		end
end

mch_rx_ctl u_mch_rx_ctl
(
.rst		(rst		),
.clk		(clk		),
.rxsd		(rxsd		),
//
.pls1m		(pls1m		),
.pls2m		(pls2m		),
.rcv_sd		(rcv_sd		),
.sy_ok		(sy_ok		)
);

endmodule
