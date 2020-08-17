library ieee;
use ieee.std_logic_1164.all;
use ieee.float_pkg.all;
library work;
use work.fftpackage.all;



entity fft is
  generic ( N : integer := 8);
  port (
    clk : in std_logic;
    input_array_real : in array_of_float32(N - 1 downto 0);
    input_array_imag : in array_of_float32(N - 1 downto 0);
    output_array_real : out array_of_float32(N - 1 downto 0);
    output_array_imag : out array_of_float32(N - 1 downto 0);
    done : out std_logic
  ) ;
end fft;

architecture arch of fft is
    signal bt_in1_imag, bt_in1_real, bt_in2_imag, bt_in2_real : float32;
    signal bt_out1_imag, bt_out1_real, bt_out2_imag, bt_out2_real : float32;
    signal bt_coef_imag, bt_coef_real : float32;
    begin
    butterfly_module : butterfly port map(clk, bt_in1_real, bt_in1_imag, bt_in2_real, bt_in2_imag,
        bt_coef_real, bt_coef_imag, bt_out1_real, bt_out1_imag, bt_out2_real, bt_out2_imag);

    calculate_bt_inputs : process( clk )
    begin
        
    end process ; -- calculate_bt_inputs

end architecture arch;