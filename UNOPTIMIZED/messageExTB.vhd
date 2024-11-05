library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sha_512_pkg.all;  -- Assuming WORD_SIZE is defined here

entity mess_expan_topLevel_tb is
end mess_expan_topLevel_tb;

architecture behavior of mess_expan_topLevel_tb is
    -- Signals for the DUT (Device Under Test)
    signal clk           : std_logic := '0';
    signal rst           : std_logic := '0';
    signal message_input : std_logic_vector(16*WORD_SIZE-1 downto 0) := (others => '0');
    signal output        : std_logic_vector(WORD_SIZE-1 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;

    -- Component Declaration for the Unit Under Test (UUT)
    component mess_expan_topLevel
        port (
            clk           : in std_logic;
            rst           : in std_logic;
            message_input : in std_logic_vector(16*WORD_SIZE-1 downto 0);
            word_out        : out std_logic_vector(WORD_SIZE-1 downto 0)
        );
    end component;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut : mess_expan_topLevel
        port map (
            clk           => clk,
            rst           => rst,
            message_input => message_input,
            word_out        => output
        );

    -- Clock generation process
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stimulus_process : process
    begin
        -- Test case for 'abc' message (padded to 1024 bits)
        -- "abc" in ASCII: 0x616263 (padded to 1024 bits as per SHA-512 padding rules)
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        -- The 'abc' padded message in hexadecimal (1024-bit message):
        -- The message "abc" (in hexadecimal: 0x616263) is followed by padding: 
        -- "80" (1 bit '1' followed by zeros) and length of the message in bits at the end.
        message_input <= X"6162638000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018";

        -- Allow some time for processing the input
      --  wait for 1000 ns;

        -- End of simulation
        wait;
    end process;

end architecture;

