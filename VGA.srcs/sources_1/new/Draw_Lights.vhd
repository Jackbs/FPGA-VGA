----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:43:14 11/02/2010 
-- Design Name: 
-- Module Name:    Draw_Lights - Behavioral 
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Draw_Lights is
    Port (	North : in integer;
			South : in integer;
			East : in integer;
			West : in integer;
			vert_scan : in  STD_LOGIC_VECTOR (9 downto 0);
			horz_scan : in  STD_LOGIC_VECTOR (9 downto 0);
			NS_Lights : in  STD_LOGIC_VECTOR (2 downto 0);
			EW_Lights : in  STD_LOGIC_VECTOR (2 downto 0);
			Colour : out  STD_LOGIC_VECTOR (7 downto 0));
end Draw_Lights;

architecture Behavioral of Draw_Lights is

begin

Colour <=	"00011100" when NS_Lights ="001" and vert_scan < North and horz_scan < West-10 and vert_scan >North-15  and horz_scan >West-15 else		--West Green 
			"00011100"	when NS_Lights ="001" and vert_scan > South and horz_scan > East+10 and vert_scan <South+15 and horz_scan <East+15 else		--East Green
			"11110100" when NS_Lights ="010" and vert_scan < North and horz_scan < West-5 and vert_scan >North-15  and horz_scan >West-10 else		--West Orange
			"11110100"	when NS_Lights ="010" and vert_scan > South and horz_scan > East+5 and vert_scan <South+15 and horz_scan <East+10 else		--East Orange
			"11100000" when NS_Lights ="100" and vert_scan < North and horz_scan < West and vert_scan >North-15  and horz_scan >West-5 else			--West Red
			"11100000"	when NS_Lights ="100" and vert_scan > South and horz_scan > East and vert_scan <South+15 and horz_scan <East+5 else			--East Red
			"00011100"	when EW_Lights ="001" and vert_scan < North-10 and horz_scan > East and vert_scan >North-15  and horz_scan <East+15 else	--North Green
			"00011100"	when EW_Lights ="001" and vert_scan > South+10 and horz_scan < West and vert_scan <South +15 and horz_scan >West-15 else	--South Green
			"11110100"	when EW_Lights ="010" and vert_scan < North-5 and horz_scan > East and vert_scan >North-10  and horz_scan <East+15 else		--North Orange
			"11110100"	when EW_Lights ="010" and vert_scan > South+5 and horz_scan < West and vert_scan <South +10 and horz_scan >West-15 else		--South Orange
			"11100000"	when EW_Lights ="100" and vert_scan < North and horz_scan > East and vert_scan >North-5  and horz_scan <East+15 else		--North Red
			"11100000"	when EW_Lights ="100" and vert_scan > South and horz_scan < West and vert_scan <South+5 and horz_scan >West-15 else			--South Red
			"00000000";
end Behavioral;