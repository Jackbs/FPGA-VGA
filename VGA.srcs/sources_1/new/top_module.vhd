----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/08/2016 02:32:35 PM
-- Design Name: 
-- Module Name: top_module - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module is
    Port ( mclk : in STD_LOGIC;
           reset : in STD_LOGIC;
           NSGO : in STD_LOGIC;
           EWGO : in STD_LOGIC;
           NSwaiting : out STD_LOGIC;
           EWwaiting : out STD_LOGIC;
           hs : out STD_LOGIC;
           vs : out STD_LOGIC;
           red : out std_logic_vector(2 downto 0);
           green : out std_logic_vector(2 downto 0);
           blue : out std_logic_vector(1 downto 0));
           
end top_module;

architecture Behavioral of top_module is

Constant HMAX: std_logic_vector(9 downto 0) := "1100100000";--"800" --Maximum value for horizontal pixel counter
Constant VMAX: std_logic_vector(9 downto 0) := "1000001100";--"524" --Maximum value for vertical pixel counter
Constant HLINES: std_logic_vector(9 downto 0) := "1100100000";--"800" --Total number of visible columns
Constant VLINES: std_logic_vector(9 downto 0) := "1000001100";--"524" --Total number of visible rows

Constant HFP: std_logic_vector(9 downto 0) := "0000010000"; --"16" --Horizontal front porch end
Constant HSB: std_logic_vector(9 downto 0) := "0001110000";--"112" --Horizontal sync pulse end
Constant HBP: std_logic_vector(9 downto 0) := "0010100000";--"160" --Horizontal back porch end (active video begins)

Constant VFP: std_logic_vector(9 downto 0) := "0000001011";--"11" --Vertical front porch end
Constant VSB: std_logic_vector(9 downto 0) := "0000001101";--"13" --Vertical sync pulse end
Constant VBP: std_logic_vector(9 downto 0) := "0000101100";--"44" --Vertical back porch end (active video begins)

signal Hscancounter : std_logic_vector(9 downto 0) := (others => '0');
signal Vscancounter : std_logic_vector(9 downto 0) := (others => '0');

signal red_inInt : std_logic_vector(2 downto 0);
signal green_inInt : std_logic_vector(2 downto 0);
signal blue_inInt : std_logic_vector(1 downto 0);

signal red_inLight : std_logic_vector(2 downto 0);
signal green_inLight : std_logic_vector(2 downto 0);
signal blue_inLight : std_logic_vector(1 downto 0);

signal red_inNScar : std_logic_vector(2 downto 0);
signal green_inNScar : std_logic_vector(2 downto 0);
signal blue_inNScar : std_logic_vector(1 downto 0);

signal red_inEWcar : std_logic_vector(2 downto 0);
signal green_inEWcar : std_logic_vector(2 downto 0);
signal blue_inEWcar : std_logic_vector(1 downto 0);

signal ThisNSLight : std_logic_vector(2 downto 0);
signal ThisEWLight : std_logic_vector(2 downto 0);

signal NSwait_int : STD_LOGIC  := '0';
signal EWwait_int : STD_LOGIC  := '0';

signal Hend : STD_LOGIC  := '0';
signal Vend : STD_LOGIC  := '0';

signal clock1 : STD_LOGIC  := '0';
signal PixelClk : STD_LOGIC  := '0';

signal hs_in : STD_LOGIC := '0';
signal vs_in : STD_LOGIC := '0';

signal ThisNorth : integer := 230;
signal ThisEast  : integer := 500;
signal ThisSouth : integer := 290;
signal ThisWest  : integer := 440;

signal NSDIRECTION : STD_LOGIC := '1';
signal EWDIRECTION : STD_LOGIC := '0';

--signal NSGO : STD_LOGIC := '1';
--signal EWGO : STD_LOGIC := '1';

component Intersection is
    Port (	Colour : out  STD_LOGIC_VECTOR (7 downto 0);
			vert_scan : in  STD_LOGIC_VECTOR (9 downto 0);
			horz_scan : in  STD_LOGIC_VECTOR (9 downto 0);
			North_Intersection : out integer;
			East_Intersection : out integer;
			South_Intersection : out integer;
			West_Intersection : out integer);
end component;

component Moving_Block is
    Port (	Colour : out  STD_LOGIC_VECTOR (7 downto 0);
			vert_scan : in  STD_LOGIC_VECTOR (9 downto 0);
			horz_scan : in  STD_LOGIC_VECTOR (9 downto 0);
			refresh_counter : in STD_LOGIC;
			direction : in STD_LOGIC;
			At_lights : out  STD_LOGIC;
			GO : in STD_LOGIC;
			North : in integer;
			East  : in integer;
			South : in integer;
			West  : in integer);
end component;

component Draw_Lights is
    Port (	North : in integer;
			South : in integer;
			East : in integer;
			West : in integer;
			vert_scan : in  STD_LOGIC_VECTOR (9 downto 0);
			horz_scan : in  STD_LOGIC_VECTOR (9 downto 0);
			NS_Lights : in  STD_LOGIC_VECTOR (2 downto 0);
			EW_Lights : in  STD_LOGIC_VECTOR (2 downto 0);
			Colour : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

component Light_Controller is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           senseNS : in STD_LOGIC;
           senseEW : in STD_LOGIC;
           outputNS : out STD_LOGIC_VECTOR(2 downto 0);
           outputEW : out STD_LOGIC_VECTOR(2 downto 0));
end component;

begin

lightcontroller: Light_Controller PORT MAP(
    clk => mclk,
    reset => reset,
    senseNS => NSwait_int,
    senseEW => EWwait_int,
    outputNS => ThisNSLight,
    outputEW => ThisEWLight
);


intersection1: Intersection PORT MAP(
    horz_scan => Hscancounter,
    vert_scan => Vscancounter,
    Colour(7 downto 5) => red_inInt,
    Colour(4 downto 2) => green_inInt,
    Colour(1 downto 0) => blue_inInt,
    North_Intersection => ThisNorth,
    East_Intersection => ThisEast,
    South_Intersection => ThisSouth,
    West_Intersection => ThisWest
);

NSCAR: Moving_Block PORT MAP(
    horz_scan => Hscancounter,
    vert_scan => Vscancounter,
    refresh_counter => Vend,
    direction => NSDIRECTION,
    GO => NSGO,
    At_lights => NSwait_int,
    Colour(7 downto 5) => red_inNScar,
    Colour(4 downto 2) => green_inNScar,
    Colour(1 downto 0) => blue_inNScar,
    North => ThisNorth,
    East => ThisEast,
    South => ThisSouth,
    West => ThisWest
);

EWCAR: Moving_Block PORT MAP(
    horz_scan => Hscancounter,
    vert_scan => Vscancounter,
    refresh_counter => Vend,
    direction => EWDIRECTION,
    GO => EWGO,
    At_lights => EWwait_int,
    Colour(7 downto 5) => red_inEWcar,
    Colour(4 downto 2) => green_inEWcar,
    Colour(1 downto 0) => blue_inEWcar,
    North => ThisNorth,
    East => ThisEast,
    South => ThisSouth,
    West => ThisWest
);

LIGHTS: Draw_Lights PORT MAP(
    North => ThisNorth,
    East => ThisEast,
    South => ThisSouth,
    West => ThisWest,
    vert_scan => Vscancounter,
    horz_scan => Hscancounter,    
    NS_Lights => ThisNSLight,
    EW_Lights => ThisEWLight,
    Colour(7 downto 5) => red_inLight,
    Colour(4 downto 2) => green_inLight,
    Colour(1 downto 0) => blue_inLight  
);



process (mclk)

begin
    if mclk='1' and mclk'event then
        if clock1='1' then   
            clock1 <= '0';           
        else
            clock1 <= '1';
            if PixelClk='1' then
                PixelClk <= '0';
            else
                PixelClk <= '1';
            end if; 
        end if;    
    end if;
end process;
    
process (PixelClk)
begin
    if PixelClk='1' and PixelClk'event then
        Hscancounter <= Hscancounter + "0000000001";
        
        if Hscancounter > HFP and Hscancounter < HSB then
            hs_in <= '1';
        else
            hs_in <= '0';
        end if;
        
        if Hscancounter = HMAX then
            Hscancounter <= "0000000000";
        end if;
    end if;
end process;    
    
process (Hend)
begin
    if Hend='1' and Hend'event then
        
        Vscancounter <= Vscancounter + "0000000001";
            
        if Vscancounter > VFP and Vscancounter < VSB  then
            vs_in <= '1';
        else
            vs_in <= '0';
        end if;
                    
        if Vscancounter = VMAX then
            Vscancounter <= "0000000000";
        end if;
    end if;
end process;

Hend <= '1' when Hscancounter = HMAX else '0';
Vend <= '1' when Vscancounter = VMAX else '0';

NSwaiting <= NSwait_int;
EWwaiting <= EWwait_int;

    hs <= hs_in;
    vs <= vs_in;
    red <= red_inEWcar or (red_inNScar or red_inLight);
    green <= green_inEWcar or (green_inNScar or green_inLight);
    blue <= blue_inEWcar or (blue_inNScar or blue_inLight);
    
end Behavioral;
