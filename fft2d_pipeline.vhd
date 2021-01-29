library ieee;
use ieee.std_logic_1164.all;
library work;
use work.fftpackage.all;
use ieee.numeric_std.all;

entity fft2d_pipeline is
    generic ( ROWS : integer ; COLS : integer );
    port (
      clk : in std_logic;
      reset : in std_logic;
      enable : in std_logic;
    --   is_ifft : in std_logic;
      done : out std_logic
    ) ;
end fft2d_pipeline;

architecture arch of fft2d_pipeline is

    signal current_state, next_state : fft2d_state := FFT_INIT1;

    -- signal fft_real_in, fft_imag_in, fft_real_out, fft_imag_out : array_of_slv(COLS-1 downto 0);
    
    signal fft_reset_sig, fft_enable, fft_done_sig : std_logic := '0';

    signal clk_cycles : integer := 0;
    signal clk_done : std_logic;
begin
    fft_module : fft_pipeline_generic generic map(COLS, STEP) port map(clk, fft_enable, fft_reset_sig, fft_done_sig);

    main_process : process( clk )
    begin
        if reset = '1' then
            
            current_state <= IDLE;
            clk_cycles <= 0;
        else
            current_state <= next_state;
            if clk_done = '1' then
                report "fft2 clk cycles : " & integer'image(clk_cycles);
            end if;
            clk_cycles <= clk_cycles + 1;
        end if;
    end process ; -- main_process

    next_state_process: process(current_state)
        variable index : integer := 0;

        variable one_or_two : std_logic := '0';
        variable real_ram_shadow, imag_ram_shadow : array_2d_slv;
        variable real_ram_shadow_2, imag_ram_shadow_2 : array_2d_slv;
    begin
        case current_state is


            when FFT_INIT1 =>
                next_state <= FFT_INIT2;

            when FFT_INIT2 =>
                next_state <= FFT_INIT1;

            when IDLE =>
        
            fft_reset_sig <= '1';
                clk_done <= '0';
                if enable = '1' then
                    done <= '0';
                    one_or_two := '0';
                    index := 0;
                        for i in 0 to ROWS-1 loop
                            for j in 0 to COLS-1 loop
                                real_ram_shadow(j)(i) := image_real(i)(j);
                                imag_ram_shadow(j)(i) := image_imag(i)(j);
                            end loop;
                        end loop;
                    
                    next_state <= FFT_RESET;
                else
                    next_state <= IDLE;
                end if;
            when FFT_RESET =>
                if (index < ROWS) then
                    fft_real_in <= real_ram_shadow(index);
                    fft_imag_in <= imag_ram_shadow(index);
                    -- fft_reset_sig <= '1';
                    
                    next_state <= FAKE;
                else
                    next_state <= FFT_DONE;
                end if;
            
            when FAKE =>
                next_state <= FFT_BUSY;
                fft_enable <= '1';

            when FFT_BUSY =>
                fft_reset_sig <= '0';
                if fft_done_sig  = '1' then
                    real_ram_shadow(index) := fft_real_out;
                    imag_ram_shadow(index) := fft_imag_out;
                    index := index + 1; 
                    fft_reset_sig <= '1';
                    next_state <= FFT_RESET;
                    fft_enable <= '0';
                else
                    next_state <= FFT_P;
                end if;
        
            when FFT_P =>
                fft_reset_sig <= '0';
                if fft_done_sig  = '1' then
                    real_ram_shadow(index) := fft_real_out;
                    imag_ram_shadow(index) := fft_imag_out;
                    index := index + 1;
                    fft_reset_sig <= '1';
                    next_state <= FFT_RESET;
                    fft_enable <= '0';
                else
                    next_state <= FFT_BUSY;
                end if; 

            when FFT_DONE => 
                if one_or_two = '0' then
                    index := 0;
                    for i in 0 to ROWS-1 loop
                        for j in 0 to COLS-1 loop
                            real_ram_shadow_2(j)(i) := real_ram_shadow(i)(j);
                            imag_ram_shadow_2(j)(i) := imag_ram_shadow(i)(j);
                        end loop;
                    end loop;
                    real_ram_shadow := real_ram_shadow_2;
                    imag_ram_shadow := imag_ram_shadow_2;   
                    next_state <= FFT_RESET;
                    one_or_two := '1';
                else
                    -- for i in 0 to ROWS-1 loop
                    -- if is_ifft = '1' then
                        image_real_out <= real_ram_shadow;
                        image_imag_out <= imag_ram_shadow;
                    -- else
                    --     middle_real <= real_ram_shadow;
                    --     middle_imag <= imag_ram_shadow;
                    -- end if;
                    -- end loop;
                    done <= '1' ;
                    clk_done <= '1';
                    next_state <= IDLE;
                end if;
        end case;

        
    end process ; -- next_state_logic

end architecture;








                







































--     next_state_logic : process( current_state )
--     begin
--         case current_state is
--             when IDLE =>
--                 if enable = '1' then
--                     next_state <= TRANSPOSE;
--                     done <= '0';
--                 else
--                     next_state <= IDLE;
--                 end if;
            
--             when TRANSPOSE =>
--                 transpose_real_in <= input_array_real;
--                 transpose_imag_in <= input_array_imag;
--                 transpose_enable <= '1';
--                 next_state <= FFT1_RESET;
            
--             when FFT1_RESET =>
--                 transpose_enable <= '0';
--                 fft_real_in <= transpose_real_out;
--                 fft_imag_in <= transpose_imag_out;
--                 fft_reset <= '1';
--                 fft_enable <= '1';
--                 next_state <= FAKE1;
            
--             when FAKE1 =>
--                 next_state <= FFT1;

--             when FFT1 =>
--                 fft_reset <= '0';
--                 if fft_done  = '1' then
--                     next_state <= TRANSPOSE1;
--                 else
--                     next_state <= FFT1_P;
--                 end if;
        
--             when FFT1_P =>
--                 fft_reset <= '0';
--                 if fft_done  = '1' then
--                     next_state <= TRANSPOSE1;
--                 else
--                     next_state <= FFT1;
--                 end if;

--             when TRANSPOSE1 =>
--                 transpose_real_in <= fft_real_out;
--                 transpose_imag_in <= fft_imag_out;
--                 transpose_enable <= '1';
--                 next_state <= FFT2_RESET;
            
--             when FFT2_RESET => 
--                 transpose_enable <= '0';
--                 fft_real_in <= transpose_real_out;
--                 fft_imag_in <= transpose_imag_out;
--                 fft_reset <= '1';
--                 fft_enable <= '1';
--                 next_state <= FAKE;
            
--             when FAKE => 
--                 next_state <= FFT2;

--             when FFT2 =>
--                 fft_reset <= '0';
--                 if fft_done  = '1' then
--                     output_array_real <= fft_real_out;
--                     output_array_imag <= fft_imag_out;
--                     next_state <= IDLE;
--                     done <= '1';
--                 else
--                     next_state <= FFT2_P;
--                 end if;

--             when FFT2_P =>
--                 fft_reset <= '0';
--             if fft_done  = '1' then
--                 output_array_real <= fft_real_out;
--                 output_array_imag <= fft_imag_out;
--                 next_state <= IDLE;
--                 done <= '1';
--             else
--                 next_state <= FFT2;
--             end if;
--         end case;

        
--     end process ; -- next_state_logic

-- end arch ; -- arch  

  