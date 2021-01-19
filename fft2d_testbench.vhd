library ieee;
use ieee.std_logic_1164.all;

library work;
use work.fftpackage.all;
use ieee.numeric_std.all;
use std.textio.all;


entity fft2_tb is
end entity;


architecture a of fft2_tb is

    signal clk, reset, enable : std_logic := '0';
    signal done : std_logic := '0';
    signal re, im, re_o, im_o : array_2d_slv(ROWS-1 downto 0)(COLS-1 downto 0);

    begin
        clk <= not(clk) after 10 ns;
        trigonometrics_rom_generator (reset, sin_rom, cos_rom);
        dut : fft2d generic map(ROWS, COLS) port map(clk, reset, enable, re, im, re_o, im_o, done);
    test2 : process 
        file infile          : text is in "imag_gen.txt";
        variable row         : line;
        variable element     : integer;
        variable end_of_line : boolean := true;    
        variable s : line;
        file out_file        : text open write_mode is  "image_out.txt";
    begin
        
        --if reset = '1' then
            -- for i in 0 to ROWS-1 loop
            --     for j in 0 to COLS -1 loop
            --         re(i)(j) <= to_float(i * j);
            --         im(i)(j) <= to_float(i - j);
            --     end loop;
            -- end loop;
        --end if;
        for i in 0 to ROWS-1 loop
            readline(infile, row);
            for j in 0 to COLS-1 loop
                read(row, element, end_of_line);
                re(i)(j) <=  std_logic_vector(to_signed((element),bitWidth));
                im(i)(j) <= std_logic_vector(to_signed((0),bitWidth));
            end loop;
        end loop;

        reset <= '1' ;
        wait on clk;
        reset <= '0';      
        report("fft start");    
        enable <= '1';
        wait on clk until done = '1';
        enable <= '0';

        for i in 0 to ROWS-1 loop
            for j in 0 to COLS-1 loop
                write(s,integer'image(to_integer(signed(re_o(i)(j)))));
                write(s,string'(" "));
            end loop;
            writeline(out_file,s);
        end loop;




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