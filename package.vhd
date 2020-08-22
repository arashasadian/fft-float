library ieee;
use ieee.std_logic_1164.all;
use ieee.float_pkg.all;


package fftpackage is
    type array_of_float32 is array(natural range <>) of float32;
    type array_of_integer is array(natural range <>) of integer;
    component butterfly is
        port (
          clk : in std_logic;
          input1_real : in float32;
          input1_imag : in float32;
          input2_real : in float32;
          input2_imag : in float32;
          coefficient_real : in float32;
          coefficient_imag : in float32;
          output1_real : out float32;
          output1_imag : out float32;
          output2_real : out float32;
          output2_imag : out float32
        ) ;
      end component butterfly;
    signal middle_index_rom : array_of_integer(7 downto 0);
    signal output_index_rom : array_of_integer(7 downto 0);
    signal input_index_rom : array_of_integer(7 downto 0);


end package fftpackage;

package body fftpackage is 
  procedure index_rom_generator (signal enable : in std_logic; 
    signal input_index, mid_index, final_index : inout array_of_integer(7 downto 0)) is
    begin
        if rising_edge(enable) then
          input_index(0) <= 0;
          input_index(1) <= 4;
          input_index(2) <= 2;
          input_index(3) <= 6;
          input_index(4) <= 1;
          input_index(5) <= 5;
          input_index(6) <= 3;
          input_index(7) <= 7;

          mid_index(0) <= 0;
          mid_index(1) <= 2;
          mid_index(2) <= 4;
          mid_index(3) <= 6;
          mid_index(4) <= 1;
          mid_index(5) <= 3;
          mid_index(6) <= 5;
          mid_index(7) <= 7;


          final_index(0) <= 0;
          final_index(1) <= 4;
          final_index(2) <= 1;
          final_index(3) <= 5;
          final_index(4) <= 2;
          final_index(5) <= 6;
          final_index(6) <= 3;
          final_index(7) <= 7;

        end if;
  end procedure index_rom_generator;

end package body fftpackage;