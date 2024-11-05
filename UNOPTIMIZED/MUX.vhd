
LIBRARY IEEE;
use ieee.std_logic_1164.all;
use work.sha_512_pkg.all;
entity mux_2_1 is
port(sel : in 
std_logic;msg,feed : in std_logic_vector(WORD_SIZE-1  downto 0);
output : out std_logic_vector(WORD_SIZE-1 downto 0));
end mux_2_1;
architecture form of mux_2_1 is
begin
   
    with sel select
        output <= msg   when '0' ,feed  when '1',
        (others => 'U') when others; -- Default case

end form;