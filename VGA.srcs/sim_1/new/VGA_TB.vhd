----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/15/2016 01:59:51 PM
-- Design Name: 
-- Module Name: VGA_TB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_TB is

   
           
end VGA_TB;

architecture Behavioral of VGA_TB is

Component top_module
port(
    mclk : in STD_LOGIC;
    reset : in STD_LOGIC;
    hs : out STD_LOGIC;
    vs : out STD_LOGIC;
    red : out std_logic_vector(2 downto 0);
    green : out std_logic_vector(2 downto 0);
    blue : out std_logic_vector(1 downto 0);
    NSGO : in STD_LOGIC;
    EWGO : in STD_LOGIC);
end Component;

signal thismclk : STD_LOGIC := '0';
signal thisreset : STD_LOGIC := '0';
signal thisred : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal thisgreen : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal thisblue : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal thishs : STD_LOGIC := '0';
signal thisvs : STD_LOGIC := '0';
signal thisNSGO : STD_LOGIC := '1';
signal thisEWGO : STD_LOGIC := '1';

constant clk_period : time := 10 ns;

begin

thismclk <= not thismclk after clk_period;

utt: top_module PORT MAP(
    mclk => thismclk,
    reset => thisreset,
    red => thisred,
    green => thisgreen,
    blue => thisblue,
    hs => thishs,
    vs => thisvs,
    NSGO => thisNSGO,
    EWGO => thisEWGO
);



end Behavioral;
