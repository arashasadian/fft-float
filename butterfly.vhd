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
    begin
    process(clk,input1_imag , input2_imag , input1_real , input2_imag , coefficient_imag , coefficient_real)
     begin
        if rising_edge(clk) then
            output1_real <= input1_real + (coefficient_real * input2_real) - (coefficient_imag * input2_imag);
            output1_imag <= input1_imag + (coefficient_real * input2_imag) + (coefficient_imag * input2_real);

            output2_real <= input1_real - (coefficient_real * input2_real) + (coefficient_imag * input2_imag);
            output2_imag <= input1_imag - (coefficient_real * input2_imag) - (coefficient_imag * input2_real);
        end if;
    end process;
end architecture butterfly_arch;
