
create_clock -name dco_clk -period 1500 -waveform {0 750} [get_ports dco_clk]
set_clock_transition -rise -min 154 [get_clocks dco_clk]
set_clock_transition -fall -min 155 [get_clocks dco_clk]
set_clock_transition -rise -max 156 [get_clocks dco_clk]
set_clock_transition -fall -max 157 [get_clocks dco_clk]
set_clock_latency -source -early -rise 150 [get_clocks dco_clk]
set_clock_latency -source -early -fall 151 [get_clocks dco_clk]
set_clock_latency -source -late -rise 152 [get_clocks dco_clk]
set_clock_latency -source -late -fall 153 [get_clocks dco_clk]
create_clock -name lfxt_clk -period 1600 -waveform {0 960} [get_ports lfxt_clk]
set_clock_transition -rise -min 155 [get_clocks lfxt_clk]
set_clock_transition -fall -min 156 [get_clocks lfxt_clk]
set_clock_transition -rise -max 157 [get_clocks lfxt_clk]
set_clock_transition -fall -max 158 [get_clocks lfxt_clk]
set_clock_latency -source -early -rise 151 [get_clocks lfxt_clk]
set_clock_latency -source -early -fall 152 [get_clocks lfxt_clk]
set_clock_latency -source -late -rise 153 [get_clocks lfxt_clk]
set_clock_latency -source -late -fall 154 [get_clocks lfxt_clk]
set_input_transition -clock [get_clocks yet_to_decide1] -min -rise -source_latency_included 150 cpu_en
set_input_transition -clock [get_clocks yet_to_decide1] -min -fall -source_latency_included 151 cpu_en
set_input_transition -clock [get_clocks yet_to_decide1] -max -rise -source_latency_included 152 cpu_en
set_input_transition -clock [get_clocks yet_to_decide1] -max -fall -source_latency_included 153 cpu_en
set_input_delay -clock [get_clocks yet_to_decide1] -min -rise -source_latency_included 100 cpu_en
set_input_delay -clock [get_clocks yet_to_decide1] -min -fall -source_latency_included 101 cpu_en
set_input_delay -clock [get_clocks yet_to_decide1] -max -rise -source_latency_included 102 cpu_en
set_input_delay -clock [get_clocks yet_to_decide1] -max -fall -source_latency_included 103 cpu_en
set_input_transition -clock [get_clocks yet_to_decide2] -min -rise -source_latency_included 151 dbg_en
set_input_transition -clock [get_clocks yet_to_decide2] -min -fall -source_latency_included 152 dbg_en
set_input_transition -clock [get_clocks yet_to_decide2] -max -rise -source_latency_included 153 dbg_en
set_input_transition -clock [get_clocks yet_to_decide2] -max -fall -source_latency_included 154 dbg_en
set_input_delay -clock [get_clocks yet_to_decide2] -min -rise -source_latency_included 101 dbg_en
set_input_delay -clock [get_clocks yet_to_decide2] -min -fall -source_latency_included 102 dbg_en
set_input_delay -clock [get_clocks yet_to_decide2] -max -rise -source_latency_included 103 dbg_en
set_input_delay -clock [get_clocks yet_to_decide2] -max -fall -source_latency_included 104 dbg_en
set_input_transition -clock [get_clocks yet_to_decide3] -min -rise -source_latency_included 152 dbg_i2c_addr*
set_input_transition -clock [get_clocks yet_to_decide3] -min -fall -source_latency_included 153 dbg_i2c_addr*
set_input_transition -clock [get_clocks yet_to_decide3] -max -rise -source_latency_included 154 dbg_i2c_addr*
set_input_transition -clock [get_clocks yet_to_decide3] -max -fall -source_latency_included 155 dbg_i2c_addr*
set_input_delay -clock [get_clocks yet_to_decide3] -min -rise -source_latency_included 102 dbg_i2c_addr*
set_input_delay -clock [get_clocks yet_to_decide3] -min -fall -source_latency_included 103 dbg_i2c_addr*
set_input_delay -clock [get_clocks yet_to_decide3] -max -rise -source_latency_included 104 dbg_i2c_addr*
set_input_delay -clock [get_clocks yet_to_decide3] -max -fall -source_latency_included 105 dbg_i2c_addr*
set_input_transition -clock [get_clocks yet_to_decide4] -min -rise -source_latency_included 153 dbg_i2c_broadcast*
set_input_transition -clock [get_clocks yet_to_decide4] -min -fall -source_latency_included 154 dbg_i2c_broadcast*
set_input_transition -clock [get_clocks yet_to_decide4] -max -rise -source_latency_included 155 dbg_i2c_broadcast*
set_input_transition -clock [get_clocks yet_to_decide4] -max -fall -source_latency_included 156 dbg_i2c_broadcast*
set_input_delay -clock [get_clocks yet_to_decide4] -min -rise -source_latency_included 103 dbg_i2c_broadcast*
set_input_delay -clock [get_clocks yet_to_decide4] -min -fall -source_latency_included 104 dbg_i2c_broadcast*
set_input_delay -clock [get_clocks yet_to_decide4] -max -rise -source_latency_included 105 dbg_i2c_broadcast*
set_input_delay -clock [get_clocks yet_to_decide4] -max -fall -source_latency_included 106 dbg_i2c_broadcast*
set_input_transition -clock [get_clocks yet_to_decide5] -min -rise -source_latency_included 154 dbg_i2c_scl
set_input_transition -clock [get_clocks yet_to_decide5] -min -fall -source_latency_included 155 dbg_i2c_scl
set_input_transition -clock [get_clocks yet_to_decide5] -max -rise -source_latency_included 156 dbg_i2c_scl
set_input_transition -clock [get_clocks yet_to_decide5] -max -fall -source_latency_included 157 dbg_i2c_scl
set_input_delay -clock [get_clocks yet_to_decide5] -min -rise -source_latency_included 104 dbg_i2c_scl
set_input_delay -clock [get_clocks yet_to_decide5] -min -fall -source_latency_included 105 dbg_i2c_scl
set_input_delay -clock [get_clocks yet_to_decide5] -max -rise -source_latency_included 106 dbg_i2c_scl
set_input_delay -clock [get_clocks yet_to_decide5] -max -fall -source_latency_included 107 dbg_i2c_scl
set_input_transition -clock [get_clocks yet_to_decide6] -min -rise -source_latency_included 155 dbg_i2c_sda_in
set_input_transition -clock [get_clocks yet_to_decide6] -min -fall -source_latency_included 156 dbg_i2c_sda_in
set_input_transition -clock [get_clocks yet_to_decide6] -max -rise -source_latency_included 157 dbg_i2c_sda_in
set_input_transition -clock [get_clocks yet_to_decide6] -max -fall -source_latency_included 158 dbg_i2c_sda_in
set_input_delay -clock [get_clocks yet_to_decide6] -min -rise -source_latency_included 105 dbg_i2c_sda_in
set_input_delay -clock [get_clocks yet_to_decide6] -min -fall -source_latency_included 106 dbg_i2c_sda_in
set_input_delay -clock [get_clocks yet_to_decide6] -max -rise -source_latency_included 107 dbg_i2c_sda_in
set_input_delay -clock [get_clocks yet_to_decide6] -max -fall -source_latency_included 108 dbg_i2c_sda_in
set_input_transition -clock [get_clocks yet_to_decide7] -min -rise -source_latency_included 156 dbg_uart_rxd
set_input_transition -clock [get_clocks yet_to_decide7] -min -fall -source_latency_included 157 dbg_uart_rxd
set_input_transition -clock [get_clocks yet_to_decide7] -max -rise -source_latency_included 158 dbg_uart_rxd
set_input_transition -clock [get_clocks yet_to_decide7] -max -fall -source_latency_included 159 dbg_uart_rxd
set_input_delay -clock [get_clocks yet_to_decide7] -min -rise -source_latency_included 106 dbg_uart_rxd
set_input_delay -clock [get_clocks yet_to_decide7] -min -fall -source_latency_included 107 dbg_uart_rxd
set_input_delay -clock [get_clocks yet_to_decide7] -max -rise -source_latency_included 108 dbg_uart_rxd
set_input_delay -clock [get_clocks yet_to_decide7] -max -fall -source_latency_included 109 dbg_uart_rxd
set_input_transition -clock [get_clocks yet_to_decide8] -min -rise -source_latency_included 158 dmem_dout*
set_input_transition -clock [get_clocks yet_to_decide8] -min -fall -source_latency_included 159 dmem_dout*
set_input_transition -clock [get_clocks yet_to_decide8] -max -rise -source_latency_included 160 dmem_dout*
set_input_transition -clock [get_clocks yet_to_decide8] -max -fall -source_latency_included 161 dmem_dout*
set_input_delay -clock [get_clocks yet_to_decide8] -min -rise -source_latency_included 108 dmem_dout*
set_input_delay -clock [get_clocks yet_to_decide8] -min -fall -source_latency_included 109 dmem_dout*
set_input_delay -clock [get_clocks yet_to_decide8] -max -rise -source_latency_included 110 dmem_dout*
set_input_delay -clock [get_clocks yet_to_decide8] -max -fall -source_latency_included 111 dmem_dout*
set_input_transition -clock [get_clocks yet_to_decide9] -min -rise -source_latency_included 159 irq*
set_input_transition -clock [get_clocks yet_to_decide9] -min -fall -source_latency_included 160 irq*
set_input_transition -clock [get_clocks yet_to_decide9] -max -rise -source_latency_included 161 irq*
set_input_transition -clock [get_clocks yet_to_decide9] -max -fall -source_latency_included 162 irq*
set_input_delay -clock [get_clocks yet_to_decide9] -min -rise -source_latency_included 109 irq*
set_input_delay -clock [get_clocks yet_to_decide9] -min -fall -source_latency_included 110 irq*
set_input_delay -clock [get_clocks yet_to_decide9] -max -rise -source_latency_included 111 irq*
set_input_delay -clock [get_clocks yet_to_decide9] -max -fall -source_latency_included 112 irq*
set_input_transition -clock [get_clocks yet_to_decide10] -min -rise -source_latency_included 161 dma_addr*
set_input_transition -clock [get_clocks yet_to_decide10] -min -fall -source_latency_included 162 dma_addr*
set_input_transition -clock [get_clocks yet_to_decide10] -max -rise -source_latency_included 163 dma_addr*
set_input_transition -clock [get_clocks yet_to_decide10] -max -fall -source_latency_included 164 dma_addr*
set_input_delay -clock [get_clocks yet_to_decide10] -min -rise -source_latency_included 111 dma_addr*
set_input_delay -clock [get_clocks yet_to_decide10] -min -fall -source_latency_included 112 dma_addr*
set_input_delay -clock [get_clocks yet_to_decide10] -max -rise -source_latency_included 113 dma_addr*
set_input_delay -clock [get_clocks yet_to_decide10] -max -fall -source_latency_included 114 dma_addr*
set_input_transition -clock [get_clocks yet_to_decide11] -min -rise -source_latency_included 162 dma_din*
set_input_transition -clock [get_clocks yet_to_decide11] -min -fall -source_latency_included 163 dma_din*
set_input_transition -clock [get_clocks yet_to_decide11] -max -rise -source_latency_included 164 dma_din*
set_input_transition -clock [get_clocks yet_to_decide11] -max -fall -source_latency_included 165 dma_din*
set_input_delay -clock [get_clocks yet_to_decide11] -min -rise -source_latency_included 112 dma_din*
set_input_delay -clock [get_clocks yet_to_decide11] -min -fall -source_latency_included 113 dma_din*
set_input_delay -clock [get_clocks yet_to_decide11] -max -rise -source_latency_included 114 dma_din*
set_input_delay -clock [get_clocks yet_to_decide11] -max -fall -source_latency_included 115 dma_din*
set_input_transition -clock [get_clocks yet_to_decide12] -min -rise -source_latency_included 163 dma_en
set_input_transition -clock [get_clocks yet_to_decide12] -min -fall -source_latency_included 164 dma_en
set_input_transition -clock [get_clocks yet_to_decide12] -max -rise -source_latency_included 165 dma_en
set_input_transition -clock [get_clocks yet_to_decide12] -max -fall -source_latency_included 166 dma_en
set_input_delay -clock [get_clocks yet_to_decide12] -min -rise -source_latency_included 113 dma_en
set_input_delay -clock [get_clocks yet_to_decide12] -min -fall -source_latency_included 114 dma_en
set_input_delay -clock [get_clocks yet_to_decide12] -max -rise -source_latency_included 115 dma_en
set_input_delay -clock [get_clocks yet_to_decide12] -max -fall -source_latency_included 116 dma_en
set_input_transition -clock [get_clocks yet_to_decide13] -min -rise -source_latency_included 164 dma_priority
set_input_transition -clock [get_clocks yet_to_decide13] -min -fall -source_latency_included 165 dma_priority
set_input_transition -clock [get_clocks yet_to_decide13] -max -rise -source_latency_included 166 dma_priority
set_input_transition -clock [get_clocks yet_to_decide13] -max -fall -source_latency_included 167 dma_priority
set_input_delay -clock [get_clocks yet_to_decide13] -min -rise -source_latency_included 114 dma_priority
set_input_delay -clock [get_clocks yet_to_decide13] -min -fall -source_latency_included 115 dma_priority
set_input_delay -clock [get_clocks yet_to_decide13] -max -rise -source_latency_included 116 dma_priority
set_input_delay -clock [get_clocks yet_to_decide13] -max -fall -source_latency_included 117 dma_priority
set_input_transition -clock [get_clocks yet_to_decide14] -min -rise -source_latency_included 165 dma_we*
set_input_transition -clock [get_clocks yet_to_decide14] -min -fall -source_latency_included 166 dma_we*
set_input_transition -clock [get_clocks yet_to_decide14] -max -rise -source_latency_included 167 dma_we*
set_input_transition -clock [get_clocks yet_to_decide14] -max -fall -source_latency_included 168 dma_we*
set_input_delay -clock [get_clocks yet_to_decide14] -min -rise -source_latency_included 115 dma_we*
set_input_delay -clock [get_clocks yet_to_decide14] -min -fall -source_latency_included 116 dma_we*
set_input_delay -clock [get_clocks yet_to_decide14] -max -rise -source_latency_included 117 dma_we*
set_input_delay -clock [get_clocks yet_to_decide14] -max -fall -source_latency_included 118 dma_we*
set_input_transition -clock [get_clocks yet_to_decide15] -min -rise -source_latency_included 166 dma_wkup
set_input_transition -clock [get_clocks yet_to_decide15] -min -fall -source_latency_included 167 dma_wkup
set_input_transition -clock [get_clocks yet_to_decide15] -max -rise -source_latency_included 168 dma_wkup
set_input_transition -clock [get_clocks yet_to_decide15] -max -fall -source_latency_included 169 dma_wkup
set_input_delay -clock [get_clocks yet_to_decide15] -min -rise -source_latency_included 116 dma_wkup
set_input_delay -clock [get_clocks yet_to_decide15] -min -fall -source_latency_included 117 dma_wkup
set_input_delay -clock [get_clocks yet_to_decide15] -max -rise -source_latency_included 118 dma_wkup
set_input_delay -clock [get_clocks yet_to_decide15] -max -fall -source_latency_included 119 dma_wkup
set_input_transition -clock [get_clocks yet_to_decide16] -min -rise -source_latency_included 167 nmi
set_input_transition -clock [get_clocks yet_to_decide16] -min -fall -source_latency_included 168 nmi
set_input_transition -clock [get_clocks yet_to_decide16] -max -rise -source_latency_included 169 nmi
set_input_transition -clock [get_clocks yet_to_decide16] -max -fall -source_latency_included 170 nmi
set_input_delay -clock [get_clocks yet_to_decide16] -min -rise -source_latency_included 117 nmi
set_input_delay -clock [get_clocks yet_to_decide16] -min -fall -source_latency_included 118 nmi
set_input_delay -clock [get_clocks yet_to_decide16] -max -rise -source_latency_included 119 nmi
set_input_delay -clock [get_clocks yet_to_decide16] -max -fall -source_latency_included 120 nmi
set_input_transition -clock [get_clocks yet_to_decide17] -min -rise -source_latency_included 168 per_dout*
set_input_transition -clock [get_clocks yet_to_decide17] -min -fall -source_latency_included 169 per_dout*
set_input_transition -clock [get_clocks yet_to_decide17] -max -rise -source_latency_included 170 per_dout*
set_input_transition -clock [get_clocks yet_to_decide17] -max -fall -source_latency_included 171 per_dout*
set_input_delay -clock [get_clocks yet_to_decide17] -min -rise -source_latency_included 118 per_dout*
set_input_delay -clock [get_clocks yet_to_decide17] -min -fall -source_latency_included 119 per_dout*
set_input_delay -clock [get_clocks yet_to_decide17] -max -rise -source_latency_included 120 per_dout*
set_input_delay -clock [get_clocks yet_to_decide17] -max -fall -source_latency_included 121 per_dout*
set_input_transition -clock [get_clocks yet_to_decide18] -min -rise -source_latency_included 169 pmem_dout*
set_input_transition -clock [get_clocks yet_to_decide18] -min -fall -source_latency_included 170 pmem_dout*
set_input_transition -clock [get_clocks yet_to_decide18] -max -rise -source_latency_included 171 pmem_dout*
set_input_transition -clock [get_clocks yet_to_decide18] -max -fall -source_latency_included 172 pmem_dout*
set_input_delay -clock [get_clocks yet_to_decide18] -min -rise -source_latency_included 119 pmem_dout*
set_input_delay -clock [get_clocks yet_to_decide18] -min -fall -source_latency_included 120 pmem_dout*
set_input_delay -clock [get_clocks yet_to_decide18] -max -rise -source_latency_included 121 pmem_dout*
set_input_delay -clock [get_clocks yet_to_decide18] -max -fall -source_latency_included 122 pmem_dout*
set_input_transition -clock [get_clocks yet_to_decide19] -min -rise -source_latency_included 170 reset_n
set_input_transition -clock [get_clocks yet_to_decide19] -min -fall -source_latency_included 171 reset_n
set_input_transition -clock [get_clocks yet_to_decide19] -max -rise -source_latency_included 172 reset_n
set_input_transition -clock [get_clocks yet_to_decide19] -max -fall -source_latency_included 173 reset_n
set_input_delay -clock [get_clocks yet_to_decide19] -min -rise -source_latency_included 120 reset_n
set_input_delay -clock [get_clocks yet_to_decide19] -min -fall -source_latency_included 121 reset_n
set_input_delay -clock [get_clocks yet_to_decide19] -max -rise -source_latency_included 122 reset_n
set_input_delay -clock [get_clocks yet_to_decide19] -max -fall -source_latency_included 123 reset_n
set_input_transition -clock [get_clocks yet_to_decide20] -min -rise -source_latency_included 171 scan_enable
set_input_transition -clock [get_clocks yet_to_decide20] -min -fall -source_latency_included 172 scan_enable
set_input_transition -clock [get_clocks yet_to_decide20] -max -rise -source_latency_included 173 scan_enable
set_input_transition -clock [get_clocks yet_to_decide20] -max -fall -source_latency_included 174 scan_enable
set_input_delay -clock [get_clocks yet_to_decide20] -min -rise -source_latency_included 121 scan_enable
set_input_delay -clock [get_clocks yet_to_decide20] -min -fall -source_latency_included 122 scan_enable
set_input_delay -clock [get_clocks yet_to_decide20] -max -rise -source_latency_included 123 scan_enable
set_input_delay -clock [get_clocks yet_to_decide20] -max -fall -source_latency_included 124 scan_enable
set_input_transition -clock [get_clocks yet_to_decide21] -min -rise -source_latency_included 172 scan_mode
set_input_transition -clock [get_clocks yet_to_decide21] -min -fall -source_latency_included 173 scan_mode
set_input_transition -clock [get_clocks yet_to_decide21] -max -rise -source_latency_included 174 scan_mode
set_input_transition -clock [get_clocks yet_to_decide21] -max -fall -source_latency_included 175 scan_mode
set_input_delay -clock [get_clocks yet_to_decide21] -min -rise -source_latency_included 122 scan_mode
set_input_delay -clock [get_clocks yet_to_decide21] -min -fall -source_latency_included 123 scan_mode
set_input_delay -clock [get_clocks yet_to_decide21] -max -rise -source_latency_included 124 scan_mode
set_input_delay -clock [get_clocks yet_to_decide21] -max -fall -source_latency_included 125 scan_mode