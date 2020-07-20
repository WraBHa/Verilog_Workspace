`include "define_axi.vh"
`timescale 1 ns / 1 ps

module burst_axi #
(
	// Users to add parameters here
	// User parameters ends
	// Do not modify the parameters beyond this line

)
(
	// Users to add ports here
	input [`C_M_AXI_DATA_WIDTH-1 : 0] awaddr,
	input [`C_M_AXI_DATA_WIDTH-1 : 0] araddr,
	input [`ADDR_WIDTH-1 : 0] mem_base_waddr,
	input [`ADDR_WIDTH-1 : 0] mem_base_raddr,
	input start_dma_w,
	input start_dma_r,
	output dma_done_w,
	output dma_done_r,

	// data write to buffer
	output [`ADDR_WIDTH-1:0] wr_addr,
    output wr_en,
    output [`C_M_AXI_DATA_WIDTH-1:0] wr_data,


    // data read from buffer
    output [`ADDR_WIDTH-1:0] rd_addr,
    output rd_en,
    input  rd_dat_vld,
    input  [`C_M_AXI_DATA_WIDTH-1:0] rd_data,

	// User ports ends
	// Do not modify the ports beyond this line

	// Global Clock Signal.
	input wire  M_AXI_ACLK,
	// Global Reset Singal. This Signal is Active Low
	input wire  M_AXI_ARESETN,
	// AW channel
	// Master Interface Write Address ID
	output wire [`C_M_AXI_ID_WIDTH-1 : 0] M_AXI_AWID,// = 'b0
	// Master Interface Write Address 
	output wire [`C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR,
	// Burst length. The burst length gives the exact number of transfers in a burst
	output wire [7 : 0] M_AXI_AWLEN, // = C_M_AXI_BURST_LEN - 1;
	// Burst size. This signal indicates the size of each transfer in the burst
	output wire [2 : 0] M_AXI_AWSIZE,// clogb2((C_M_AXI_DATA_WIDTH/8)-1);
	// Burst type. The burst type and the size information, 
	// determine how the address for each transfer within the burst is calculated.
	output wire [1 : 0] M_AXI_AWBURST,//= 2'b01; the INCR mode
	// Lock type. Provides additional information about the
	// atomic characteristics of the transfer.
	output wire  M_AXI_AWLOCK,//= 1'b0; Normal access
	// Memory type. This signal indicates how transactions
	// are required to progress through a system.
	output wire [3 : 0] M_AXI_AWCACHE,//= 4'b0010; Normal Non-cacheable Non-bufferable
	// Protection type. This signal indicates the privilege
	// and security level of the transaction, and whether
	// the transaction is a data access or an instruction access.
	output wire [2 : 0] M_AXI_AWPROT,//= 3'h0; Unprivileged, secure, data access
	// Quality of Service, QoS identifier sent for each write transaction.
	output wire [3 : 0] M_AXI_AWQOS,//= 4'h0; not participating QoS
	// Optional User-defined signal in the write address channel.
	output wire [`C_M_AXI_AWUSER_WIDTH-1 : 0] M_AXI_AWUSER, // = 'b1; ?? doesn't know function
	// Write address valid. This signal indicates that
	// the channel is signaling valid write address and control information.
	output wire  M_AXI_AWVALID, // = axi_awvalid;
	// Write address ready. This signal indicates that
	// the slave is ready to accept an address and associated control signals
	input wire  M_AXI_AWREADY,

	// Wr channel
	// Master Interface Write Data.
	output wire [`C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA, //= axi_wdata;
	// Write strobes. This signal indicates which byte
	// lanes hold valid data. There is one write strobe
	// bit for each eight bits of the write data bus.
	output wire [`C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB, // = {(C_M_AXI_DATA_WIDTH/8){1'b1}};
	// Write last. This signal indicates the last transfer in a write burst.
	output wire  M_AXI_WLAST, // = axi_wlast;
	// Optional User-defined signal in the write data channel.
	output wire [`C_M_AXI_WUSER_WIDTH-1 : 0] M_AXI_WUSER, // = 'b0;
	// Write valid. This signal indicates that valid write
	// data and strobes are available
	output wire  M_AXI_WVALID, //= axi_wvalid;
	// Write ready. This signal indicates that the slave
	// can accept the write data.
	input wire  M_AXI_WREADY,
	// Master Interface Write Response.
	input wire [`C_M_AXI_ID_WIDTH-1 : 0] M_AXI_BID, //= 'b0;
	// Write response. This signal indicates the status of the write transaction.
	input wire [1 : 0] M_AXI_BRESP, //
	// Optional User-defined signal in the write response channel
	input wire [`C_M_AXI_BUSER_WIDTH-1 : 0] M_AXI_BUSER,
	// Write response valid. This signal indicates that the
	// channel is signaling a valid write response.
	input wire  M_AXI_BVALID,
	// Response ready. This signal indicates that the master
	// can accept a write response.
	output wire  M_AXI_BREADY, // 	= axi_bready

	// AR channel
	// Master Interface Read Address.
	output wire [`C_M_AXI_ID_WIDTH-1 : 0] M_AXI_ARID, //= 'b0;
	// Read address. This signal indicates the initial
	// address of a read burst transaction.
	output wire [`C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_ARADDR,
	// Burst length. The burst length gives the exact number of transfers in a burst
	output wire [7 : 0] M_AXI_ARLEN, //= C_M_AXI_BURST_LEN - 1;
	// Burst size. This signal indicates the size of each transfer in the burst
	output wire [2 : 0] M_AXI_ARSIZE, //= clogb2((C_M_AXI_DATA_WIDTH/8)-1);
	// Burst type. The burst type and the size information, 
	// determine how the address for each transfer within the burst is calculated.
	output wire [1 : 0] M_AXI_ARBURST, //= 2'b01;
	// Lock type. Provides additional information about the
	// atomic characteristics of the transfer.
	output wire  M_AXI_ARLOCK, // = 1'b0;
	// Memory type. This signal indicates how transactions
	// are required to progress through a system.
	output wire [3 : 0] M_AXI_ARCACHE, // = 4'b0010;
	// Protection type. This signal indicates the privilege
	// and security level of the transaction, and whether
	// the transaction is a data access or an instruction access.
	output wire [2 : 0] M_AXI_ARPROT, //= 3'h0;
	// Quality of Service, QoS identifier sent for each read transaction
	output wire [3 : 0] M_AXI_ARQOS, //= 4'h0;
	// Optional User-defined signal in the read address channel.
	output wire [`C_M_AXI_ARUSER_WIDTH-1 : 0] M_AXI_ARUSER, // = 'b1;
	// Write address valid. This signal indicates that
	// the channel is signaling valid read address and control information
	output wire  M_AXI_ARVALID, // = axi_arvalid;
	// Read address ready. This signal indicates that
	// the slave is ready to accept an address and associated control signals
	input wire  M_AXI_ARREADY, //

	//RD channel
	// Read ID tag. This signal is the identification tag
	// for the read data group of signals generated by the slave.
	input wire [`C_M_AXI_ID_WIDTH-1 : 0] M_AXI_RID, 
	// Master Read Data
	input wire [`C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA, //= axi_rready;
	// Read response. This signal indicates the status of the read transfer
	input wire [1 : 0] M_AXI_RRESP,
	// Read last. This signal indicates the last transfer in a read burst
	input wire  M_AXI_RLAST,
	// Optional User-defined signal in the read address channel.
	input wire [`C_M_AXI_RUSER_WIDTH-1 : 0] M_AXI_RUSER,
	// Read valid. This signal indicates that the channel
	// is signaling the required read data.
	input wire  M_AXI_RVALID,
	// Read ready. This signal indicates that the master can
	// accept the read data and response information.
	output wire  M_AXI_RREADY
);

/****************************port declaration****************************************************/
	// function called clogb2 that returns an integer which has the
	//value of the ceiling of the log base 2

	// function called clogb2 that returns an integer which has the 
	// value of the ceiling of the log base 2.                      
	function integer clogb2 (input integer bit_depth);              
	begin                                                           
	for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
	  bit_depth = bit_depth >> 1;                                 
	end                                                           
	endfunction     

	// aw_channel
	reg axi_awvalid;
	assign M_AXI_AWID = 'b0;
	assign M_AXI_AWADDR = awaddr;
	assign M_AXI_AWLEN = `C_M_MAX_AXI_BURST_LEN - 1;
	assign M_AXI_AWSIZE = clogb2((`C_M_AXI_DATA_WIDTH/8)-1); // for C_M_AXI_DATA_WIDTH = 32, M_AXI_AWSIZE = 2;
	assign M_AXI_AWBURST = 2'b01;
	assign M_AXI_AWLOCK = 1'b0;
	assign M_AXI_AWCACHE = 4'b0010;
	assign M_AXI_AWPROT = 3'h0; 
	assign M_AXI_AWQOS = 4'h0;
	assign M_AXI_AWUSER =  'b1; 
	assign M_AXI_AWVALID = axi_awvalid;
	

	// Wr channel
	reg axi_wlast;
	reg axi_wvalid;
	// reg [C_M_AXI_DATA_WIDTH-1 : 0] axi_wdata;
	assign M_AXI_WDATA = rd_data;
	assign M_AXI_WSTRB = {(`C_M_AXI_DATA_WIDTH/8){1'b1}};
	assign M_AXI_WLAST = axi_wlast;
	assign M_AXI_WUSER = 'b0;
	assign M_AXI_WVALID = axi_wvalid;

	reg dma_done_w_r;
	assign dma_done_w = dma_done_w_r;

	// B_CHANNEL
	reg axi_bready;
	assign M_AXI_BREADY = axi_bready;

	// AR CHANNEL
	reg axi_arvalid;
	assign M_AXI_ARID = 'b0;
	assign M_AXI_ARADDR = araddr;
	assign M_AXI_ARLEN = `C_M_MAX_AXI_BURST_LEN - 1;
	assign M_AXI_ARSIZE = clogb2((`C_M_AXI_DATA_WIDTH/8)-1);
	assign M_AXI_ARBURST = 2'b01;
	assign M_AXI_ARLOCK = 1'b0;
	assign M_AXI_ARCACHE = 4'b0010;
	assign M_AXI_ARPROT = 3'h0;
	assign M_AXI_ARQOS = 4'h0;
	assign M_AXI_ARUSER = 'b1;
	assign M_AXI_ARVALID = axi_arvalid;

	//RD channel
	reg axi_rready;
	assign wr_data = M_AXI_RDATA;
	assign M_AXI_RREADY = axi_rready;

	reg dma_done_r_r;
	assign dma_done_r = dma_done_r_r;
/********************************end of port declaration***********************************************/


	// wr process stateMachine
	localparam WSTATE_LEN = 'd3;
	localparam WIDLE = 'd0,
			   WS1 = 'd1,
			   WS2 = 'd2,
			   WS3 = 'd3,
			   WS4 = 'd4;

	reg [WSTATE_LEN-1 : 0] wcstate;  


	wire aw_handshaken;
	assign aw_handshaken = M_AXI_AWVALID && M_AXI_AWREADY;
	wire b_handshaken;
	assign b_handshaken = M_AXI_BREADY && M_AXI_BVALID;
	wire w_handshaken;
	assign w_handshaken = M_AXI_WVALID && M_AXI_WREADY; 

	// a counter that count how many data have transfered
	reg [clogb2((`C_M_MAX_AXI_BURST_LEN-1)) : 0] wcounter;
	reg start_burst_write;

	reg [1:0] start_dma_w_edge;
	wire start_dma_w_pos;


	always @(posedge M_AXI_ACLK) begin 
		if(~M_AXI_ARESETN) begin
			start_dma_w_edge <= 'd0;
		end else begin
			start_dma_w_edge[1:0] <= { start_dma_w_edge[0], start_dma_w };
		end
	end
	assign start_dma_w_pos = (~start_dma_w_edge[1]) & start_dma_w_edge[0];

	// 
	always @(posedge M_AXI_ACLK) begin
		if(M_AXI_ARESETN == 'd0) begin
			// state
			wcstate <= WIDLE;
			// signal
			axi_awvalid <= 'd0;
			axi_wvalid <= 'd0;
			dma_done_w_r <= 'd0;
			start_burst_write <= 'd0;

		end
		else begin
			case(wcstate) 
				WIDLE: begin
					if( start_dma_w_pos == 'd1 ) begin
						wcstate <= WS1;
						dma_done_w_r <= 'd0;
					end
				end
				WS1: begin
					if(~axi_awvalid) begin
						axi_awvalid <= 'd1;
					end
					else if(aw_handshaken) begin
						axi_awvalid <= 'd0;
						wcstate <= WS2;
					end
				end
				WS2: begin
					start_burst_write <= 'd1;
					wcstate <= WS3;
				end
				WS3: begin
					start_burst_write <= 'd0;
					axi_wvalid <='d1;
					if(axi_wlast && w_handshaken) begin
						axi_wvalid <='d0;
						wcstate <= WS4;
					end
				end
				WS4: begin
					dma_done_w_r <= 'd1;
					wcstate <= WIDLE;
				end
				default: begin
					wcstate <= WIDLE;
					axi_awvalid <= 'd0;
					axi_wvalid <= 'd0;
					dma_done_w_r <= 'd0;
					start_burst_write <= 'd0;
				end
			endcase
		end

	end

	// wcounter
	always @(posedge M_AXI_ACLK) begin

		if( (M_AXI_ARESETN == 'd0) || (start_burst_write == 'd1) ) begin
			wcounter <= 'd0;
		end
		else begin
			if( w_handshaken && ( wcounter != `C_M_MAX_AXI_BURST_LEN-1 )) begin
				wcounter <= wcounter + 1;
			end
		end

	end

	// axi_wlast
	always @(posedge M_AXI_ACLK) begin
		if( M_AXI_ARESETN == 'd0 ) begin
			axi_wlast <= 'd0;
		end
		else begin
			if(  (( wcounter == `C_M_MAX_AXI_BURST_LEN -2 && `C_M_MAX_AXI_BURST_LEN >= 2 ) && w_handshaken) || ( ( `C_M_MAX_AXI_BURST_LEN == 1 &&  start_burst_write == 'd1 ) ) ) begin
				axi_wlast <= 'd1;
			end
			else begin
				if(w_handshaken) begin
					axi_wlast <= 'd0;
				end 

			end
		end
	end

	// axi_bready
	always @(posedge M_AXI_ACLK) begin 
		if( M_AXI_ARESETN == 'd0 ) begin
			axi_bready <= 0;
		end else begin
			if( M_AXI_BVALID && (~axi_bready) ) begin
				axi_bready <= 'd1;
			end 
			else begin 
				if(axi_bready) begin
					axi_bready <= 'd0;
				end
				else 
					axi_bready <= axi_bready;
			end

		end
	end

	//control the memory connect to axi

	reg [`ADDR_WIDTH-1 : 0] raddr_offset;
	always @(posedge M_AXI_ACLK) begin
		if( M_AXI_ARESETN == 'd0 || dma_done_w  ) begin
			raddr_offset <= 'd0;
		end 
		else begin
			if( rd_en && (raddr_offset != `C_M_MAX_AXI_BURST_LEN-1 ))
				raddr_offset <= raddr_offset + 'd1;
		end
	end
	assign rd_en =  start_burst_write || w_handshaken;
	assign rd_addr = mem_base_raddr + raddr_offset;

/**************************************************** AR and RD channel *************************************************/
	
	wire ar_handshaken, r_handshaken;
	assign ar_handshaken = M_AXI_ARREADY && M_AXI_ARVALID;
	assign r_handshaken = M_AXI_RVALID && M_AXI_RREADY;

	localparam RSTATE_LEN = 'd3;
	localparam RIDLE = 'd0,
			   RS1 = 'd1,
			   RS2 = 'd2,
			   RS3 = 'd3,
			   RS4 = 'd4;
	reg [RSTATE_LEN-1 : 0] rcstate;

	reg [1:0] start_dma_r_edge;
	wire start_dma_r_pos;

	always @(posedge M_AXI_ACLK) begin 
		if(~M_AXI_ARESETN) begin
			start_dma_r_edge <= 'd0;
		end else begin
			start_dma_r_edge[1:0] <= { start_dma_r_edge[0], start_dma_r };
		end
	end
	assign start_dma_r_pos = (~start_dma_r_edge[1]) & start_dma_r_edge[0];

	always @(posedge M_AXI_ACLK) begin
		if(M_AXI_ARESETN == 'd0) begin
			dma_done_r_r <= 'd0;
			axi_arvalid <= 'd0;
			axi_rready <= 'd0;
			rcstate <= RIDLE;
		end
		else begin
			case(rcstate)
				RIDLE: begin
					if(start_dma_r_pos) begin
						dma_done_r_r <= 'd0;
						rcstate = RS1;
					end
				end
				RS1: begin
					if(~axi_arvalid) begin
						axi_arvalid <= 'd1;
					end
					else begin
						if( ar_handshaken ) begin
							axi_arvalid <= 'd0;
							rcstate <= RS2;
						end
					end
				end
				RS2: begin
					axi_rready <= 'd1;
					if(M_AXI_RLAST && r_handshaken) begin
						axi_rready <= 'd0;
						rcstate <= RS3;
					end
				end
				RS3: begin
					dma_done_r_r <= 'd1;
					rcstate <= RIDLE;
				end
				default: begin
					dma_done_r_r <= 'd0;
					axi_arvalid <= 'd0;
					axi_rready <= 'd0;
					rcstate <= RIDLE;
				end
			endcase
		end
	end	

	// control signal about wr to buffer
	reg [`ADDR_WIDTH-1 : 0] waddr_offset;
	always @(posedge M_AXI_ACLK) begin
		if( M_AXI_ARESETN == 'd0 || dma_done_r  ) begin
			waddr_offset <= 'd0;
		end 
		else begin
			if( wr_en && (waddr_offset != `C_M_MAX_AXI_BURST_LEN-1 ))
				waddr_offset <= waddr_offset + 'd1;
		end
	end
	assign wr_addr = mem_base_waddr + waddr_offset;
    assign wr_en = r_handshaken;
    assign wr_data = M_AXI_RDATA;

endmodule
