
library ieee;
use ieee.std_logic_1164.all;
use ieee.float_pkg.all;
library work;
use work.fftpackage.all;

entity testbench is
end entity;


architecture tb of testbench is

    signal clk, done, enable : std_logic := '0';
    signal input_real, input_imag, output_real, output_imag : array_of_float32(7 downto 0);

begin
    dut : fft port map (clk, input_real, input_imag, output_real, output_imag, done);
    clk <= not(clk) after 10 ns;
    enable <= '1' after 2 ns;
    
    index_rom_generator(enable, input_index_rom, middle_index_rom, output_index_rom);
    test : process
        begin
            input_real(7) <= to_float(7);
            input_imag(7) <= to_float(0);

            input_real(6) <= to_float(6);
            input_imag(6) <= to_float(0);
            
            input_real(5) <= to_float(5);
            input_imag(5) <= to_float(0);
            
            input_real(4) <= to_float(4);
            input_imag(4) <= to_float(0);
            
            input_real(3) <= to_float(3);
            input_imag(3) <= to_float(0);
            
            input_real(2) <= to_float(2);
            input_imag(2) <= to_float(0);
            
            input_real(1) <= to_float(1);
            input_imag(1) <= to_float(0);
            
            input_real(0) <= to_float(0);
            input_imag(0) <= to_float(0);
            wait for 20 ns;
        end process ; -- test
        

end tb ; -- tb