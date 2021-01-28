
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.fftpackage.all;

entity testbench is
end entity;


architecture tb of testbench is

    signal clk, done, reset : std_logic := '0';
    signal input_real, input_imag, output_real, output_imag : array_of_slv(7 downto 0);


    -- begin
    --     dut : fft2d port map(clk, reset, done);
    --     clk <= not(clk) after 10 ns;
    --     reset <= '1', '0' after 50 ns;
    --     trigonometrics_rom_generator (reset, sin_rom, cos_rom);  
    --     --buffer_init(reset, buffer_2d_real, buffer_2d_imag);
    -- test2 : process 
    -- begin
    --     if reset = '1' then
    --         for i in 0 to ROWS-1 loop
    --             for j in 0 to COLS -1 loop
    --                 buffer_2d_real(i)(j) <= to_float(i * j);
    --                 buffer_2d_imag(i)(j) <= to_float(i - j);
    --                 report "i = " & integer'image(i);
    --                 report "j = " & integer'image(j);
    --             end loop;
    --         end loop;
    --     end if;
    --     wait on clk;

    -- end process ; -- test2

begin
    dut : fft generic map (8,3) 
            port map (clk, reset, input_real, input_imag, output_real, output_imag, done);
    clk <= not(clk) after 10 ns;
    
    trigonometrics_rom_generator (reset, sin_rom, cos_rom);  
    test : process
        begin
            
            reset <= '1';
            wait on clk;
            reset <= '0';

            for i in 0 to 7 loop
                input_real(i) <= std_logic_vector(to_signed((i),bitWidth));
                input_imag(i) <= std_logic_vector(to_signed((8-i),bitWidth));
            end loop;
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

            -- input_real(15) <= std_logic_vector(to_signed(200,bitWidth));
            -- input_imag(15) <= std_logic_vector(to_signed(100,bitWidth));

            -- input_real(14) <= std_logic_vector(to_signed(300,bitWidth));
            -- input_imag(14) <= std_logic_vector(to_signed(200,bitWidth));

            -- input_real(13) <= std_logic_vector(to_signed(400,bitWidth));
            -- input_imag(13) <= std_logic_vector(to_signed(300,bitWidth));

            -- input_real(12) <= std_logic_vector(to_signed(500,bitWidth));
            -- input_imag(12) <= std_logic_vector(to_signed(400,bitWidth));

            -- input_real(11) <= std_logic_vector(to_signed(600,bitWidth));
            -- input_imag(11) <= std_logic_vector(to_signed(500,bitWidth));

            -- input_real(10) <= std_logic_vector(to_signed(700,bitWidth));
            -- input_imag(10) <= std_logic_vector(to_signed(600,bitWidth));

            -- input_real(9) <= std_logic_vector(to_signed(800,bitWidth));
            -- input_imag(9) <= std_logic_vector(to_signed(700,bitWidth));
            
            -- input_real(8) <= std_logic_vector(to_signed(900,bitWidth));
            -- input_imag(8) <= std_logic_vector(to_signed(800,bitWidth));

            -- input_real(7) <= std_logic_vector(to_signed(-200,bitWidth));
            -- input_imag(7) <= std_logic_vector(to_signed(100,bitWidth));

            -- input_real(6) <= std_logic_vector(to_signed(-300,bitWidth));
            -- input_imag(6) <= std_logic_vector(to_signed(200,bitWidth));
            
            -- input_real(5) <= std_logic_vector(to_signed(-400,bitWidth));
            -- input_imag(5) <= std_logic_vector(to_signed(300,bitWidth));
            
            -- input_real(4) <= std_logic_vector(to_signed(2,bitWidth));
            -- input_imag(4) <= std_logic_vector(to_signed(0,bitWidth));
            
            -- input_real(3) <= std_logic_vector(to_signed(3,bitWidth));
            -- input_imag(3) <= std_logic_vector(to_signed(0,bitWidth));
            
            -- input_real(2) <= std_logic_vector(to_signed(2,bitWidth));
            -- input_imag(2) <= std_logic_vector(to_signed(2,bitWidth));
            
            -- input_real(1) <= std_logic_vector(to_signed(-1,bitWidth));
            -- input_imag(1) <= std_logic_vector(to_signed(2,bitWidth));
            
            -- input_real(0) <= std_logic_vector(to_signed(9,bitWidth));
            -- input_imag(0) <= std_logic_vector(to_signed(8,bitWidth));
            wait;
            -- wait on clk until done = '1';
            -- report "done";
            -- wait for 20 ns;

            -- input_real(7) <= to_float(0);
            -- input_imag(7) <= to_float(0);

            -- input_real(6) <= to_float(0);
            -- input_imag(6) <= to_float(0);
            
            -- input_real(5) <= to_float(0);
            -- input_imag(5) <= to_float(0);
            
            -- input_real(4) <= to_float(0);
            -- input_imag(4) <= to_float(0);
            
            -- input_real(3) <= to_float(0);
            -- input_imag(3) <= to_float(0);
            
            -- input_real(2) <= to_float(0);
            -- input_imag(2) <= to_float(0);
            
            -- input_real(1) <= to_float(0);
            -- input_imag(1) <= to_float(0);
            
            -- input_real(0) <= to_float(0);
            -- input_imag(0) <= to_float(0);
            

            -- reset <= '1';
            -- wait on clk;
            -- reset <= '0';


            -- wait on clk until done = '1';
            -- report "done2";
            -- wait for 20 ns;

            -- reset <= '1';
            -- wait on clk;
            -- reset <= '0';

            -- input_real(7) <= to_float(2);
            -- input_imag(7) <= to_float(1);

            -- input_real(6) <= to_float(3);
            -- input_imag(6) <= to_float(2);
            
            -- input_real(5) <= to_float(4);
            -- input_imag(5) <= to_float(3);
            
            -- input_real(4) <= to_float(5);
            -- input_imag(4) <= to_float(4);
            
            -- input_real(3) <= to_float(6);
            -- input_imag(3) <= to_float(5);
            
            -- input_real(2) <= to_float(7);
            -- input_imag(2) <= to_float(6);
            
            -- input_real(1) <= to_float(8);
            -- input_imag(1) <= to_float(7);
            
            -- input_real(0) <= to_float(9);
            -- input_imag(0) <= to_float(8);
            -- wait on clk until done = '1';
            -- report "done3";
            -- wait;
        end process ; -- test
        

end tb ; -- tb