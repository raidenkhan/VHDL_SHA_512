library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sha_512_pkg.all;
entity tb_SHA_512_MACHINE is
-- No ports for a testbench
end entity;

architecture behavior of tb_SHA_512_MACHINE is

    -- Component declaration for the unit under test (UUT)
    component SHA_512_MACHINE
        port(
            clk            : in std_logic;
            N              : in integer;
            reset          : in std_logic;
            message_input  : in std_logic_vector(16*WORD_SIZE-1 downto 0);
	   output_fin : out std_logic_vector(8*WORD_SIZE-1 DOWNTO 0)
        );
    end component;

    -- Testbench signals
    signal clk_tb           : std_logic := '0';
    signal reset_tb         : std_logic := '0';
SIGNAL OUTP : STD_LOGIC_VECTOR(8*WORD_SIZE-1 DOWNTO 0);
    signal N_tb             : integer := 1;  -- Number of blocks (this could be adjusted as needed)
    signal message_input_tb : std_logic_vector(16*WORD_SIZE-1 downto 0);

    -- Constants for the test
    constant clk_period : time := 10 ns;

    

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: SHA_512_MACHINE
        port map(
            clk            => clk_tb,
            N              => N_tb,
            reset          => reset_tb,
            message_input  => message_input_tb,
	   output_fin=>OUTP
        );

    -- Clock generation
    clk_process : process
    begin
        clk_tb <= '0';
        wait for clk_period / 2;
        clk_tb <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process to apply inputs
    stim_proc: process
    begin
        -- Initialize signals
        reset_tb <= '1';
        wait for 20 ns;
        reset_tb <= '0';

        -- Apply the padded 'abc' message as input (padded to 1024 bits)
        -- Convert 'abc' (ASCII) and pad with 0s to fit 1024-bit length
         message_input_tb <= X"6162638000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018";


        -- Wait for a few clock cycles
        --wait for 50 us;

        -- Stop simulation
        wait;
    end process;

end architecture;


