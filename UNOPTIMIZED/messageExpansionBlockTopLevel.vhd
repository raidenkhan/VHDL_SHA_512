library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sha_512_pkg.all;

entity mess_expan_topLevel is
    port (
        clk           : in std_logic;
	counter	      : in integer;
        rst           : in std_logic;
        message_input : in std_logic_vector(16*WORD_SIZE-1 downto 0);
        word_out      : out std_logic_vector(WORD_SIZE-1 downto 0)
    );
end mess_expan_topLevel;

architecture structural of mess_expan_topLevel is
    signal curr_Word   : std_logic_vector(WORD_SIZE-1 downto 0);
    signal test1 :  std_logic_vector(WORD_SIZE-1 downto 0);
   
   
signal count : integer;
    

    signal new_message : std_logic;
    --signal counter     : integer range 0 to 79 := 0;  -- SHA-512 uses 80 rounds
    signal mux_out     : std_logic_vector(WORD_SIZE-1 downto 0);
    signal lfsr_next   : std_logic_vector(16*WORD_SIZE-1 downto 0);
 -- signal mf : std_logic_vector(WORD_SIZE-1 DOWNTO 0);

    component mux_2_1 
        port (
            sel    : in std_logic;
            msg    : in std_logic_vector(WORD_SIZE-1 downto 0);
            feed   : in std_logic_vector(WORD_SIZE-1 downto 0);
            output : out std_logic_vector(WORD_SIZE-1 downto 0)
        );
    end component;

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
count<=counter;
    SCHEDULING_PROCESS : process(clk,counter, rst)
	 
    begin
        if rst = '1' then
            new_message <= '0';
		

        else 
	if(counter >=0) then
            if counter < 16 then

                curr_Word <= message_input(WORD_SIZE*(16-(counter))-1 downto WORD_SIZE*(15-(counter)));
	
            	
	   


else
                
		if(falling_edge(clk)) then
		new_message <= '1';
		--start<='1';
	
                curr_Word <= std_logic_vector(
                    unsigned(SIGMA_LCASE_1(lfsr_next(WORD_SIZE*2-1 downto WORD_SIZE*1))) +
                    unsigned(lfsr_next(WORD_SIZE*7-1 downto WORD_SIZE*6)) +
                    unsigned(SIGMA_LCASE_0(lfsr_next(WORD_SIZE*15-1 downto WORD_SIZE*14))) +
                    unsigned(lfsr_next(WORD_SIZE*16-1 downto WORD_SIZE*15))
                );
	end if;
            end if;
	
         end if;
	
        end if;
	
    end process;
 word_out <= curr_Word;

     -- Output the current word directly

    MULTIPLEXER : mux_2_1 
        port map (
            sel    => new_message,
            msg    => curr_Word,
            feed   => curr_Word,
            output => mux_out
        );

    LFSR : sha512_lfsr 
        port map (
            clk      => clk,
            rst      => rst,
            message  => mux_out,
            lfsr_out => lfsr_next,
	    count=>count
        );

end architecture;
