module S2P
#(
	parameter DW = 22,
	parameter AW = 4
)(
input                  clk,
input                  rst,

input                  serial_din,
input                  s2p_start,

output reg  [DW-1 : 0] parallel_dout,
output reg             s2p_done
);

reg [AW-1 : 0]  cnt;
reg [DW-1 : 0]	s2p_reg;

parameter   S2P_IDLE  =  1'b0;
parameter   S2P_BUSY  =  1'b1;

reg  s2p_state;

always @ (posedge clk or posedge rst) begin
	if (rst) begin
		cnt       <=    'd0;
		s2p_reg   <=    'd0;
		s2p_done  <=    1'b0;
		s2p_state <=    S2P_IDLE;
	end 
	else begin
		case (s2p_state) 
			S2P_IDLE: begin
				cnt          <=  'd0;
				s2p_done     <=  1'b0;
				s2p_state    <=  (s2p_start) ? S2P_BUSY : S2P_IDLE;
			end 
			S2P_BUSY: begin
				if (cnt == DW - 1'b1) begin
					s2p_done      <= 1'b1;
					s2p_state     <= S2P_IDLE;
					parallel_dout <= s2p_reg;
				end 
				else begin
					cnt      <=  cnt + 1'b1;
					s2p_reg  <=  {s2p_reg[DW-2:0], serial_din};
				end 
			end 
		endcase 
	end 
end 


endmodule 

