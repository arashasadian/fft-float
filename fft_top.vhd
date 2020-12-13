library ieee;
use ieee.std_logic_1164.all;
use ieee.float_pkg.all;
library work;
use work.fftpackage.all;
use ieee.numeric_std.all;


entity fft_top is
    generic ( ROWS : integer; COLS : integer);
    port (
      clk : in std_logic;
      reset : in std_logic;
      enable : in std_logic;
      buffer_real_in  : in array_2d_float(ROWS-1 downto 0)(COLS-1 downto 0);
      buffer_imag_in  : in array_2d_float(ROWS-1 downto 0)(COLS-1 downto 0);
      buffer_real_out : out array_2d_float(ROWS-1 downto 0)(COLS-1 downto 0);
      buffer_imag_out : out array_2d_float(ROWS-1 downto 0)(COLS-1 downto 0);
      done : out std_logic
    ) ;
end fft_top;

architecture arch of fft_top is
    
    signal current_state, next_state : fft_state := IDLE;
    signal fft_reset, fft_done : std_logic;
    signal index : integer := 0;
    signal re_in, im_in, re_out, im_out : array_of_float32(COLS -1 downto 0) := (others => to_float(0));
    begin
    fft_module: fft generic map(ROWS, STEP) port map(clk, fft_reset, re_in, im_in, re_out, im_out, fft_done);
    main_process : process( clk )
    begin
        if reset = '1' then
            current_state <= RESET_STATE;
        else
            current_state <= next_state;
        end if;
    end process ; -- main_process
    
    next_state_logic : process( current_state )
    begin
        case current_state is
            when RESET_STATE =>
                index <= 0;
                next_state <= IDLE;
            when IDLE => 
                if enable = '1' then
                    if done /= '1' then
                        for i in 0 to COLS-1 loop
                            re_in(i) <= buffer_real_in(index)(i);
                            im_in(i) <= buffer_imag_in(index)(i);
                        end loop;
                        next_state <= INIT;
                        fft_reset <= '1';
                    else
                        next_state <= IDLE;
                    end if;
                else
                    next_state <= IDLE;
                end if;
            when INIT =>
                if fft_done = '1' then
                    next_state <= INIT2;
                else
                    next_state <= BUSY1;
                    fft_reset <= '0';
                end if;
            when INIT2 =>
                if fft_done = '1' then
                    next_state <= INIT;
                else
                    next_state <= BUSY1;
                    fft_reset <= '0';
                end if;
            when BUSY1 =>
                if fft_done = '1' then
                    buffer_real_out(index) <= re_out;
                    buffer_imag_out(index) <= im_out;
                    next_state <= IDLE;
                    index <= index + 1;
                else
                    next_state <= BUSY2;
                end if;
            when BUSY2 =>
            if fft_done = '1' then
                buffer_real_out(index) <= re_out;
                buffer_imag_out(index) <= im_out;
                next_state <= IDLE;
                index <= index + 1;
            else
                next_state <= BUSY1;
            end if;
        end case;
    end process ; -- next_state_logic
         
    done <= '1' when index = ROWS else '0';
    -- fft_done <= '1';
end architecture arch;