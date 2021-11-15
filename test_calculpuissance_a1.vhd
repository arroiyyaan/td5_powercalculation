architecture a1 of test_calculpuissance is

----------------------------------------------------
-- tous les composants  connecter
----------------------------------------------------

component calcul_puissance IS
    GENERIC(
	k : integer :=10
    );
    PORT(
        reset      	: IN std_logic;		-- reset asynchrone
        clock      	: IN std_logic;		-- horloge systeme
        C      	   	: IN std_logic;		-- commande = 1 quand l'opération doit se faire
		    X     	   	: IN signed(15 downto 0); 	-- facteur de division
        P	   		: OUT unsigned(31 downto 0)
    );
END component calcul_puissance;


---------------------------------
-- tous les signaux locaux
---------------------------------

signal reset,C : std_logic ;	 			-- reset et autorisation de la logique
signal clock : std_logic :='0' ;	 		-- horloge de reference  10 Mhz du GSM
signal X : signed(15 downto 0) := (others => '0') ;	-- facteur de division
signal P : unsigned(31 downto 0) ;   -- puissance calculee

signal amp : real := 32767.0 ;			-- amplitude du signal genere
constant freq : real := 50.0 ;			-- frequence du signal genere

begin

-- instantiation du composant de calcul de puissance
inst_DUT : calcul_puissance
		generic map(
			k => 10
		)
		port map(
			reset 	=> reset,
			clock 	=> clock,
			C		=> C,
			X		=> X,
			P		=> P
		);

-- génération des signaux de test

reset <= '0', '1' after 100 ns;
C <= '1';

p_clock : process
begin
	wait for 50 ns;
	clock <= not clock;
end process;


p1 : process
begin
  wait for 1000 ms ;
  amp <= amp/2.0 ;
end process ;

p2 : process(clock)
variable phase : real ;
begin
  if falling_edge(clock) then
	phase := 2.0*3.1415927*freq*real((now/(1 ns))*1.0e-9) ;
	X <= to_signed(integer(amp*sin(phase)),x'length);
  end if ;
end process ;

end architecture a1 ;
