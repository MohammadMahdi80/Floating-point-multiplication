library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity MAIN is
    Port ( input1 : in  STD_LOGIC_VECTOR (31 downto 0);
           input2 : in  STD_LOGIC_VECTOR (31 downto 0);
           output : out  STD_LOGIC_VECTOR (31 downto 0);
			  se : in std_logic);
end MAIN;

architecture Behavioral of MAIN is

begin
	process(input1, input2, se)
		variable Fraction1 : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');
		variable Exponent1 : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');
		variable Sign1 : STD_LOGIC := '0';
		variable Fraction2 : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');
		variable Exponent2 : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');
		variable Sign2 : STD_LOGIC := '0';
		variable FractionOut : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');
		variable ExponentOut : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');
		variable SignOut : STD_LOGIC := '0';
		variable PP : std_logic_vector(47 downto 0) := (others => '0');
		variable sum1, sum2 : std_logic_vector(47 downto 0) := (others => '0');
		variable sumE : std_logic_vector(8 downto 0) := (others => '0');
		variable sumF : std_logic_vector(23 downto 0) := (others => '0');
		variable normShiftValue : integer := 0;
		variable shiftes : std_logic_vector(47 downto 0) := (others => '0');
		variable roundV : std_logic_vector(1 downto 0) := (others => '0');
		variable ExB, ExC : std_logic_vector(8 downto 0) := (others => '0');
		variable s : std_logic := '0';
		variable shifted : std_logic_vector(47 downto 0) := (others => '0');
		
	begin
		Fraction1(22 downto 0) := input1(22 downto 0);
		Fraction1(23):='1'; 
		Exponent1(7 downto 0) := input1(30 downto 23);
		Exponent1(8) := '0'; 
		Sign1 := input1(31);
		
		Fraction2(22 downto 0) := input2(22 downto 0);
		Fraction2(23):='1'; 
		Exponent2(7 downto 0) := input2(30 downto 23);
		Exponent2(8) := '0';
		Sign2 := input2(31);
		
		shifted := (others => '0');
		ExB := (others => '0');
		ExC := (others => '0');
		FractionOut := (others => '0');
		roundV := (others => '0');
		normShiftValue := 0;
		sumF := (others => '0');
		sumE := (others => '0');
		sum1 := (others => '0');
		sum2 := (others => '0');
		PP := (others => '0');

		-- if Exponent of one input is 255 then result is infinit
		if (Exponent1=255 or Exponent2=255) then 
			ExponentOut := "111111111";
			FractionOut := (others => '0');
			SignOut := sign1 xor sign2;
		-- if Exponent of one input is 0 then result is 0 if it's Fraction is 0
		elsif (Exponent1="000000000") then 
			if Fraction1=x"000000" then
				ExponentOut := (others => '0');
				FractionOut := (others => '0');
				SignOut := '0';
			end if;
		elsif (Exponent2="000000000") then 
			if Fraction2=x"000000" then
				ExponentOut := (others => '0');
				FractionOut := (others => '0');
				SignOut := '0';
			end if;
		else
			if (Exponent1=0) then
				Fraction1(23) := '0';
			end if;
			
			if Exponent2=0 then
				Fraction2(23) := '0';
			end if;
			
			
			--Multiplying mantissas by adding and shifting
			for J in 0 to 23 loop
				PP := (others => '0'); 						--  xxxxxxxxxxxx
				if(Fraction2(J)='1') then					--* yyyyyyyyyyy1
					PP(23+J downto J) := Fraction1;		--_______________
				end if;											--	 xxxxxxxxxxxx
				
				sum1 := sum2 + PP;
				sum2 := sum1;
				
			end loop;

			ExponentOut := Exponent1 + Exponent2;
			-- Exponent = Exponent - 127
			ExB := ExponentOut + "110000001";			

			-- underflow and overflow
			if (ExB(8)='1') then 
				ExB := "000000000";
				FractionOut := (others => '0');
			else
				if (ExB > 254) then
					ExB := "111111111";
					FractionOut := (others => '0');
				end if;
			end if;
			
			-- finding first bit equal to 1
			if     sum1(45) = '1' then normShiftValue := 1;
			elsif  sum1(44) = '1' then normShiftValue := 2;elsif  sum1(43) = '1' then normShiftValue := 3;
			elsif  sum1(42) = '1' then normShiftValue := 4;elsif  sum1(41) = '1' then normShiftValue := 5;
			elsif  sum1(40) = '1' then normShiftValue := 6;elsif  sum1(39) = '1' then normShiftValue := 7;
			elsif  sum1(38) = '1' then normShiftValue := 8;elsif  sum1(37) = '1' then normShiftValue := 9;
			elsif  sum1(36) = '1' then normShiftValue := 10;elsif  sum1(35) = '1' then normShiftValue := 11;
			elsif  sum1(34) = '1' then normShiftValue := 12;elsif  sum1(33) = '1' then normShiftValue := 13;
			elsif  sum1(32) = '1' then normShiftValue := 14;elsif  sum1(31) = '1' then normShiftValue := 15;
			elsif  sum1(30) = '1' then normShiftValue := 16;elsif  sum1(29) = '1' then normShiftValue := 17;
			elsif  sum1(28) = '1' then normShiftValue := 18;elsif  sum1(27) = '1' then normShiftValue := 19;
			elsif  sum1(26) = '1' then normShiftValue := 20;elsif  sum1(25) = '1' then normShiftValue := 21;
			elsif  sum1(24) = '1' then normShiftValue := 22;elsif  sum1(23) = '1' then normShiftValue := 23;
			elsif  sum1(22) = '1' then normShiftValue := 24;elsif  sum1(21) = '1' then normShiftValue := 25;
			elsif  sum1(20) = '1' then normShiftValue := 26;elsif  sum1(19) = '1' then normShiftValue := 27;
			elsif  sum1(18) = '1' then normShiftValue := 28;elsif  sum1(17) = '1' then normShiftValue := 29;
			elsif  sum1(16) = '1' then normShiftValue := 30;elsif  sum1(15) = '1' then normShiftValue := 31;
			elsif  sum1(14) = '1' then normShiftValue := 32;elsif  sum1(13) = '1' then normShiftValue := 33;
			elsif  sum1(12) = '1' then normShiftValue := 34;elsif  sum1(11) = '1' then normShiftValue := 35;
			elsif  sum1(10) = '1' then normShiftValue := 36;elsif  sum1(9) = '1' then normShiftValue := 37;
			elsif  sum1(8) = '1' then normShiftValue := 38;elsif  sum1(7) = '1' then normShiftValue := 39;
			elsif  sum1(6) = '1' then normShiftValue := 40;elsif  sum1(5) = '1' then normShiftValue := 41;
			elsif  sum1(4) = '1' then normShiftValue := 42;elsif  sum1(3) = '1' then normShiftValue := 43;
			elsif  sum1(2) = '1' then normShiftValue := 44;elsif  sum1(1) = '1' then normShiftValue := 45;
			else normShiftValue := 0;
			end if;

			-- shift in right side  1-.------------
			if(sum1(47)='1') then
				sumE := ExponentOut;
				ExponentOut := sumE + "00000001";
				
				FractionOut(22 downto 0) := sum1(46 downto 24);
				FractionOut(23) := '0';
				
				roundV(1) := sum1(23);
				
				-- sticky bit
				shifted := std_logic_vector(shift_left(unsigned(sum1), 25));
				if shifted = x"000000000000" then
					s := '0';
				else 
					s := '1';
				end if;
				
				roundV(0) := s;
				
			-- 01.--------- or 0-.------1----
			else
				-- 01.---------
				if normShiftValue = 0 then
					shifted := x"000000000000";
					FractionOut(22 downto 0) := sum1(45 downto 23);
					FractionOut(23) := '0';
					
					roundV(1) := sum1(22);
					-- sticky bit
					shifted := std_logic_vector(shift_left(unsigned(sum1), 26));
					if shifted = x"000000000000" then
						s := '0';
					else 
						s := '1';
					end if;
					roundV(0) := s;
					
				-- 0-.------1----
				else
					if ExB > normShiftValue then
						shifted := x"000000000000";
						FractionOut(22 downto 0) := sum1(45 downto 23) ;
						FractionOut(23) := '0';
						roundV(1) := sum1(22);
						-- sticky bit
						shifted := std_logic_vector(shift_left(unsigned(sum1), 26));
						if shifted = x"000000000000" then
							s := '0';
						else 
							s := '1';
						end if;
						roundV(0) := s;
					else
						FractionOut(22 downto 0) := sum1(46-to_integer(unsigned(ExponentOut)) downto 24-to_integer(unsigned(ExponentOut))) ;
						ExponentOut := "000000001";
						
						roundV(1) := sum1(23-to_integer(unsigned(ExponentOut)));
						-- sticky bit
						shifted := std_logic_vector(shift_left(unsigned(sum1), 25+to_integer(unsigned(ExponentOut))));
						if shifted = x"000000000000" then
							s := '0';
						else 
							s := '1';
						end if;
						roundV(0) := s;
					end if;
					
				end if;
			
			end if;
			
			-- round
			if (roundV(1)='1' and roundV(0)='1' ) then 
				sumF := FractionOut;
				FractionOut := sumF + x"000001";
			elsif (roundV(1)='1' and roundV(0)='0') then
				sumF := FractionOut;
				if FractionOut(0) = '1' then
					FractionOut := sumF + x"1";
				else
					FractionOut := sumF + x"0";
				end if;
			end if;
				
			-- Exponent = Exponent - 127
			ExB := ExponentOut + "110000001";			

			-- underflow and overflow
			if (ExB(8)='1') then 
				ExB := "111111111";
				FractionOut := (others => '0');
			else
				if (ExB > 254) then
					ExB := "111111111";
					FractionOut := (others => '0');
				end if;
			end if;
		
		end if;

		output(31)<= Sign1 xor Sign2;
		output(30 downto 23) <= ExB(7 downto 0);
		output(22 downto 0) <= FractionOut(22 downto 0);
	end process;
end Behavioral;