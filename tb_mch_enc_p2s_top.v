module tb_mch_enc_p2s_top(
    input   rst,
    input   clk,
    input   pls_1m,
    input   sync_done,
    input   [7:0] d_sync,
    input   [7:0] length,
    input   [7:0] pd0,pd1,pd2,pd3,
    output  txsdo, p2s_end
    );

wire [2:0] d_sel;
wire [7:0] p_data;

assign p_data = (d_sel == 0) ? d_sync :
                (d_sel == 1) ? length :
                (d_sel == 2) ? pd0 :
                (d_sel == 3) ? pd1 :
                (d_sel == 4) ? pd2 :
                (d_sel == 5) ? pd3 :
                (d_sel == 6) ? d_sync : 8'hff;   

mch_enc_p2s_top u_mch_enc_p2s_top
(
.rst        (rst        ),
.clk        (clk        ),
.pls_1m     (pls_1m     ),
.sync_done  (sync_done  ),
.p_data     (p_data     ),
.d_sel      (d_sel      ),
.txsdo      (txsdo      ),
.p2s_end    (p2s_end    )
);

endmodule
