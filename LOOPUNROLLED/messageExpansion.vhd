library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sha_512_pkg.all;

entity mess_expan_topLevel is
    port (
        clk           : in std_logic;
	inSig 	      : in std_logic;
	counter	      : in integer;
        rst           : in std_logic;
        message_input : in std_logic_vector(16*WORD_SIZE-1 downto 0);
        word_out      : out std_logic_vector(WORD_SIZE-1 downto 0)
    );
end mess_expan_topLevel;

architecture structural of mess_expan_topLevel is
    signal curr_Word   : std_logic_vector(WORD_SIZE-1 downto 0);
   
   
signal count : integer :=0;
    

   
    
    signal lfsr_next   : std_logic_vector(16*WORD_SIZE-1 downto 0);
 -- signal mf : std_logic_vector(WORD_SIZE-1 DOWNTO 0);

    component sha512_lfsr 
        port (
            clk      : in std_logic;
            rst      : in std_logic;
	    count    :in integer;
            message  : in std_logic_vector(WORD_SIZE-1 downto 0);
            lfsr_out : out std_logic_vector(WORD_SIZE*16-1 downto 0)
        );
    end component;


begin

    SCHEDULING_PROCESS : process(counter,rst,inSig)
	 
    begin
        if rst = '1' then
          --  new_message <= '0';
		

        else 
	if(counter >=0) then
	if(falling_edge(inSig)) then
	count<=count+1;
	end if;
	if(rising_edge(inSig)) then
	count<=count+1;
	end if;
            if count < 16 then

                curr_Word <= message_input(WORD_SIZE*(16-(count))-1 downto WORD_SIZE*(15-(count)));
	
            	
	   


else
                
		--if(falling_edge(clk)) then
		
	
                curr_Word <= std_logic_vector(
                    unsigned(SIGMA_LCASE_1(lfsr_next(WORD_SIZE*2-1 downto WORD_SIZE*1))) +
                    unsigned(lfsr_next(WORD_SIZE*7-1 downto WORD_SIZE*6)) +
                    unsigned(SIGMA_LCASE_0(lfsr_next(WORD_SIZE*15-1 downto WORD_SIZE*14))) +
                    unsigned(lfsr_next(WORD_SIZE*16-1 downto WORD_SIZE*15))
                );
	--end if;
            end if;
	
         end if;
	
        end if;
	
    end process;
 word_out <= curr_Word;

    LFSR : sha512_lfsr 
        port map (
            clk      => clk,
            rst      => rst,
            message  => curr_Word,
            lfsr_out => lfsr_next,
	    count=>count
        );

end architecture;

