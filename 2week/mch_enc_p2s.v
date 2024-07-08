module mch_enc_p2s(
    input   rst,
    input   clk,
    input   pls_1m,
    input   start,  // P2S Start. 1us period. pls_1m Fall to Fall
    input   [7:0] pd,
    output  reg sdo
    );

reg pl0,pl1;    // for 1MHz Pulse Edge Detect
reg	st0;
reg [7:0] pdi;
reg [3:0] cnt;
reg sd;

always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        sdo <= 0;
    else
       if (cnt < 8)
           sdo <= sd ^ ~pl1;
       else
           sdo <= 1;
end
    
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
    	begin
	        sd <= 0;   st0 <= 0;	cnt <= 15;
        end   
    else if (pl1 & ~pl0)
    	begin
    		st0 <= start;
	        sd <= pdi[7];
        	if (st0)
            	cnt <= 0;
            else if (cnt < 7)
           		cnt <= cnt + 1;
          	else
            	cnt <= 15;
      	end
end
    
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        pdi <= 0;   
    else if (pl0 & ~pl1)
        if (start)
            pdi <= pd;  
        else 
            pdi <= {pdi[6:0],1'b0};
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
