LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

ENTITY calcul_puissance IS
    GENERIC(
	k : integer :=10
    );
    PORT(
        reset      : IN std_logic;		-- reset asynchrone
        clock      : IN std_logic;		-- horloge systeme
        C      	   : IN std_logic;		-- commande = 1 quand l'opération doit se faire
		X     	   : IN signed(15 downto 0); 	-- facteur de division
        P	   	   : OUT unsigned(31 downto 0)
    );
END calcul_puissance;
