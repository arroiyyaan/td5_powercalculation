-- Advanced Digital Electronic module | Prof. Herve Mathias
-- Rilwanu Ar Roiyyaan KASNO | M2 ICS

-- ===============================================
-- TD 5
-- Realization of a data path and a state machine
-- ===============================================

-- required library declaration
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

------------------------------------------------
architecture a1 of calcul_puissance is

	-- internal declaration
	signal s_res : std_logic;
	signal counter : unsigned(9 downto 0);
	signal load : std_logic;
	constant zeros : std_logic_vector(9 downto 0) := (others => '0');

	-- all internal signal declaration
	signal X_input : unsigned(31 downto 0);
	signal X_resized : std_logic_vector(41 downto 0);
	signal X_summed : unsigned(41 downto 0);
	signal X_accummulated : unsigned(41 downto 0);
	signal X_final : unsigned(41 downto 0);

	-- the three states being IDLE, COUNT (counting), TRANS (transition from counting to IDLE again)
	type statetype is (IDLE, COUNT, TRANS);
	signal state : statetype;

begin
	-- multiplying signal X
	X_input <= unsigned(std_logic_vector(X*X));
	-- resizing signal X (X size concatenated with k size)
	X_resized <= zeros & std_logic_vector(X_input);
	-- summing the multiplied signal
	X_summed 				<= unsigned(X_resized) + X_accummulated;
	-- X_accummulated is actually forwarded the summed signal when the internal reset in multiplexer is active
	X_accummulated 	<= X_summed when s_res = '1' else (others => '0');

	process(clock, reset)
	begin
		if (reset = '1') then
			-- set to zeros when system being reset
			X_summed <= (others => '0');
			X_final  <= (others => '0');

		-- otherwise, during the clock,
		elsif rising_edge(clock) then
			-- X_summed being the signal of summation between the resized signal with the accummulated signal
			X_summed 	<= unsigned(X_resized) + X_accummulated;
			if load = '1' then
				-- if load is active, the output signal will be summation between the resized signal with the accummulated signal
				-- but different with the X_summed as depicted in the diagram
				X_final <= unsigned(X_resized) + X_accummulated;
				-- bit slice only the 32 MSB for the output
				P <= X_final(41 downto 10);
			end if;
		end if;
	end process;

	------- states --------
	process(clock, reset)
	begin
		if (reset = '1') then

		-- during the clock cycle,
		elsif rising_edge(clock) then
			case state is
				-- when the current state is IDLE, set load, counter, and internal reset to the decided condition
				when IDLE =>
					load 		<= '0';
					counter <= to_unsigned(2**k, counter'length) - 2;
					s_res 	<= '1';

					-- if input C is active, make transition to next state which is counting COUNT state
					if (C = '1') then
						state <= COUNT;
					end if;

				-- when the current state is COUNT, set load, counter, and internal reset to the decided condition
				when COUNT =>
					counter <= counter - 1;
					load 		<= '0';
					s_res		<= '0';

					-- if the 'counter' is equal to one, make transition to last state which is TRANS state
					if (counter = 1) then
						state <= TRANS;
					end if;

				-- when in the last state TRANS, set load, counter, and internal reset to the decided condition
				when TRANS =>
					load 		<= '1';
					counter <= to_unsigned(2**k, counter'length) - 2;
					s_res		<= '0';

					-- rightaway move back to IDLE state afterwards
					state 	<= IDLE;
			end case;
		end if;
	end process;

end architecture a1;
