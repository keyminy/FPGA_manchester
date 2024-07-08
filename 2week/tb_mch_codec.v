module tb_mch_codec
(
    input 	btnl, // rst. High Active Reset
    input 	clk,  // 100MHz Clock Input
    input 	btnr, // start btn. Tact Switch Input. Push High
    input 	btnd, // LED sel btn. Tact Switch Input. Push High
    input 	[15:0] sw,
//    input	rxsd,
    //
    output  txsd,
    output	[6:0] seg,
    output  dp,
    output	[3:0] an,
    output 	[15:0] led
);

wire rxsd;

mch_codec u_mch_codec
(
.btnl  		(btnl  		),
.clk        (clk        ),
.btnr  		(btnr  		),
.btnd  		(btnd  		),
.sw  		(sw  		),
.rxsd  		(rxsd  		),
//
.txsd  		(txsd	  	),
.seg		(seg		),
.dp  		(dp		  	),
.an  		(an		  	),
.led  		(led	  	)
);

assign rxsd = txsd;

endmodule
