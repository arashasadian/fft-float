library ieee;
use ieee.std_logic_1164.all;

library work;
use work.fftpackage.all;
use ieee.numeric_std.all;
use std.textio.all;


entity pipeline_tb is
end entity;




architecture pipelinetb of pipeline_tb is
    signal clk, reset : std_logic := '0';
    signal done, enable : std_logic := '0';

    signal bitWidth : integer := 32;
    begin
        clk <= not clk after 10 ns;
        myfft_pipeline_module : fft_pipeline_generic generic map(COLS,STEP) port map(clk, enable, reset,done);
        trigo_module : trigo port map(reset);
        process begin
            reset <= '1';
            wait on clk;
            reset <= '0';
            for i in 0 to COLS-1 loop
                fft_real_in(i) <= std_logic_vector(to_signed(i,bitWidth));
                fft_imag_in(i) <= std_logic_vector(to_signed(COLS-i,bitWidth));
            end loop; 
        enable <= '1';
        wait on clk until done = '1';   
        enable <= '0';
        report "done";
        wait;
        end process;
end architecture;