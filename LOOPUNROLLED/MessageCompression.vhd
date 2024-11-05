
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sha_512_pkg.all;

entity messageCompression is
    port(
        clk          : in std_logic;  -- Clock signal
        reset        : in std_logic;  -- Reset signal to initialize the state
	initial      : in std_logic;
	eval : in std_logic;
	counter : in integer;
        Wt, Kt       : in std_logic_vector(WORD_SIZE-1 downto 0);    -- Input message word and round constant
        finalHash : out std_logic_vector(8*WORD_SIZE-1 DOWNTO 0);
	reqSiq : out std_logic
    );
end messageCompression;

architecture behavioral of messageCompression is
    signal a, b, c, d, e, f, g, h : std_logic_vector(WORD_SIZE-1 downto 0);
    
    signal constA ,cPrev: std_logic_vector(WORD_SIZE-1 DOWNTO 0);
    signal testHash : std_logic_vector(8*WORD_SIZE-1 downto 0);
    signal outSig : std_logic;

	
   
    
    signal HV_INITIAL_VALUES : H_DATA := ( X"6a09e667f3bcc908", X"bb67ae8584caa73b",
                                       X"3c6ef372fe94f82b", X"a54ff53a5f1d36f1",
                                       X"510e527fade682d1", X"9b05688c2b3e6c1f",
                                       X"1f83d9abfb41bd6b", X"5be0cd19137e2179");
begin

       	   
    process(eval,initial,clk)
    begin
      if reset = '1' then
           
       else
	
 
        if(initial='1') then
	
	
			a<=HV_INITIAL_VALUES(0); 
			b<=HV_INITIAL_VALUES(1); 
			c<=HV_INITIAL_VALUES(2); 
			d<=HV_INITIAL_VALUES(3); 
			e<=HV_INITIAL_VALUES(4); 
			f<=HV_INITIAL_VALUES(5); 
			g<=HV_INITIAL_VALUES(6); 
			h<=HV_INITIAL_VALUES(7);	
	else
		--if(rising_edge(eval)) then
		---CALCUALTE FIRSTHALF
		if(counter>=0 and counter<=39) then
		
		if(eval='1') then
		if(falling_edge(clk)) then
			
			--(setting c to be the privious value of a)
			--g<=std_logic_vector(unsigned(Kt) + unsigned(Wt) + unsigned(d)+unsigned(h)+unsigned(CH(e, f, g))+unsigned(SIGMA_UCASE_1(e)));
			a<=std_logic_vector(unsigned(SIGMA_UCASE_0(a)) + unsigned(MAJ(a, b, c))+unsigned(h) + unsigned(SIGMA_UCASE_1(e)) + unsigned(CH(e, f, g))
                                + unsigned(Kt) + unsigned(Wt));
			cPrev<=c;
			c<=a;
			d<=b;
			--ktwtPrev<=std_logic_vector(unsigned(Kt) + unsigned(Wt));
		constA<=std_logic_vector(unsigned(Kt) + unsigned(Wt)+unsigned(SIGMA_UCASE_1(e)) + unsigned(d)+unsigned(h)+unsigned(CH(e,f,g)));
		end if;
		end if;

			--h<=g;
			--g<=f;
			--f<=e;
			--e<=std_logic_vector(unsigned(d)+unsigned(h) + unsigned(SIGMA_UCASE_1(e)) + unsigned(CH(e, f, g))
                          --        + unsigned(Kt) + unsigned(Wt));
			--d<=c;
			--c<=b;
			--b<=a;
			--a<=std_logic_vector(unsigned(SIGMA_UCASE_0(a)) + unsigned(MAJ(a, b, c))+unsigned(h) + unsigned(SIGMA_UCASE_1(e)) + unsigned(CH(e, f, g))
                         --            + unsigned(Kt) + unsigned(Wt));
		
			
		
	---CALCULATE NEXT HALF
		if(eval='0') then
		if(falling_edge(clk)) then
		--report "Eval is zero and Falling Edge";
		b<=a;
		e<=std_logic_vector(unsigned(Wt)+unsigned(Kt)+unsigned(g)+unsigned(SIGMA_UCASE_1(constA))+unsigned(CH(constA,e,f))+unsigned(cPrev));
		f<=constA;
		a<=std_logic_vector(unsigned(SIGMA_UCASE_0(a)) + unsigned(MAJ(a,b,c))+unsigned(g) + unsigned(SIGMA_UCASE_1(constA)) + unsigned(CH(constA,e,f))+ unsigned(Kt) + unsigned(Wt) );
		--c<=a;
		--d<=b;
		--g<=e;
		h<=f;
		g<=e;

		
		
		
		
		end if;
		end if;
end if;

---SETTING OF OUTSIG
		if eval='0' then
			outSig<='1';
		else
			outsig<='0';
			
		end if;
		
		
	end if;
	
	end if;
	 if(counter = 39) then
		 testHash<=(a&b&c&d&e&f&g&h);
	end if;
    end process;

    -- Assign outputs
        finalHash<=testHash;
	reqSiq<=outSig;

end behavioral;

