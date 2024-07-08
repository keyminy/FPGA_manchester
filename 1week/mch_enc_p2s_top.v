module mch_enc_p2s_top(
    input   rst,
    input   clk,
    input   pls_1m,
    input   sync_done,
    input   [7:0] p_data,
    output  [2:0] d_sel,    // 1 : Length, 2~5 : Data
    output  reg txsdo, p2s_end
    );

reg pl0,pl1;    // for 1MHz Pulse Edge Detect
reg sd0,sd1;    // for 1MHz Pulse Edge Detect

reg p2s_start;

reg [5:0] cnt;
//wire [2:0] d_sel;

reg [7:0] pd_sel;

wire txsd,p2s_done;

always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            p2s_end <= 0;   txsdo <= 1;
        end
    else 
        begin
            txsdo <= txsd;
            if (d_sel == 7)
                p2s_end <= p2s_done;  
            else
                p2s_end <= 0;
        end 
end

always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            pd_sel <= 0;    p2s_start <= 0;
        end   
    else 
        begin
            pd_sel <= p_data;   
            //
            if ((cnt[2:0] == 0) & (d_sel < 7))
                p2s_start <= 1;                
            else
                p2s_start <= 0;
        end 
end

assign d_sel = cnt[5:3];
    
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        cnt <= 63;   
    else 
        if (sd0 & ~sd1)
            cnt <= 0;
        else if (pl0 & ~pl1)
            if (cnt < 58)
                cnt <= cnt + 1; 
end
    
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            pl0 <= 0;   pl1 <= 0;   sd0 <= 0;    sd1 <= 0;
        end
    else
        begin
            sd0 <= sync_done;   sd1 <= sd0;
            pl0 <= pls_1m;  pl1 <= pl0;
        end
end

mch_enc_p2s u_mch_enc_p2s
(
.rst        (rst        ),
.clk        (clk        ),
.pls_1m     (pls_1m     ),
.start      (p2s_start  ),
.pd         (pd_sel     ),
.sdo        (txsd       ),
.done       (p2s_done   )
);
        
endmodule
