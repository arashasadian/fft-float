library ieee;
use ieee.std_logic_1164.all;
use ieee.float_pkg.all;
library work;
use work.fftpackage.all;


entity butterfly is
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
end entity butterfly;

architecture butterfly_arch of butterfly is
    signal temp_real : float32;
    signal temp_imag : float32;
    begin
        output1_real <= input1_real + input2_real;
        output1_imag <= input1_imag + input2_imag;
        temp_real <= input1_real - input2_real;
        temp_imag <= input1_imag - input2_imag;
        output2_real <= ((temp_real)*coefficient_real - (temp_imag)*coefficient_imag);
        output2_imag <= ((temp_real)*coefficient_imag + (temp_imag)*coefficient_real);
end architecture butterfly_arch;
