library ieee;
use ieee.std_logic_1164.all;
use ieee.float_pkg.all;
library work;
use work.fftpackage.all;
use ieee.numeric_std.all;



entity tb is
end entity;


architecture aa of tb is

    signal clk, reset, enable : std_logic := '0';
    signal done : std_logic;
    signal re, im, re_o, im_o : array_2d_float(ROWS-1 downto 0)(COLS-1 downto 0);

    begin
    clk <= not(clk) after 10 ns;
    trigonometrics_rom_generator (reset, sin_rom, cos_rom);
    dut : ifft_top generic map (ROWS, COLS) port map(clk, reset, enable, re, im, re_o, im_o, done);
    test2 : process 
    begin
        
        --if reset = '1' then
            report "start"; 
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
        enable <= '1';
        wait on clk until done = '1';
        report "done1";
        enable <= '0';
        wait;
        for i in 0 to ROWS-1 loop
            for j in 0 to COLS -1 loop
                re(i)(j) <= to_float(i * i);
                im(i)(j) <= to_float(i + j);
            end loop;
        end loop;
        reset <= '1' ;
        wait on clk;
        wait on clk;
        reset <= '0';          
        enable <= '1';
        wait on clk until done = '1';
        enable <= '0';        
        report "done";
        wait;
    end process ; -- test2


        
end architecture;