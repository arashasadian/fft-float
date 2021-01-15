library ieee;
use ieee.std_logic_1164.all;
use ieee.float_pkg.all;
library work;
use work.fftpackage.all;
use ieee.numeric_std.all;

entity ifft2d is
    generic ( ROWS : integer ; COLS : integer );
    port (
      clk : in std_logic;
      reset : in std_logic;
      enable : in std_logic;
      input_array_real : in array_2d_float(ROWS-1 downto 0)(COLS-1 downto 0);
      input_array_imag : in array_2d_float(ROWS-1 downto 0)(COLS-1 downto 0);
      output_array_real : out array_2d_float(ROWS-1 downto 0)(COLS-1 downto 0);
      output_array_imag : out array_2d_float(ROWS-1 downto 0)(COLS-1 downto 0);
      done : out std_logic
    ) ;
end ifft2d;

architecture arch of ifft2d is

    signal current_state, next_state : fft2d_state := FFT1_RESET;

    signal fft_real_in, fft_imag_in, fft_real_out, fft_imag_out : array_2d_float(ROWS-1 downto 0)(COLS-1 downto 0);
    signal transpose_real_in, transpose_imag_in, transpose_real_out, transpose_imag_out : array_2d_float(ROWS-1 downto 0)(COLS-1 downto 0);
    signal fft_reset, fft_enable, fft_done : std_logic;

    signal transpose_enable : std_logic := '0' ;

begin
    fft_module : ifft_top generic map(ROWS, COLS) port map(clk, fft_reset, fft_enable, fft_real_in, fft_imag_in,
                                     fft_real_out, fft_imag_out, fft_done);
    transpose_unit: transpose_matrix generic map(ROWS, COLS) port map(transpose_enable, transpose_real_in, transpose_imag_in, transpose_real_out, transpose_imag_out);
    main_process : process( clk )
    begin
        if reset = '1' then
            current_state <= IDLE;
        else
            current_state <= next_state;
        end if;
    end process ; -- main_process

    next_state_logic : process( current_state )
    begin
        case current_state is
            when IDLE =>
                if enable = '1' then
                    next_state <= TRANSPOSE;
                    done <= '0';
                else
                    next_state <= IDLE;
                end if;
            
            when TRANSPOSE =>
                transpose_real_in <= input_array_real;
                transpose_imag_in <= input_array_imag;
                transpose_enable <= '1';
                next_state <= FFT1_RESET;
            
            when FFT1_RESET =>
                transpose_enable <= '0';
                fft_real_in <= transpose_real_out;
                fft_imag_in <= transpose_imag_out;
                fft_reset <= '1';
                fft_enable <= '1';
                next_state <= FAKE1;
            
            when FAKE1 =>
                next_state <= FFT1;

            when FFT1 =>
                fft_reset <= '0';
                if fft_done  = '1' then
                    next_state <= TRANSPOSE1;
                else
                    next_state <= FFT1_P;
                end if;
        
            when FFT1_P =>
                fft_reset <= '0';
                if fft_done  = '1' then
                    next_state <= TRANSPOSE1;
                else
                    next_state <= FFT1;
                end if;

            when TRANSPOSE1 =>
                transpose_real_in <= fft_real_out;
                transpose_imag_in <= fft_imag_out;
                transpose_enable <= '1';
                next_state <= FFT2_RESET;
            
            when FFT2_RESET => 
                transpose_enable <= '0';
                fft_real_in <= transpose_real_out;
                fft_imag_in <= transpose_imag_out;
                fft_reset <= '1';
                fft_enable <= '1';
                next_state <= FAKE;
            
            when FAKE => 
                next_state <= FFT2;

            when FFT2 =>
                fft_reset <= '0';
                if fft_done  = '1' then
                    output_array_real <= fft_real_out;
                    output_array_imag <= fft_imag_out;
                    next_state <= IDLE;
                    done <= '1';
                else
                    next_state <= FFT2_P;
                end if;

            when FFT2_P =>
                fft_reset <= '0';
            if fft_done  = '1' then
                output_array_real <= fft_real_out;
                output_array_imag <= fft_imag_out;
                next_state <= IDLE;
                done <= '1';
            else
                next_state <= FFT2;
            end if;
        end case;

        
    end process ; -- next_state_logic

end arch ; -- arch  

  