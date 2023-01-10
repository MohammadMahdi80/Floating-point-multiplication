LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MAIN
    PORT(
         input1 : IN  std_logic_vector(31 downto 0);
         input2 : IN  std_logic_vector(31 downto 0);
         output : OUT  std_logic_vector(31 downto 0);
         se : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal input1 : std_logic_vector(31 downto 0) := (others => '0');
   signal input2 : std_logic_vector(31 downto 0) := (others => '0');
   signal se : std_logic := '0';

 	--Outputs
   signal output : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 

	
	file output_buf : text; 
 
BEGIN
		
		PROCESS
		variable wb : line;
		begin
		file_open(output_buf, "./result.txt",  write_mode);

			 wait for 50 ns; 
			 
			 input1 <= x"4C07FD03";
          input2 <= x"4B16AC82";
			 wait for 50 ns; 
			 write( wb, input1);write( wb, input2);write( wb, output);write(wb, string'("57A013C6"));writeline(output_buf,  wb); 
          
			 
			 
			 input1 <= x"42480000";
          input2 <= x"42700000";
			 wait for 50 ns; 
			 write( wb, input1);write( wb, input2);write( wb, output);write(wb, string'("453B8000"));writeline(output_buf,  wb); 
          
			
			 
			 input1 <= x"5442CD6B";
          input2 <= x"55F14D3E";
			 wait for 50 ns; 
			 write( wb, input1);write( wb, input2);write( wb, output);write(wb, string'("6AB79E29"));writeline(output_buf,  wb); 
          
			 
			 input1 <= x"4EB379A4";
          input2 <= x"4E9CD629";
			 wait for 50 ns; 
			 write( wb, input1);write( wb, input2);write( wb, output);write(wb, string'("5DDBE889"));writeline(output_buf,  wb); 
          
			 
			 input1 <= x"CA8B9472";
          input2 <= x"512A91AE";
			 wait for 50 ns; 
			 write( wb, input1);write( wb, input2);write( wb, output);write(wb, string'("DC3A0003"));writeline(output_buf,  wb); 
          		 
			 input1 <= x"00000000";
          input2 <= x"512A91AE";
			 wait for 50 ns; 
			 write( wb, input1);write( wb, input2);write( wb, output);write(wb, string'("00000000"));writeline(output_buf,  wb); 
			
			
			input1 <= x"3F0BB2FF";
         input2 <= x"3F0C0831";
			wait for 50 ns;  

			input1 <= x"6258D727";
         input2 <= x"5F0AC723";
			wait for 50 ns;  

			input1 <= x"006CE3EE";
         input2 <= x"006CE3EE";
			wait for 50 ns; 
			write( wb, input1);write( wb, input2);write( wb, output);write(wb, string'("00000000"));writeline(output_buf,  wb); 





		file_close(output_buf);
      wait;
		end process;
		
		
		
		
		
	-- Instantiate the Unit Under Test (UUT)
   uut: MAIN PORT MAP (
          input1 => input1,
          input2 => input2,
          output => output,
          se => se
        );


 


END;
