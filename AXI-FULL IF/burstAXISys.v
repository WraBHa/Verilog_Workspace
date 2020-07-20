`include "define_axi.vh"
`timescale 1 ns / 1 ps

module burstAXISys(

	// data write to buffer
	output [`ADDR_WIDTH-1:0] wr_addr,
    output wr_en,
    output [`C_M_AXI_DATA_WIDTH-1:0] wr_data,


    // data read from buffer
    output [`ADDR_WIDTH-1:0] rd_addr,
    output rd_en,
    input  rd_dat_vld,
    input  [`C_M_AXI_DATA_WIDTH-1:0] rd_data,

	input wire  M_AXI_ACLK,
	input wire  M_AXI_ARESETN,
	output wire [`C_M_AXI_ID_WIDTH-1 : 0] M_AXI_AWID,
	output wire [`C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR,
	output wire [7 : 0] M_AXI_AWLEN, 
	output wire [2 : 0] M_AXI_AWSIZE,
	output wire [1 : 0] M_AXI_AWBURST,
	output wire  M_AXI_AWLOCK,
	output wire [3 : 0] M_AXI_AWCACHE,
	output wire [2 : 0] M_AXI_AWPROT,
	output wire [3 : 0] M_AXI_AWQOS,
	output wire [`C_M_AXI_AWUSER_WIDTH-1 : 0] M_AXI_AWUSER,
	output wire  M_AXI_AWVALID,
	input wire  M_AXI_AWREADY,

	output wire [`C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA, 
	output wire [`C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB, 
	output wire  M_AXI_WLAST, 
	output wire [`C_M_AXI_WUSER_WIDTH-1 : 0] M_AXI_WUSER, 
	output wire  M_AXI_WVALID, 
	input wire  M_AXI_WREADY,
	input wire [`C_M_AXI_ID_WIDTH-1 : 0] M_AXI_BID, 
	input wire [1 : 0] M_AXI_BRESP, 
	input wire [`C_M_AXI_BUSER_WIDTH-1 : 0] M_AXI_BUSER,
	input wire  M_AXI_BVALID,
	output wire  M_AXI_BREADY, 

	output wire [`C_M_AXI_ID_WIDTH-1 : 0] M_AXI_ARID, 
	output wire [`C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_ARADDR,
	output wire [7 : 0] M_AXI_ARLEN,
	output wire [2 : 0] M_AXI_ARSIZE,
	output wire [1 : 0] M_AXI_ARBURST,
	output wire  M_AXI_ARLOCK,
	output wire [3 : 0] M_AXI_ARCACHE,
	output wire [2 : 0] M_AXI_ARPROT,
	output wire [3 : 0] M_AXI_ARQOS,
	output wire [`C_M_AXI_ARUSER_WIDTH-1 : 0] M_AXI_ARUSER,
	output wire  M_AXI_ARVALID,
	input wire  M_AXI_ARREADY, 

	input wire [`C_M_AXI_ID_WIDTH-1 : 0] M_AXI_RID,
	input wire [`C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA,
	input wire [1 : 0] M_AXI_RRESP,
	input wire  M_AXI_RLAST,
	input wire [`C_M_AXI_RUSER_WIDTH-1 : 0] M_AXI_RUSER,
	input wire  M_AXI_RVALID,
	output wire  M_AXI_RREADY,

	// axi lite
	input wire  S_AXI_ACLK,
	input wire  S_AXI_ARESETN,
	input wire [`C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
	input wire [2 : 0] S_AXI_AWPROT,
	input wire  S_AXI_AWVALID,
	output wire  S_AXI_AWREADY,
	input wire [`C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
	input wire [(`C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
	input wire  S_AXI_WVALID,
	output wire  S_AXI_WREADY,
	output wire [1 : 0] S_AXI_BRESP,
	output wire  S_AXI_BVALID,
	input wire  S_AXI_BREADY,
	input wire [`C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
	input wire [2 : 0] S_AXI_ARPROT,
	input wire  S_AXI_ARVALID,
	output wire  S_AXI_ARREADY,
	output wire [`C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
	output wire [1 : 0] S_AXI_RRESP,
	output wire  S_AXI_RVALID,
	input wire  S_AXI_RREADY
);


	wire [`C_S_AXI_DATA_WIDTH-1 : 0] awaddr;
	wire [`C_S_AXI_DATA_WIDTH-1 : 0] araddr;
	wire [`ADDR_WIDTH-1 : 0] mem_base_waddr;
	wire [`ADDR_WIDTH-1 : 0] mem_base_raddr;
	wire start_dma_w;
	wire start_dma_r;
	wire dma_done_w;
	wire dma_done_r;

	burst_axi burst_axi_inst(
		.awaddr(awaddr),
	 	.araddr(araddr),
		.mem_base_waddr(mem_base_waddr),
		.mem_base_raddr(mem_base_raddr),
		.start_dma_w(start_dma_w),
		.start_dma_r(start_dma_r),
		.dma_done_w(dma_done_w),
		.dma_done_r(dma_done_r),
		.wr_addr(wr_addr),
		.wr_en(wr_en),
    	.wr_data(wr_data),
		.rd_addr(rd_addr),
    	.rd_en(rd_en),
    	.rd_dat_vld(rd_dat_vld),
    	.rd_data(rd_data),
		.M_AXI_ACLK(M_AXI_ACLK),
		.M_AXI_ARESETN(M_AXI_ARESETN),
		.M_AXI_AWID(M_AXI_AWID),
		.M_AXI_AWADDR(M_AXI_AWADDR),
		.M_AXI_AWLEN(M_AXI_AWLEN),
		.M_AXI_AWSIZE(M_AXI_AWSIZE),
		.M_AXI_AWBURST(M_AXI_AWBURST),
		.M_AXI_AWLOCK(M_AXI_AWLOCK),
		.M_AXI_AWCACHE(M_AXI_AWCACHE),
		.M_AXI_AWPROT(M_AXI_AWPROT),
		.M_AXI_AWQOS(M_AXI_AWQOS),
		.M_AXI_AWUSER(M_AXI_AWUSER),
		.M_AXI_AWVALID(M_AXI_AWVALID),
		.M_AXI_AWREADY(M_AXI_AWREADY),
		.M_AXI_WDATA(M_AXI_WDATA),
		.M_AXI_WSTRB(M_AXI_WSTRB),
		.M_AXI_WLAST(M_AXI_WLAST),
		.M_AXI_WUSER(M_AXI_WUSER),
		.M_AXI_WVALID(M_AXI_WVALID),
		.M_AXI_WREADY(M_AXI_WREADY),
		.M_AXI_BID(M_AXI_BID),
		.M_AXI_BRESP(M_AXI_BRESP),
		.M_AXI_BUSER(M_AXI_BUSER),
		.M_AXI_BVALID(M_AXI_BVALID),
		.M_AXI_BREADY(M_AXI_BREADY),


		.M_AXI_ARID(M_AXI_ARID),
		.M_AXI_ARADDR(M_AXI_ARADDR),
		.M_AXI_ARLEN(M_AXI_ARLEN),
		.M_AXI_ARSIZE(M_AXI_ARSIZE),
		.M_AXI_ARBURST(M_AXI_ARBURST),
		.M_AXI_ARLOCK(M_AXI_ARLOCK),
		.M_AXI_ARCACHE(M_AXI_ARCACHE),
		.M_AXI_ARPROT(M_AXI_ARPROT),
		.M_AXI_ARQOS(M_AXI_ARQOS),
		.M_AXI_ARUSER(M_AXI_ARUSER),
		.M_AXI_ARVALID(M_AXI_ARVALID),
		.M_AXI_ARREADY(M_AXI_ARREADY),


		.M_AXI_RID(M_AXI_RID),
		.M_AXI_RDATA(M_AXI_RDATA),
		.M_AXI_RRESP(M_AXI_RRESP),
		.M_AXI_RLAST(M_AXI_RLAST),
		.M_AXI_RUSER(M_AXI_RUSER),
		.M_AXI_RVALID(M_AXI_RVALID),
		.M_AXI_RREADY(M_AXI_RREADY)

		);

	ControlRegisters ControlRegisters_inst(
		.awaddr(awaddr),
		.araddr(araddr),
		.mem_base_waddr(mem_base_waddr),
		.mem_base_raddr(mem_base_raddr),
		.start_dma_w(start_dma_w),
		.start_dma_r(start_dma_r),
		.dma_done_w(dma_done_w),
		.dma_done_r(dma_done_r),
		.S_AXI_ACLK(S_AXI_ACLK),
		.S_AXI_ARESETN(S_AXI_ARESETN),
		.S_AXI_AWADDR(S_AXI_AWADDR),
		.S_AXI_AWPROT(S_AXI_AWPROT),
		.S_AXI_AWVALID(S_AXI_AWVALID),
		.S_AXI_AWREADY(S_AXI_AWREADY),
		.S_AXI_WDATA(S_AXI_WDATA),
		.S_AXI_WSTRB(S_AXI_WSTRB),
		.S_AXI_WVALID(S_AXI_WVALID),
		.S_AXI_WREADY(S_AXI_WREADY),
		.S_AXI_BRESP(S_AXI_BRESP),
		.S_AXI_BVALID(S_AXI_BVALID),
		.S_AXI_BREADY(S_AXI_BREADY),
		.S_AXI_ARADDR(S_AXI_ARADDR),
		.S_AXI_ARPROT(S_AXI_ARPROT),
		.S_AXI_ARVALID(S_AXI_ARVALID),
		.S_AXI_ARREADY(S_AXI_ARREADY),
		.S_AXI_RDATA(S_AXI_RDATA),
		.S_AXI_RRESP(S_AXI_RRESP),
		.S_AXI_RVALID(S_AXI_RVALID),
		.S_AXI_RREADY(S_AXI_RREADY)
		);
endmodule