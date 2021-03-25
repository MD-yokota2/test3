-------------------------------------------------------------------------------
-- Copyright (c) 2006 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor      : Xilinx
-- \   \   \/     Version     : J.23
--  \   \         Description : Xilinx HDL Macro Library
--  /   /                       2-Bit Cascadable Binary Counter with Clock Enable and Asynchronous Clear
-- /___/   /\     Filename    : CB2CE.vhd
-- \   \  /  \    Timestamp   : Fri Jul 28 2006
--  \___\/\___\
--
-- Revision:
-- 07/28/06 - Initial version.
-- End Revision

----- CELL CB2CE -----


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CB2CE is
port (
			Q0   : out 	STD_LOGIC;
			Q1   : out 	STD_LOGIC;
    
			C    : in 	STD_LOGIC;
			CE   : in 	STD_LOGIC;
			CLR  : in 	STD_LOGIC
    );
end CB2CE;

architecture Behavioral of CB2CE is

signal 	COUNT 			: STD_LOGIC_VECTOR(1 downto 0):=b"11";
constant TERMINAL_COUNT : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
  
begin
	process(C,CLR)
	begin
	if (CLR='0') then
		COUNT <= (others => '0');
	elsif (C'event and C = '0') then
		if (CE='1') then 
			COUNT <= COUNT+1;
		end if;
	end if;
end process;


Q1 <= COUNT(1);
Q0 <= COUNT(0);

end Behavioral;

