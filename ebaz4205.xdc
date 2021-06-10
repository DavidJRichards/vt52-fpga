# djrm April 17 2021
# ebaz4205 constraints
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports ENET0_GMII_RX_CLK_0]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports ENET0_GMII_TX_CLK_0]
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports {enet0_gmii_rxd[3]}]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports {enet0_gmii_rxd[2]}]
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {enet0_gmii_rxd[1]}]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports {enet0_gmii_rxd[0]}]
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports {ENET0_GMII_TX_EN_0[0]}]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports {enet0_gmii_txd[3]}]
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports {enet0_gmii_txd[2]}]
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports {enet0_gmii_txd[1]}]
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {enet0_gmii_txd[0]}]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports ENET0_GMII_RX_DV_0]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33} [get_ports MDIO_ETHERNET_0_0_mdc]
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports MDIO_ETHERNET_0_0_mdio_io]

# 25 MHz
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports ETHERNET_CLOCK]
# 33.3 Mhz MHz
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports MULTICOMP_CLOCK]

# LEDs
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS33} [get_ports {led_blue}]
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports {led_green}]
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports {led_red}]

#pmod a - gpios
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports {pmod[0]}]
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS33} [get_ports {pmod[1]}]
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS33} [get_ports {pmod[2]}]
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS33} [get_ports {pmod[3]}]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {pmod[4]}]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports {pmod[5]}]
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports {pmod[6]}]
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS33} [get_ports {pmod[7]}]
# end

## pmod b, rotary switch
#set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 PULLUP true} [get_ports { buttons_0[0] }]; 
#set_property -dict { PACKAGE_PIN F19   IOSTANDARD LVCMOS33 PULLUP true} [get_ports { buttons_0[1] }]; 
#set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 PULLUP true} [get_ports { buttons_0[2] }]; 
#set_property -dict { PACKAGE_PIN F20   IOSTANDARD LVCMOS33 PULLUP true} [get_ports { buttons_0[3] }]; 

#########################################################
# Clock (33.333 MHz)                                       #
#########################################################
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports {pin_clk}]
create_clock -period 30.0 -name sys_clk_pin -waveform {0.000 4.000} -add [get_ports pin_clk]

# switch / button
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33 PULLUP true} [get_ports {pin_button}]

# gpio 66, 67, 68, 69
# USB UART interface
set_property -dict { PACKAGE_PIN F19   IOSTANDARD LVCMOS33 } [get_ports pin_usb_n]; 
set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports pin_usb_p]; 
set_property -dict { PACKAGE_PIN F20   IOSTANDARD LVCMOS33 } [get_ports pin_led]; 
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports pin_pu]; 

##################################
# J3, PS2 interface
##################################
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33 PULLUP true} [get_ports ps2_data] 
set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS33 PULLUP true} [get_ports ps2_clk]

##################################
# J5 UART interface
##################################
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports {uart_rtl_rxd}]
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33 } [get_ports {uart_rtl_txd}]

#########################################################
# VGA                                                   #
#########################################################
# ADV7123
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS33} [get_ports {vga_clk}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {hsync}]
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33} [get_ports {vsync}]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports {vga_blank}]
# red
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {vga_r[0]}]
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports {vga_r[1]}]
set_property -dict {PACKAGE_PIN H20 IOSTANDARD LVCMOS33} [get_ports {vga_r[2]}]
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports {vga_r[3]}]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports {vga_r[4]}]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS33} [get_ports {vga_r[5]}]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33} [get_ports {vga_r[6]}]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports {vga_r[7]}]
# green
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports {vga_g[0]}]
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports {vga_g[1]}]
set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports {vga_g[2]}]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports {vga_g[3]}]
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33} [get_ports {vga_g[4]}]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports {vga_g[5]}]
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports {vga_g[6]}]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports {vga_g[7]}]
# blue
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports {vga_b[0]}]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports {vga_b[1]}]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports {vga_b[2]}]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {vga_b[3]}]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33} [get_ports {vga_b[4]}]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports {vga_b[5]}]
set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33} [get_ports {vga_b[6]}]
set_property -dict {PACKAGE_PIN U20 IOSTANDARD LVCMOS33} [get_ports {vga_b[7]}]

