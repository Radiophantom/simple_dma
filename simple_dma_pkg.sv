package simple_dma_pkg;

parameter START_ADDR = ;
parameter END_ADDR   = ;

parameter DMA_CTRL_CR     = 0;
    parameter DMA_CTRL_CR_EN        = 0;
    parameter DMA_CTRL_CR_INT       = 1;
    parameter DMA_CTRL_CR_INT_TYPE  = 2;

parameter DMA_ADDR_W0_CR  = 1;
parameter DMA_ADDR_W1_CR  = 2;

parameter DMA_CNT_W0_CR   = 3;
parameter DMA_CNT_W1_CR   = 4;

parameter DMA_CNT_INC_CR  = 5;

parameter DMA_CR_CNT      = 6;

parameter DMA_STATUS_SR = 0;
    parameter DMA_STATUS_SR_BUSY = 0;

parameter DMA_SR_CNT    = 1;

endpackage
