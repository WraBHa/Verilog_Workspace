module P2S 
#( 
	parameter  DW   =  21,
	parameter  AW   =  4
)(
	input              clk,
	input              rst,

	input  [DW-1 : 0]  p2s_din,
	input              p2s_start,

	output reg         p2s_dout,
	output reg         p2s_valid
);


reg   [AW-1: 0] cnt;
reg   [DW-1: 0] p2s_reg;

parameter  P2S_IDLE;
parameter  P2S_BUSY;

reg   p2s_state;

always @ (posedge clk or posedge rst) begin
	if (rst) begin
		cnt          <=   'd0;
		p2s_state    <=   P2S_IDLE;
		p2s_done     <=   1'b0;
		p2s_dout     <=   1'b0;
	end 
	else begin
		case (p2s_state) 
			P2S_IDLE: begin
				cnt        <=   'd0;
				p2s_valid  <=   1'b0;
				p2s_dout   <=   1'b0;
				if (p2s_start) begin
					p2s_state  <=  P2S_BUSY;
					p2s_reg    <=  p2s_din;
				end 
			end 
			P2S_BUSY: begin
				p2s_dout  <=   p2s_reg[DW-1];
				p2s_reg   <=   p2s_reg << 1;
 				if (cnt == DW - 1'b1) begin
 					p2s_valid  <= 1'b0;
 					p2s_state  <= P2S_IDLE;
 				end 
 				else begin
 					cnt        <= cnt + 1'b1;
 					p2s_valid  <= 1'b1;
 				end 
 			end 
 		endcase 
 	end 
 end 
