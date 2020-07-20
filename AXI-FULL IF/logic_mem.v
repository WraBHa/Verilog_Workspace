`include "define_axi.vh"

module logic_mem
(
	input clk,
	input rst_n,

	//Wr Port
	input wr_en,
	input [`ADDR_WIDTH-1:0]wr_addr,
	input [`MEM_WIDTH-1:0]wr_dat,

	//Rd Port
	input rd_en,
	input [`ADDR_WIDTH-1:0]rd_addr,
	output reg rd_dat_vld,
	output [`MEM_WIDTH-1:0]rd_dat
);
	
	reg [`MEM_WIDTH-1:0] mem[`MEM_DEPTH-1:0];
	reg [`MEM_WIDTH-1:0] rd_dat_r;

	// initialize for testbench
	// initial begin
	// 	$readmemh("F:/verilog_pj/burstMode_AXI2/memOut.dat",mem);
	// end

	// wr channel
	always @(posedge clk) begin
		if(wr_en) begin
			mem[wr_addr] = wr_dat;
		end
	end

	// rd channel
	always @(posedge clk or negedge rst_n) begin 
		if(~rst_n) begin
			rd_dat_vld <= 0;
		end 
		else begin
			rd_dat_vld <= rd_en;
		end
	end

	always @(posedge clk or negedge rst_n) begin 
		if(~rst_n) begin
			rd_dat_r <= 0;
		end 
		else begin
			if(rd_en) begin
				rd_dat_r <= mem[rd_addr];
			end
		end
	end
	assign rd_dat = rd_dat_r;
endmodule // logic_mem