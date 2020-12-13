library ieee;
use ieee.std_logic_1164.all;
use ieee.float_pkg.all;
library work;
use work.fftpackage.all;
use ieee.numeric_std.all;
use std.textio.all;


entity fft2_tb is
end entity;


architecture a of fft2_tb is

    signal clk, reset, enable : std_logic := '0';
    signal done : std_logic := '0';
    signal re, im, re_o, im_o : array_2d_float(ROWS-1 downto 0)(COLS-1 downto 0);

    begin
        clk <= not(clk) after 10 ns;
        trigonometrics_rom_generator (reset, sin_rom, cos_rom);
        dut : fft2d generic map(ROWS, COLS) port map(clk, reset, enable, re, im, re_o, im_o, done);
    test2 : process 
    variable line_var : line;
    file out_file : text;
    variable num : float32;
    begin
        
        --if reset = '1' then
            for i in 0 to ROWS-1 loop
                for j in 0 to COLS -1 loop
                    re(i)(j) <= to_float(i * j);
                    im(i)(j) <= to_float(i - j);
                end loop;
            end loop;
        --end if;
        reset <= '1' ;
        wait on clk;
        reset <= '0';      
        report("fft start");    
        enable <= '1';
        wait on clk until done = '1';
        enable <= '0';
        report "done1";
        -- enable <= '0';
        -- wait;
        -- for i in 0 to ROWS-1 loop
        --     for j in 0 to COLS -1 loop
        --         re(i)(j) <= to_float(i * i);
        --         im(i)(j) <= to_float(i + j);
        --     end loop;
        -- end loop;
        -- reset <= '1' ;
        -- wait on clk;
        -- wait on clk;
        -- reset <= '0';          
        -- enable <= '1';
        -- wait on clk until done = '1';
        -- enable <= '0';        
        -- report "done";

        wait;
    end process ; -- test2


        
end architecture;