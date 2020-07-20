`include "define_axi.vh"
`timescale 1 ns / 1 ps

module tb_wr_channel(

	);
	
	parameter CLK_CYC = 20;

	reg [`C_M_AXI_DATA_WIDTH-1 : 0] awaddr;
	reg [`C_M_AXI_DATA_WIDTH-1 : 0] araddr;
	reg [`ADDR_WIDTH-1 : 0] mem_base_waddr;
	reg [`ADDR_WIDTH-1 : 0] mem_base_raddr;
	reg start_dma_w;
	reg start_dam_r;
	wire dma_w_done;
	wire dma_r_done;
	wire [`ADDR_WIDTH-1:0] wr_addr;
	wire wr_en;
    wire [`C_M_AXI_DATA_WIDTH-1:0] wr_data;

    wire [`ADDR_WIDTH-1:0] rd_addr;
    wire rd_en;
    wire rd_dat_vld;
    wire  [`C_M_AXI_DATA_WIDTH-1:0] rd_data;
	reg  M_AXI_ACLK;
	reg  M_AXI_ARESETN;
	wire [`C_M_AXI_ID_WIDTH-1 : 0] M_AXI_AWID;
	wire [`C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR;
	wire [7 : 0] M_AXI_AWLEN;
	wire [2 : 0] M_AXI_AWSIZE;
	wire [1 : 0] M_AXI_AWBURST;
	wire  M_AXI_AWLOCK;
	wire [3 : 0] M_AXI_AWCACHE;
	wire [2 : 0] M_AXI_AWPROT;
	wire [3 : 0] M_AXI_AWQOS;
	wire [`C_M_AXI_AWUSER_WIDTH-1 : 0] M_AXI_AWUSER;
	wire  M_AXI_AWVALID;
	reg  M_AXI_AWREADY;
	wire [`C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA;
	wire [`C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB;
	wire  M_AXI_WLAST;
	wire [`C_M_AXI_WUSER_WIDTH-1 : 0] M_AXI_WUSER;
	wire  M_AXI_WVALID;
	reg  M_AXI_WREADY;
	reg [`C_M_AXI_ID_WIDTH-1 : 0] M_AXI_BID;
	reg [1 : 0] M_AXI_BRESP;
	reg [`C_M_AXI_BUSER_WIDTH-1 : 0] M_AXI_BUSER;
	reg  M_AXI_BVALID;
	wire  M_AXI_BREADY;


	wire [`C_M_AXI_ID_WIDTH-1 : 0] M_AXI_ARID;
	wire [`C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_ARADDR;
	wire [7 : 0] M_AXI_ARLEN;
	wire [2 : 0] M_AXI_ARSIZE;
	wire [1 : 0] M_AXI_ARBURST;
	wire  M_AXI_ARLOCK;
	wire [3 : 0] M_AXI_ARCACHE;
	wire [2 : 0] M_AXI_ARPROT;
	wire [3 : 0] M_AXI_ARQOS;
	wire [`C_M_AXI_ARUSER_WIDTH-1 : 0] M_AXI_ARUSER;
	wire  M_AXI_ARVALID;
	reg  M_AXI_ARREADY;


	reg [`C_M_AXI_ID_WIDTH-1 : 0] M_AXI_RID;
	reg [`C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA;
	reg [1 : 0] M_AXI_RRESP;
	reg  M_AXI_RLAST;
	reg [`C_M_AXI_RUSER_WIDTH-1 : 0] M_AXI_RUSER;
	reg  M_AXI_RVALID;
	wire  M_AXI_RREADY;


	burst_axi burst_axi_inst(
		.awaddr(awaddr),
	 	.araddr(araddr),
		.mem_base_waddr(mem_base_waddr),
		.mem_base_raddr(mem_base_raddr),
		.start_dma_w(start_dma_w),
		.start_dma_r(start_dma_r),
		.dma_w_done(dma_w_done),
		.dma_r_done(dma_r_done),
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


	// reg [`ADDR_WIDTH-1:0] wr_addr_reg;
	// reg wr_en_reg;
 //    reg [`C_M_AXI_DATA_WIDTH-1:0] wr_data_reg;


	logic_mem logic_mem_inst(
		.clk(M_AXI_ACLK),
		.rst_n(M_AXI_ARESETN),
		// .wr_en(wr_en_reg),
		// .wr_addr(wr_addr_reg),
		// .wr_dat(wr_dat_reg),
 		.rd_en(rd_en),
		.rd_addr(rd_addr),
		.rd_dat_vld(rd_dat_vld),
		.rd_dat(rd_data)

		);

	initial begin
		INIT();
		START_WR_CHANNEL();
		while(burst_axi_inst.dma_w_done != 'd1) @(posedge M_AXI_ACLK);
		#1000 $stop;
	end 

	always begin
		#(CLK_CYC/2) M_AXI_ACLK = ~M_AXI_ACLK;
	end

	// M_AXI_AWREADY
	always @(posedge M_AXI_ACLK) begin
		if(M_AXI_ARESETN == 'd0) begin
			M_AXI_AWREADY <= 'd0;
		end
		else begin
			if(M_AXI_AWVALID && ~M_AXI_AWREADY) begin
				M_AXI_AWREADY <= 'd1;
			end
			else begin
				if( M_AXI_AWREADY )
					M_AXI_AWREADY <= 'd0;
			end
		end 
	end

	// M_AXI_WREADY
	always @(posedge M_AXI_ACLK) begin
		if(M_AXI_ARESETN == 'd0) begin
			M_AXI_WREADY <= 'd0;
		end
		else begin
			if( M_AXI_WVALID && (~M_AXI_WLAST)) begin
				M_AXI_WREADY <= 'd1;
			end
			else begin
				M_AXI_WREADY <= 'd0;
			end
		end
	end

	// M_AXI_BVALID
	always @( posedge M_AXI_ACLK ) begin
		if(M_AXI_ARESETN == 'd0) begin
			M_AXI_BVALID <= 'd0;
		end
		else begin
			if(M_AXI_WLAST) begin
				M_AXI_BVALID <= 'd1;
			end
			else begin
				if(M_AXI_BREADY && M_AXI_BVALID) begin
					M_AXI_BVALID <= 'd0;
				end
			end
		end
	end

	task INIT();
	begin
		M_AXI_ACLK <= 'd0;
		M_AXI_ARESETN <= 'd1;
		
		awaddr = $random;
		araddr = $random;
		mem_base_waddr = 0;
		mem_base_raddr = 0;
		start_dma_w = 0;
		start_dam_r = 0;
		M_AXI_AWREADY = 'd0;
		M_AXI_WREADY = 'd0;
		M_AXI_BVALID = 'd0;
		WAIT_CYCLE(1);
		M_AXI_ARESETN <= 'd0;
		WAIT_CYCLE(1);
		M_AXI_ARESETN <= 'd1;
	end
	endtask

	task START_WR_CHANNEL();
	begin
		WAIT_CYCLE(1);
		start_dma_w <= 'd1;
		WAIT_CYCLE(1);
		start_dma_w <= 'd0;
	end
	endtask

	task WAIT_CYCLE(input integer num);
	begin
		repeat(num)
			@(posedge M_AXI_ACLK);
	end
	endtask

	

endmodule // tb_wr_channel