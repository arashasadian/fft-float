library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.fftpackage.all;


entity butterfly is
  generic(bitWidth : integer);
  port (
    clk : in std_logic;
    en : in std_logic;
    input1_real : in std_logic_vector(bitWidth-1 downto 0);
    input1_imag : in std_logic_vector(bitWidth-1 downto 0);
    input2_real : in std_logic_vector(bitWidth-1 downto 0);
    input2_imag : in std_logic_vector(bitWidth-1 downto 0);
    coefficient_real : in std_logic_vector(bitWidth-1 downto 0);
    coefficient_imag : in std_logic_vector(bitWidth-1 downto 0);
    output1_real : out std_logic_vector(bitWidth-1 downto 0);
    output1_imag : out std_logic_vector(bitWidth-1 downto 0);
    output2_real : out std_logic_vector(bitWidth-1 downto 0);
    output2_imag : out std_logic_vector(bitWidth-1 downto 0);
    overflows : out std_logic_vector(3 downto 0)
  ) ;
end entity butterfly;

architecture butterfly_arch of butterfly is
    begin
      process(en)
      variable overflow : integer := 0;
      begin
          overflow := 0;
          output1_real <= std_logic_vector(resize(signed(input1_real) + signed(input2_real),bitWidth));
          output1_imag <= std_logic_vector(resize(signed(input1_imag) + signed(input2_imag),bitWidth));
          
          -- overflow 
          if (signed(input1_real) > to_signed(0 , bitWidth) and signed(input2_real) > to_signed(0 , bitWidth) and signed(input1_real) + signed(input2_real) < to_signed(0 , bitWidth)) then
            overflow := overflow + 1;
          end if;

          if (signed(input1_imag) > to_signed(0 , bitWidth) and signed(input2_imag) > to_signed(0 , bitWidth) and signed(input1_imag) + signed(input2_imag) < to_signed(0 , bitWidth)) then
            overflow := overflow + 1;
          end if;

          if (signed(input1_real) < to_signed(0 , bitWidth) and signed(input2_real) < to_signed(0 , bitWidth) and signed(input1_real) + signed(input2_real) > to_signed(0 , bitWidth)) then
            overflow := overflow + 1;
          end if;

          if (signed(input1_imag) < to_signed(0 , bitWidth) and signed(input2_imag) < to_signed(0 , bitWidth) and signed(input1_imag) + signed(input2_imag) > to_signed(0 , bitWidth)) then
            overflow := overflow + 1;
          end if;

          output2_real <= std_logic_vector(resize(((signed(input1_real) - signed(input2_real))*signed(coefficient_real) - (signed(input1_imag) - signed(input2_imag))*signed(coefficient_imag))/255,bitWidth));
          output2_imag <= std_logic_vector(resize(((signed(input1_real) - signed(input2_real))*signed(coefficient_imag) + (signed(input1_imag) - signed(input2_imag))*signed(coefficient_real))/255,bitWidth));
          
          if (signed(input1_real) > to_signed(0 , bitWidth) and signed(input2_real) < to_signed(0 , bitWidth) and signed(input1_real) - signed(input2_real) < to_signed(0 , bitWidth)) then
            overflow := overflow + 1;
          end if;

          if (signed(input1_imag) > to_signed(0 , bitWidth) and signed(input2_imag) < to_signed(0 , bitWidth) and signed(input1_imag) - signed(input2_imag) < to_signed(0 , bitWidth)) then
            overflow := overflow + 1;
          end if;

          if (signed(input1_real) < to_signed(0 , bitWidth) and signed(input2_real) > to_signed(0 , bitWidth) and signed(input1_real) - signed(input2_real) > to_signed(0 , bitWidth)) then
            overflow := overflow + 1;
          end if;

          if (signed(input1_imag) < to_signed(0 , bitWidth) and signed(input2_imag) > to_signed(0 , bitWidth) and signed(input1_imag) - signed(input2_imag) > to_signed(0 , bitWidth)) then
            overflow := overflow + 1;
          end if;


          overflows <= std_logic_vector(to_signed(overflow, 4));

      end process;
        
end architecture butterfly_arch;
