library ieee;
use ieee.std_logic_1164.all;
library work;
use work.fftpackage.all;
use ieee.numeric_std.all;



entity tb is
end entity;


architecture a of tb is

    signal clk, reset, enable : std_logic := '0';
    signal done : std_logic;
    signal re, im, re_o, im_o : array_2d_slv(ROWS-1 downto 0)(COLS-1 downto 0);

    begin
    clk <= not(clk) after 10 ns;
    trigonometrics_rom_generator (reset, sin_rom, cos_rom);
    dut : fft_top generic map (ROWS, COLS) port map(clk, reset, enable, re, im, re_o, im_o, done);
    test2 : process 
    begin
        
        --if reset = '1' then
            report "start"; 
            for i in 0 to ROWS-1 loop
                for j in 0 to COLS -1 loop
                    re(i)(j) <= std_logic_vector(to_signed((i * j),bitWidth));
                    im(i)(j) <= std_logic_vector(to_signed((i - j),bitWidth));
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
    end process ; -- test2


        
end architecture;