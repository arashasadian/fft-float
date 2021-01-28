library ieee;
use ieee.std_logic_1164.all;
library work;
use work.fftpackage.all;
use ieee.numeric_std.all;


entity fft_pipeline is
  generic ( COLS : integer := 8; step : integer := 3);
  port (
    clk : in std_logic;
    reset : in std_logic;
    done : out std_logic
  ) ;
end fft_pipeline;

architecture pipeline_arch of fft_pipeline is

  signal st1_in_real, st1_in_imag, st1_din, st1_dout, st1_out_real, st1_out_imag : std_logic_vector(bitWidth-1 downto 0);
  signal st2_dout, st2_out_real, st2_out_imag : std_logic_vector(bitWidth-1 downto 0);  
  signal st3_dout,st3_out_real,st3_out_imag : std_logic_vector(bitWidth-1 downto 0);  

begin
    stage_module1 : stage generic map(4, 32, 2) port map(clk, reset, st1_din, st1_in_real, st1_in_imag, st1_dout,st1_out_real, st1_out_imag);
    stage_module2 : stage generic map(2, 32, 4) port map(clk, reset, st1_dout, st1_out_real, st1_out_imag, st2_dout,st2_out_real, st2_out_imag);
    stage_module3 : stage generic map(1, 32, 8) port map(clk, reset, st2_dout, st2_out_real,st2_out_imag, st3_dout, st3_out_real, st3_out_imag);
    process(clk) 
    variable index, filling_index : integer := 0;
    variable last_index : std_logic_vector(31 downto 0);
    begin  
      if(rising_edge(clk)) then
        if(reset = '1') then
          index := 0;
          last_index := st3_dout;
          filling_index := 0;
          st1_din <= std_logic_vector(to_signed(-1,32));
          st1_in_real <= std_logic_vector(to_signed(-1,32));
          st1_in_imag <= std_logic_vector(to_signed(-1,32));
        else
          if to_integer(signed(st3_dout)) /= -1 and last_index /= st3_dout then
            last_index := st3_dout;
            if filling_index < COLS then
              fft_real_out(to_integer(signed(st3_dout))) <= st3_out_real;
              fft_imag_out(to_integer(signed(st3_dout))) <= st3_out_imag;
              filling_index := filling_index + 1;
              if(filling_index = COLS) then
                done <= '1';
              end if;
            end if;
          end if;
          if index < COLS then
            st1_din <= std_logic_vector(to_signed(index,bitWidth));
            st1_in_real <= fft_real_in(index);
            st1_in_imag <= fft_imag_in(index);
            index := index + 1;
          end if;
        end if;
      end if;
    end process;
end pipeline_arch;