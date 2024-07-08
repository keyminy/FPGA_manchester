module mch_enc_sync_gen(
    input   rst,
    input   clk,
    input   pls_1m,
    input   start,
    output  reg async,
    output  reg done
    );

reg pl0,pl1;    // for 1MHz Pulse Edge Detect
reg st0,st1;    // for 1MHz Pulse Edge Detect

reg [3:0] cnt;

always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            async <= 1;  done <= 0;
        end   
    else if (pl0 & ~pl1)
        begin
            if (cnt < 11)
                async <= cnt[1];
            if ((cnt >= 11) & (cnt < 15))
                done <= 1;
            else
                done <= 0;
        end            
end
    
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        cnt <= 15;   
    else if (pl1 & ~pl0)
    //pluse 1MHZ falling일때 
    // counter clear동작이 falling에서 이루어져야, 
        if (st0 & ~st1)
            cnt <= 0;
        else if (cnt < 15)
            cnt <= cnt + 1; 
end
    
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            pl0 <= 0;   pl1 <= 0;   st0 <= 0;    st1 <= 0;
        end
    else
        begin
            pl0 <= pls_1m;  pl1 <= pl0;
            if (pl0 & ~pl1)
                begin
                    st0 <= start;   st1 <= st0;
                end
        end
end
    
endmodule
