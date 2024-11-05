library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.ALL;
use work.sha_512_pkg.all;
entity messageController is
port(
clk,rst : in std_logic;
N : in integer;
--current_hash : in std_logic_vector(8*WORD_SIZE-1 downto 0);
--message_input : in std_logic_vector(16*WORD_SIZE-1 downto 0); 
inputHash : in std_logic_vector(8*WORD_SIZE-1  downto 0);
initial : out std_logic;
eval : out std_logic;
count : out integer

);

end messageController;

architecture behavior of messageController is


signal counter : integer ; --source for counter

signal hashOut : std_logic_vector(8*WORD_SIZE-1 DOWNTO 0);
 signal a, b, c, d, e, f, g, h: std_logic_vector(WORD_SIZE-1 downto 0);

signal nCount : integer:=0;
signal doneSig : std_logic :='0';
--DEFINE THE INITIAL_HASH_VALUESS
signal HV_INITIAL_VALUES : H_DATA := ( X"6a09e667f3bcc908", X"bb67ae8584caa73b",
                                       X"3c6ef372fe94f82b", X"a54ff53a5f1d36f1",
                                       X"510e527fade682d1", X"9b05688c2b3e6c1f",
                                       X"1f83d9abfb41bd6b", X"5be0cd19137e2179");
--DEFINE THE VARIOUS STATES
 type SHA_512_STATE is ( 

 START, 
 INITIALIZE,
 INTERMEDIATE,
 INTERMEDIATE_2,
 COMPUTE_HASH,
COMPUTE_HASH_2,
 OUTPUT,
 DONE );
    signal CURRENT_STATE, NEXT_STATE : SHA_512_STATE;
    
	

signal intermediateHash : std_logic_vector(8 * WORD_SIZE -1 downto 0);
begin
count<=counter;
CURRENT_STATE_LOGIC : process(clk,rst)
	begin
		if(rst='1') then
		CURRENT_STATE<=START;
		
		elsif(rising_edge(clk)) then
		CURRENT_STATE<=NEXT_STATE;
		end if;
end process;
NEXT_STATE_LOGIC : process(CURRENT_STATE,counter)
begin
	case CURRENT_STATE is

	WHEN START=>
	NEXT_STATE<=INITIALIZE;

	WHEN INITIALIZE=>
	if(nCount >=N) then
	NEXT_STATE<=DONE;
	else
	NEXT_STATE<=INTERMEDIATE;
	end if;
	WHEN INTERMEDIATE=>
	NEXT_STATE<=INTERMEDIATE_2;
	WHEN INTERMEDIATE_2=>
	if(nCount >=N) then
	NEXT_STATE<=OUTPUT;
	else
	NEXT_STATE<=COMPUTE_HASH;
	end if;
	WHEN COMPUTE_HASH=>
	
	if(counter >=40) then
	NEXT_STATE<=INTERMEDIATE;
	else
	NEXT_STATE<=COMPUTE_HASH_2;
	end if;
	WHEN COMPUTE_HASH_2=>
	NEXT_STATE<=COMPUTE_HASH;
	WHEN OUTPUT=>
	NEXT_STATE<=DONE;
	WHEN DONE=>
	NEXT_STATE<=DONE;
	
end case;
end process;

HASHING_LOGIC : process(CURRENT_STATE,clk)
begin
case CURRENT_STATE is

	WHEN START=>
	nCount<=0;
	WHEN INITIALIZE=>
	--report "Initialize state";
	counter<=-1;
			a<=HV_INITIAL_VALUES(0); 
			b<=HV_INITIAL_VALUES(1); 
			c<=HV_INITIAL_VALUES(2); 
			d<=HV_INITIAL_VALUES(3); 
			e<=HV_INITIAL_VALUES(4); 
			f<=HV_INITIAL_VALUES(5); 
			g<=HV_INITIAL_VALUES(6); 
			h<=HV_INITIAL_VALUES(7);	
	WHEN INTERMEDIATE=>
		if(nCount = 0) then
		initial<='1';
		end if;
	WHEN INTERMEDIATE_2=>
		if(rising_edge(clk)) then
		
		nCount<=nCount+1;
		end if;
		initial<='0';
		if((counter >= 40) and (doneSig='0')) then
		report "Doing sum";
		a<=std_logic_vector(unsigned(a)+unsigned(inputHash(8*WORD_SIZE-1 downto 7*WORD_SIZE)));
		b<=std_logic_vector(unsigned(b)+unsigned(inputHash(7*WORD_SIZE-1 downto 6*WORD_SIZE)));
		c<=std_logic_vector(unsigned(c)+unsigned(inputHash(6*WORD_SIZE-1 downto 5*WORD_SIZE)));
		d<=std_logic_vector(unsigned(d)+unsigned(inputHash(5*WORD_SIZE-1 downto 4*WORD_SIZE)));
		e<=std_logic_vector(unsigned(e)+unsigned(inputHash(4*WORD_SIZE-1 downto 3*WORD_SIZE)));
		f<=std_logic_vector(unsigned(f)+unsigned(inputHash(3*WORD_SIZE-1 downto 2*WORD_SIZE)));
		g<=std_logic_vector(unsigned(g)+unsigned(inputHash(2*WORD_SIZE-1 downto 1*WORD_SIZE)));
		h<=std_logic_vector(unsigned(h)+unsigned(inputHash(1*WORD_SIZE-1 downto 0)));
	
		end if;
		if((nCount>=N)) then 
		  doneSig<='1';
		end if;
	WHEN COMPUTE_HASH=>
	if(rising_edge(clk)) then
	
		counter<=counter+1;
		
	end if;
	
	eval<='0';
	
	
	WHEN COMPUTE_HASH_2=>
		
		eval<='1';
		
		
		
		WHEN OUTPUT=>
		
		
		hashOut<=(a&b&c&d&e&f&g&h);
		--report "Output";
		
		
	WHEN DONE=>
	--report "Done";
end case;
end process;


end architecture;
