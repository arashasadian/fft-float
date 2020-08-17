library ieee;
use ieee.std_logic_1164.all;
use ieee.float_pkg.all;


package fftpackage is
    type array_of_float32 is array(natural range <>) of float32;
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


end package fftpackage;