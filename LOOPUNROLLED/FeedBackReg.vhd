LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
use work.sha_512_pkg.all;

ENTITY sha512_lfsr IS
    PORT(
        clk      : IN  std_logic;
        rst      : IN  std_logic;
        count     : in integer;
        message  : IN  std_logic_vector(WORD_SIZE-1 DOWNTO 0);
        lfsr_out : OUT std_logic_vector(WORD_SIZE*16-1 downto 0)
    );
END sha512_lfsr;

ARCHITECTURE behavior OF sha512_lfsr IS
    SIGNAL lfsr_reg  : std_logic_vector(WORD_SIZE*16-1 DOWNTO 0);
    
BEGIN
   

    PROCESS(rst,count)
    BEGIN
        IF rst = '1' THEN
            lfsr_reg <= (others => '1');  -- Initial seed value
      
        else
	if(message(7 downto 0) /= "UUUUUUUU") then
	--report "hello";
	
	 lfsr_reg <= lfsr_reg(WORD_SIZE*15-1 DOWNTO 0) & message;
	
	end if;
	
        END IF;
    END PROCESS;

   lfsr_out <= lfsr_reg;
END behavior;

