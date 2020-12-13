library ieee;
use ieee.std_logic_1164.all;
use ieee.float_pkg.all;
library work;
use work.fftpackage.all;
use ieee.numeric_std.all;



entity tp_tb is
end entity;


architecture a of tp_tb is

    signal clk, reset, enable : std_logic := '0';
    signal done : std_logic;
    signal re, im : array_2d_float(ROWS-1 downto 0)(COLS-1 downto 0);
    signal re_o, im_o : array_2d_float(COLS-1 downto 0)(ROWS-1 downto 0);
    begin
    clk <= not(clk) after 10 ns;
    dut : transpose_matrix generic map(ROWS, COLS) port map(enable, re, im, re_o, im_o);
    test2 : process 
        begin
            
            for i in 0 to ROWS-1 loop
                for j in 0 to COLS -1 loop
                    re(i)(j) <= to_float(i * j);
                    im(i)(j) <= to_float(i - j);
                end loop;
            end loop;
            enable <= '1';
            wait on clk;
            enable <= '0';
            

            
            wait;
    end process;
end architecture;