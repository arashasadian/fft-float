
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
    dut : fft generic map (8,3) 
            port map (clk, input_real, input_imag, output_real, output_imag, done);
    clk <= not(clk) after 10 ns;
    enable <= '1' after 2 ns;
    trigonometrics_rom_generator (enable, sin_rom, cos_rom);  
    test : process
        begin
            -- input_real(15) <= to_float(2);
            -- input_imag(15) <= to_float(1);

            -- input_real(14) <= to_float(3);
            -- input_imag(14) <= to_float(2);
            
            -- input_real(13) <= to_float(4);
            -- input_imag(13) <= to_float(3);
            
            -- input_real(12) <= to_float(5);
            -- input_imag(12) <= to_float(4);
            
            -- input_real(11) <= to_float(6);
            -- input_imag(11) <= to_float(5);
            
            -- input_real(10) <= to_float(7);
            -- input_imag(10) <= to_float(6);
            
            -- input_real(9) <= to_float(8);
            -- input_imag(9) <= to_float(7);
            
            -- input_real(8) <= to_float(9);
            -- input_imag(8) <= to_float(8);

            input_real(7) <= to_float(2);
            input_imag(7) <= to_float(1);

            input_real(6) <= to_float(3);
            input_imag(6) <= to_float(2);
            
            input_real(5) <= to_float(4);
            input_imag(5) <= to_float(3);
            
            input_real(4) <= to_float(5);
            input_imag(4) <= to_float(4);
            
            input_real(3) <= to_float(6);
            input_imag(3) <= to_float(5);
            
            input_real(2) <= to_float(7);
            input_imag(2) <= to_float(6);
            
            input_real(1) <= to_float(8);
            input_imag(1) <= to_float(7);
            
            input_real(0) <= to_float(9);
            input_imag(0) <= to_float(8);
            wait for 20 ns;
        end process ; -- test
        

end tb ; -- tb