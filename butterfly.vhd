library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.fftpackage.all;


entity butterfly is
  generic(bitWidth : integer);
  port (
    clk : in std_logic;
    input1_real : in std_logic_vector(bitWidth-1 downto 0);
    input1_imag : in std_logic_vector(bitWidth-1 downto 0);
    input2_real : in std_logic_vector(bitWidth-1 downto 0);
    input2_imag : in std_logic_vector(bitWidth-1 downto 0);
    coefficient_real : in std_logic_vector(bitWidth-1 downto 0);
    coefficient_imag : in std_logic_vector(bitWidth-1 downto 0);
    output1_real : out std_logic_vector(bitWidth-1 downto 0);
    output1_imag : out std_logic_vector(bitWidth-1 downto 0);
    output2_real : out std_logic_vector(bitWidth-1 downto 0);
    output2_imag : out std_logic_vector(bitWidth-1 downto 0)
  ) ;
end entity butterfly;

architecture butterfly_arch of butterfly is
    signal temp_real : std_logic_vector(bitWidth-1 downto 0);
    signal temp_imag : std_logic_vector(bitWidth-1 downto 0);
    begin
        output1_real <= std_logic_vector(resize(signed(input1_real) + signed(input2_real),bitWidth));
        output1_imag <= std_logic_vector(resize(signed(input1_imag) + signed(input2_imag),bitWidth));
        temp_real    <= std_logic_vector(resize(signed(input1_real) - signed(input2_real),bitWidth));
        temp_imag    <= std_logic_vector(resize(signed(input1_imag) - signed(input2_imag),bitWidth));
        output2_real <= std_logic_vector(resize((signed(temp_real)*signed(coefficient_real) - signed(temp_imag)*signed(coefficient_imag))/255,bitWidth));
        output2_imag <= std_logic_vector(resize((signed(temp_real)*signed(coefficient_imag) + signed(temp_imag)*signed(coefficient_real))/255,bitWidth));
end architecture butterfly_arch;
