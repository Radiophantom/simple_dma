module simple_dma_engine #(
  parameter BURST_SIZE      = 256,
  parameter LAST_BURST_SIZE = (END_ADDR-START_ADDR)%BURST_SIZE,
  parameter BURST_W         = $clog2( BURST_SIZE )
)(
  input       rst_i,
  input       clk_i,

  input       en_i,

  input []    start_addr_i,
  input []    end_addr_i,

  input       rd_en_i,
  output []   rd_data_o
);

enum logic [2:0] {
  IDLE_S,
  TRANSFER_S,
  IRQ_S
} state, next_state;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    state <= IDLE_S;
  else
    state <= next_state;

always_comb
  begin
    next_state = state;
    case( state )
      IDLE_S:
        begin
          if( en_i )
            next_state = READ_S;
        end

      READ_S:
        begin
          if( sdram_if.read && !sdram_if.waitrequest )
            next_state = WAIT_S;
        end

      WAIT_S:
        begin
          if( sdram_if.readdatavalid && rcv_words_cnt == RCV_WORDS )
            if( en_i )
              next_state = READ_S;
            else
              next_state = IDLE_S;
        end

      default:
        begin
          next_state = IDLE_S;
        end
    endcase
  end

logic [BURST_W-1:0] burst_rcv_words_cnt;
logic               is_last_burst_word;

always_ff @( posedge clk_i )
  if( sdram_if.read && !sdram_if.waitrequest )
    burst_rcv_words_cnt <= '0;
  else
    if( sdram_if.readdatavalid )
      burst_rcv_words_cnt <= burst_rcv_words_cnt + 1'b1;

assign is_last_burst_word = burst_rcv_words_cnt == BURST_SIZE-1;

logic [26:0] rd_ptr_cnt;

always_ff @( posedge clk_i )
  if( state == IDLE_S && en_i )
    rd_ptr_cnt <= START_ADDR;
  else
    if( state == WAIT_S && is_last_burst_word && sdram_if.readdatavalid )
      if( is_last_line )
        rd_ptr_cnt <= START_ADDR;
      else
        rd_ptr_cnt <= rd_ptr_cnt + BURST_SIZE;

always_ff @( posedge clk_i )
  if( state == READ_S )
    if( is_last_line )
      sdram_if.burstcount <= LAST_BURST_SIZE;
    else
      sdram_if.burstcount <= BURST_SIZE;

always_ff @( posedge clk_i )
  if( sdram_if.read && !sdram_if.waitrequest )
    src_if.read <= 1'b0;
  else
    if( state == READ_S && !sdram_if.read )
      sdram_if.read <= 1'b1;

/*
* FIFO INSTANCE MUST BE HERE
*
*
*
*
*/

always_ff @( posedge clk_i )
  if( rd_en_i )
    if( pix_cnt == 7 )
      pix_reg <= fifo_rddata;
    else
      pix_reg <= 

endmodule
