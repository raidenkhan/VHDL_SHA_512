library ieee;
use ieee.std_logic_1164.all;
use work.sha_512_pkg.all;
entity SHA_512_MACHINE is
port(
	clk : in std_logic;
	N : in integer;
	reset : in std_logic;
	message_input : in std_logic_vector(16*WORD_SIZE-1 downto 0);
	output_fin : out std_logic_vector(8*WORD_SIZE-1 DOWNTO 0)
	
);
	
end entity;


architecture working of SHA_512_MACHINE is
signal counter : integer := 0;
--signal for Wt constant;
signal Wt : std_logic_vector(WORD_SIZE -1 DOWNTO 0);
signal init : std_logic;
signal Output : std_logic_vector(8*WORD_SIZE-1 downto 0);
signal eval_sig : std_logic;
signal Ktsig : std_logic_vector(WORD_SIZE-1 DOWNTO 0);
signal tranSig : std_logic;
signal internCount : integer :=0;
--DEFINE THE MESSAGE SCHDULAR COMPONENT
component messageCompression is
 port(
        clk          : in std_logic;  -- Clock signal
        reset        : in std_logic;  -- Reset signal to initialize the state
        Wt, Kt       : in std_logic_vector(WORD_SIZE-1 downto 0);    -- Input message word and round constant
        initial      : in std_logic;
	counter : in integer;
	eval : in std_logic;
	finalHash : out std_logic_vector(8*WORD_SIZE-1 DOWNTO 0);
	reqSiq : out std_logic
    );
end component;

--DEFINE THE MESSAGE COMPRESSION COMPONENT
component mess_expan_topLevel is 
port(
  	clk : in std_logic;
        rst           : in std_logic;
	inSig 	      : in std_logic;
	counter : in integer;
        message_input : in std_logic_vector(16*WORD_SIZE-1 downto 0);
        word_out      : out std_logic_vector(WORD_SIZE-1 downto 0)

);
end component;

--DEFINE THE CONTROLLER COMPONENT
component messageController is 
port(
clk,rst : in std_logic;
N : in integer;
inputHash : in std_logic_vector(8*WORD_SIZE-1  downto 0);
count : out integer;
eval : out std_logic;
initial : out std_logic
);
end component;
 CONSTANT K : K_DATA := (
        --address 0
        X"428a2f98d728ae22", X"7137449123ef65cd", X"b5c0fbcfec4d3b2f", X"e9b5dba58189dbbc",
        X"3956c25bf348b538", X"59f111f1b605d019", X"923f82a4af194f9b", X"ab1c5ed5da6d8118",
        X"d807aa98a3030242", X"12835b0145706fbe", X"243185be4ee4b28c", X"550c7dc3d5ffb4e2",
        X"72be5d74f27b896f", X"80deb1fe3b1696b1", X"9bdc06a725c71235", X"c19bf174cf692694",
        X"e49b69c19ef14ad2", X"efbe4786384f25e3", X"0fc19dc68b8cd5b5", X"240ca1cc77ac9c65",
        X"2de92c6f592b0275", X"4a7484aa6ea6e483", X"5cb0a9dcbd41fbd4", X"76f988da831153b5",
        X"983e5152ee66dfab", X"a831c66d2db43210", X"b00327c898fb213f", X"bf597fc7beef0ee4",
        X"c6e00bf33da88fc2", X"d5a79147930aa725", X"06ca6351e003826f", X"142929670a0e6e70",
        X"27b70a8546d22ffc", X"2e1b21385c26c926", X"4d2c6dfc5ac42aed", X"53380d139d95b3df",
        X"650a73548baf63de", X"766a0abb3c77b2a8", X"81c2c92e47edaee6", X"92722c851482353b",
        X"a2bfe8a14cf10364", X"a81a664bbc423001", X"c24b8b70d0f89791", X"c76c51a30654be30",
        X"d192e819d6ef5218", X"d69906245565a910", X"f40e35855771202a", X"106aa07032bbd1b8",
        X"19a4c116b8d2d0c8", X"1e376c085141ab53", X"2748774cdf8eeb99", X"34b0bcb5e19b48a8",
        X"391c0cb3c5c95a63", X"4ed8aa4ae3418acb", X"5b9cca4f7763e373", X"682e6ff3d6b2b8a3",
        X"748f82ee5defb2fc", X"78a5636f43172f60", X"84c87814a1f0ab72", X"8cc702081a6439ec",
        X"90befffa23631e28", X"a4506cebde82bde9", X"bef9a3f7b2c67915", X"c67178f2e372532b",
        X"ca273eceea26619c", X"d186b8c721c0c207", X"eada7dd6cde0eb1e", X"f57d4f7fee6ed178",
        X"06f067aa72176fba", X"0a637dc5a2c898a6", X"113f9804bef90dae", X"1b710b35131c471b",
        X"28db77f523047d84", X"32caab7b40c72493", X"3c9ebe0a15c9bebc", X"431d67c49c100d4c",
        X"4cc5d4becb3e42b6", X"597f299cfc657e2a", X"5fcb6fab3ad6faec", X"6c44198c4a475817"
    );


begin

process(counter,tranSig)
begin
if internCount >= 0 and internCount < 80 then
    KtSig <= K(internCount);
else
    KtSig <= (others => '0');  -- Or handle the error appropriately
end if;
end process;

process(tranSig)
begin
if(counter >=0) then
	if(falling_edge(tranSig)) then
	internCount<=internCount+1;
	end if;
	if(rising_edge(tranSig)) then
	internCount<=internCount+1;
end if;
end if;
end process;
--CREATE COMPONENT CONNECTIONS
EXPAND : mess_expan_topLevel port map(
	clk=>clk,
	rst=>reset,
	counter=>counter,
	message_input=>message_input,
	word_out =>Wt,
	inSig=>tranSig

	);
COMPRESS : messageCompression port map(
	clk=>clk,
	reset=>reset,
	initial=>init,
	Wt=>Wt,
	Kt=>KtSig,
	counter=>counter,
	finalHash=>Output,
	eval=>eval_sig,
	reqSiq=>tranSig
	
);
CONTROLLER : messageController port map(
clk=>clk,
rst=>reset,
count=>counter,
N=>N,
inputHash=>Output,
eval=>eval_sig,

initial=>init

);
output_fin<=Output;
end architecture;