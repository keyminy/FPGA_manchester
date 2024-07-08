module mch_enc_ctl
(
    input   rst,
    input   clk,
    input   start,
    output	reg [1:0] stm,
    output	pls1m,pls2m,
    output  reg [6:0] q80
);

reg st0,st1;    // 
reg [4:0] q25;
reg [1:0] q4;

assign pls1m = q4[1];
assign pls2m = q4[0];

always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        stm <= 3;
    else if (st0 & ~st1)
    	stm <= 0;
    else if ((q25 == 24) & (q4 == 3))
    	if (q80 == 11)
    		stm <= 1;
    	else if (q80 == 67)
    		stm <= 2;
    	else if (q80 == 79)
    		stm <= 3;
end

always@(negedge rst, posedge clk)
begin
    if (rst == 0)
    	begin
	        q25 <= 31;	q4 <= 3;   q80 <= 127;   
	  	end
    else if (st0 & ~st1)
    	begin
            q25 <= 0; 	q4 <= 0;   q80 <= 0;   
     	end
   	else if (q25 < 24)
   		q25 <= q25 + 1;
  	else if (q4 < 3)
  		begin
  			q25 <= 0;	
  			q4 <= q4 + 1;
  		end
  	else if (q80 < 80)
    	begin
  			q25 <= 0;	q4 <= 0;
  			q80 <= q80 + 1;
	  	end
	else
    	begin
	        q25 <= 31;	q4 <= 3;   q80 <= 127;   
	  	end
end
    
always@(negedge rst, posedge clk)
begin
    if (rst == 0)
        begin
            st0 <= 0;    st1 <= 0;
        end
    else
        begin
            st0 <= start;   st1 <= st0;
        end
end

endmodule
