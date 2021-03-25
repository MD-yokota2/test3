----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:18:06 03/10/2010 
-- Design Name: 
-- Module Name:    darc_IC - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity darc_IC is
	port (
			clkW_h		: In  	std_logic;
			clkR_16		: In 	std_logic;
         		clr		: In 	std_logic;
         		ceS		: In 	std_logic;
			bank_sg		: In 	std_logic;
			rst		: In 	std_logic;
			we_i		: In 	std_logic;

			ly3_dt		: In	std_logic_vector (15 DownTo 0);
			ad_r_dt		: In	std_logic_vector (15 DownTo 0);
			ad_r_pt		: In	std_logic_vector (14 DownTo 0);

-------------- for debug ----  romFF  ----------------
			addr10ROM	: Out	std_logic_vector (03 DownTo 0);
------------------------------------------------------
			pt_out		: Out	std_logic;
			dt_out		: Out	std_logic;

-- writing data action check-----temp IC --------------
			f_fg		: Out	std_logic
-------------------------------------------------------
        );
	end darc_IC;

architecture Behavioral of darc_IC is

	component Topcnt
	port (
	 clk 			: In 	std_logic;
         clr 			: In 	std_logic;
         ce 			: In 	std_logic;
         ceS			: In  	std_logic;
	 rst			: In	std_logic;
	 w_ed			: In	std_logic;


         dinH 			: In 	std_logic_vector (15 DownTo 0);
         dinV 			: In 	std_logic;
         HV_slct 		: In 	std_logic;
         psout 			: InOut std_logic;
         doutH 			: Out 	std_logic;
         doutV 			: Out 	std_logic;

 	 t_190			: Out	std_logic;
	 t_176			: Out	std_logic;
         t_082 			: Out	std_logic;
         t_001 			: Out	std_logic;

	 ad_outH 		: Out 	std_logic_vector (15 DownTo 0);
	 ad_outVR 		: Out 	std_logic_vector (15 DownTo 0);
         ad_outVW 		: Out 	std_logic_vector (14 DownTo 0)
        );
    	end component;


    	component dp_ram0
    	port(
         clkW 			: In  	std_logic;
         clkR 			: In  	std_logic;
         din 			: In  	std_logic;
         w_adrs 		: In  	std_logic_vector(15 DownTo 0);
         r_adrs 		: In  	std_logic_vector(15 DownTo 0);
         we 			: In  	std_logic;
         dout 			: Out 	std_logic
        );
    	end component;

    	component dp_ram1
    	port(
         clkW 			: In  	std_logic;
         clkR 			: In  	std_logic;
         din 			: In  	std_logic;
         w_adrs 		: In  	std_logic_vector(15 DownTo 0);
         r_adrs 		: In  	std_logic_vector(15 DownTo 0);
         we 			: In  	std_logic;
         dout 			: Out 	std_logic
        );
    	end component;


    	component tmp_ram
    	port(
         clkW 			: In  	std_logic;
         clkR 			: In  	std_logic;
         din 			: In  	std_logic;
         w_adrs 		: In  	std_logic_vector(15 DownTo 0);
         r_adrs 		: In  	std_logic_vector(15 DownTo 0);
         we 			: In  	std_logic;
         dout 			: Out 	std_logic
        );
    	end component;
 
    	component pt_ram0
    	port(
         clkW 			: In  	std_logic;
         clkR 			: In  	std_logic;
         din 			: In  	std_logic;
         w_adrs 		: In  	std_logic_vector(14 DownTo 0);
         r_adrs 		: In  	std_logic_vector(14 DownTo 0);
         we 			: In  	std_logic;
         dout 			: Out 	std_logic
        );
    	end component;

    	component pt_ram1
    	port(
         clkW 			: In  	std_logic;
         clkR 			: In  	std_logic;
         din 			: In  	std_logic;
         w_adrs 		: In  	std_logic_vector(14 DownTo 0);
         r_adrs 		: In  	std_logic_vector(14 DownTo 0);
         we 			: In  	std_logic;
         dout 			: Out 	std_logic
        );
    	end component;
	
 	component ip_ram
        port (
        clkW 			: In	std_logic;
        we 			: In	std_logic;
        din 			: In	std_logic_vector (15 DownTo 0);
        w_adrs 			: In	std_logic_vector (03 DownTo 0);
        r_adrs 			: In	std_logic_vector (03 DownTo 0);

        dout 			: Out	std_logic_vector (15 DownTo 0)
				);
	end component;
 
	component cb4ceW
	port (
        clk 			: In  	std_logic;
        ce 			: In  	std_logic;
        clr 			: In  	std_logic;

	w_ed			: Out	std_logic;
        Qn 			: Out 	std_logic_vector (03 DownTo 0)
	);
	end component;
	
	component cb4ceR
	port (
        clk 			: In  	std_logic;
        ce 			: In  	std_logic;
        clr 			: In  	std_logic;

        Qn 			: Out 	std_logic_vector (03 DownTo 0)
	);
	end component;

    
signal 	clkW_hi		: 		std_logic := '0';
  

signal	dinH 		: 		std_logic_vector (15 DownTo 0);
signal 	dinV 		: 		std_logic := '0';
signal 	psout 		: 		std_logic := '0';
signal 	doutH_dt	: 		std_logic := '0';
signal 	doutV_pt	: 		std_logic := '0';

signal 	ad_outH_dt	: 		std_logic_vector (15 DownTo 0) :=x"0000";
signal 	ad_outVR_dt	: 		std_logic_vector (15 DownTo 0) :=x"0000";
signal 	ad_outVW_pt	: 		std_logic_vector (14 DownTo 0) :=b"000000000000000";


signal 	dout0		: 		std_logic := '0';
signal 	dout1		: 		std_logic := '0';

signal 	pout0		: 		std_logic := '0';
signal 	pout1		: 		std_logic := '0';

signal 	ce		: 		std_logic := '0';

signal 	restart		: 		std_logic := '0';
signal 	clr_rst		: 		std_logic := '0';
signal 	rom_rce		: 		std_logic := '0';

signal 	tout_001 	: 		std_logic := '0';
signal 	tout_190 	: 		std_logic := '0';
signal 	tout_082 	: 		std_logic := '0';
signal 	tout_176 	: 		std_logic := '0';
signal 	tout_272 	: 		std_logic := '0';

signal 	we_dram0 	: 		std_logic := '0';
signal 	we_dram1 	: 		std_logic := '0';

signal 	we_pram0 	: 		std_logic := '0';
signal 	we_pram1 	: 		std_logic := '0';

signal 	HV_slct		: 		std_logic := '0';

signal	w_ok		: 		std_logic := '0';
--signal 	we_i	: 		std_logic := '0';
signal 	addrW10		: 		std_logic_vector (03 DownTo 0) :=b"0000";
signal 	addrR10		: 		std_logic_vector (03 DownTo 0) :=b"0000";


-- writing data action check-----temp IC --------------
signal 	fn_flag 	: 		std_logic := '0';
-------------------------------------------------------

begin
			clkW_hi	<=	clkW_h;										--clock for write data
			restart	<=	rst;



-------------- for debug   romFF  -----------------------
			addr10ROM <=	addrW10;

---------------------------------------------------------
--			dt_out 	<=	(dout0 and (not (bank_sg)))			-- DARC   data output from ram
--						or	(dout1 and 		(bank_sg));
--							
--			pt_out 	<=	(pout0 and (not (bank_sg)))			-- Parity data output from ram
--						or	(pout1 and 		(bank_sg));

--------------- debug mode-------------------------------
			dt_out 	<=	(dout1 and (not (bank_sg)))			-- DARC   data output from ram
						or	(dout0 and 		 (bank_sg));
							
			pt_out 	<=	(pout1 and (not (bank_sg)))			-- Parity data output from ram
						or	(pout0 and 		 (bank_sg));
-------------------------------------------------------


			clr_rst	<= 	(clr 	 and tout_176);
			rom_rce	<= 	(psout and tout_176);
			tout_272<=	((tout_190 or tout_082) and (not(HV_slct)));

			we_dram0<= 	tout_272 and (bank_sg);
			we_dram1<= 	tout_272 and (not (bank_sg));

			we_pram0<= 	tout_082 and (bank_sg);
			we_pram1<= 	tout_082 and (not (bank_sg));


-- writing data action check-----temp IC --------------
			f_fg		<= fn_flag;

ckwtact:	process (clkW_hi,clr)
			begin
			if (clr='0') then
				fn_flag<='0';

			elsif	(clkW_hi' event and clkW_hi = '1') then
				case ad_outVW_pt is
--					when     b"000000000000000"=>
--						fn_flag<='0';
					when 		b"101011100011111"=>
						fn_flag<='1';
					when others => 
						fn_flag <= fn_flag;
				end case;
			end if;
			end process;
-------------------------------------------------------




--start timing create CE control
stce : process(clkW_hi,clr)
			begin
				if (clr='0') then
					ce		<= '0';
				elsif	(clkW_hi' event and clkW_hi = '1') then
					if (psout='1') then 
						ce <= ceS;
					end if;
				end if;
			end process;




-- 1 frame write control counter
hnofpac:	process (clkW_hi,clr)
         variable    i : integer range 0 to 461; --(H:190 + V:272)
			begin
				if (clr='0') then
					HV_slct<='0';
					i:=0;
            elsif (clkW_hi'event and clkW_hi = '0') then
					if (tout_001='0') then
						case i is
							when 189=> 						-- when 189-- Horizontal number of packet counter
								HV_slct<='1';
							when 461=> 						-- when 461-- Number of Vertical parity counter
								HV_slct<='0';
							when others => 
								HV_slct<=HV_slct;
						end case;

						if (i < 461) then
							i:= i+1;							--counter. take these 
						else									--lines out to increase performance.
							i:=0;
						end if;
					end if;
				end if;
			end process;




	U10 : Topcnt
        port map (
					clk 		=> clkW_hi,
					clr 		=> clr,
					ce 		=> ce,
					ceS 		=> ceS,
					w_ed		=> w_ok,
					rst		=> restart,
					dinH 		=> dinH,
					dinV 		=> dinV,
					HV_slct 	=> HV_slct,
					psout 		=> psout,
					doutH 		=> doutH_dt,
					doutV 		=> doutV_pt,

					t_190 		=> tout_190,
					t_082 		=> tout_082,
					t_176 		=> tout_176,
					t_001 		=> tout_001,

					
					ad_outH 	=> ad_outH_dt,
					ad_outVR 	=> ad_outVR_dt,
					ad_outVW 	=> ad_outVW_pt
        );


	U20: dp_ram0										--Data RAM for DARC
			port map (
					clkW 		=> clkW_hi,				--Write clock High speed 
					clkR 		=> clkR_16,				--Read  clock DARC 16kHz bps
					din 		=> doutH_dt,
					w_adrs 		=> ad_outH_dt,
					r_adrs 		=> ad_r_dt,
					we 		=> we_dram0,
					dout 		=> dout0
        );

	U21: dp_ram1										--Data RAM for DARC
			port map (
					clkW 		=> clkW_hi,				--Write clock High speed 
					clkR 		=> clkR_16,				--Read  clock DARC 16kHz bps
					din 		=> doutH_dt,
					w_adrs 		=> ad_outH_dt,
					r_adrs 		=> ad_r_dt,
					we 		=> we_dram1,
					dout 		=> dout1
        );

	U23: tmp_ram										--temporary RAM for Vatical parity
			port map (
					clkW 		=> clkW_hi,				--Write clock High speed 
					clkR 		=> clkW_hi,				--Read  clock DARC 16kHz bps
					din 		=> doutH_dt,
					w_adrs 		=> ad_outH_dt,
					r_adrs 		=> ad_outVR_dt,
					we 		=> tout_272,
					dout 		=> dinV
        );

	U24: pt_ram0										--parity RAM for DARC
			port map (
					clkW 		=> clkW_hi,				--Write clock High speed 
					clkR 		=> clkR_16,				--Read  clock DARC 16kHz bps
					din 		=> doutV_pt,
					w_adrs 		=> ad_outVW_pt,
					r_adrs 		=> ad_r_pt,
					we 		=> we_pram0,
					dout 		=> pout0
        );

	U25: pt_ram1										--parity RAM for DARC
			port map (
					clkW 		=> clkW_hi,				--Write clock High speed 
					clkR 		=> clkR_16,				--Read  clock DARC 16kHz bps
					din 		=> doutV_pt,
					w_adrs 		=> ad_outVW_pt,
					r_adrs 		=> ad_r_pt,
					we 		=> we_pram1,
					dout 		=> pout1
        );


	-- Instantiate the Unit Under Test (UUT)
	U30 : ip_ram
		port map (
					clkW 		=> clkW_hi,
					din 		=> ly3_dt,
					w_adrs 		=> addrW10,
					r_adrs 		=> addrR10,
					we 		=> we_i,
					dout 		=> dinH
			);


	U40: cb4ceW
		port map (
					clk 		=> clkW_hi,
					ce 		=> ceS,
					clr 		=> clr,
					w_ed		=> w_ok,
					Qn 		=> addrW10
			);

   U50: cb4ceR 
		port map (
					clk 		=> clkW_hi,
					ce 		=> rom_rce,
					clr 		=> clr_rst,
					Qn 		=> addrR10
        );
end Behavioral;

