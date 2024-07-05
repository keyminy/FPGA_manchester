module mch_enc_p2s(
    input   rst,
    input   clk,
    input   pls_1m,
    input   start,  // P2S Start. 1us period. pls_1m Fall to Fall
    input   [7:0] pd,
    output  reg sdo,done
    );

reg pl0,pl1;    // for 1MHz Pulse Edge Detect
reg [7:0] pdi;
reg [3:0] cnt;
wire sd;

always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            sdo <= 0;   done <= 0;   
        end
    else
        begin
            if (cnt < 8)
                sdo <= sd ^ pl1;
            else
                sdo <= 1;
            //
            if (cnt == 7)
                done <= 1;
            else
                done <= 0;
        end
end
    

assign sd = pdi[7];
    
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            pdi <= 0;   cnt <= 15;
        end   
    else if (pl0 & ~pl1)
        if (start)
            begin
                pdi <= pd;  cnt <= 0;
            end
        else 
            begin
                pdi <= {pdi[6:0],1'b0};
                if (cnt < 7)
                    cnt <= cnt + 1;
                else
                    cnt <= 15;
            end 
end
    
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            pl0 <= 0;   pl1 <= 0;   
        end
    else
        begin
            pl0 <= pls_1m;  pl1 <= pl0;
        end
end
    
endmodule
