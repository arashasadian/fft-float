
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.fftpackage.all;
use ieee.numeric_std.all;


entity fft_pipeline_generic is
  generic ( COLS : integer := 8; step : integer := 3);
  port (
    clk : in std_logic;
    enable : in std_logic;
    reset : in std_logic;
    done : out std_logic
  ) ;
end fft_pipeline_generic;



architecture gen_arch of fft_pipeline_generic is

    type indexes_array is array (step downto 0) of std_logic_vector(step-1 downto 0);
    type data_array is array (step downto 0) of std_logic_vector(bitWidth-1 downto 0);
    type consts_array is array (step-1 downto 0) of integer;
    signal indexes : indexes_array;
    signal reals, imags : data_array;
    signal readys : std_logic_vector(step-1 downto 0);
signal rom_sizes: consts_array := (1, 2 , 4 , 8 , 16, 32, 64, 128, 256);
    signal rom_powers: consts_array := ( 512,256, 128, 64, 32, 16,8,4, 2);
    signal stage_enable : std_logic := '0';



begin


    gen_stages : for i in 0 to step-1 generate
        stage_module : stage generic map(rom_sizes(i) , bitWidth, rom_powers(i)) 
          port map(clk, reset, stage_enable, indexes(i), reals(i), imags(i),  indexes(i+1),reals(i+1), imags(i+1), readys(i));
    end generate;

    process(clk)

    variable index, filling_index : integer := 0;
    variable last_index : std_logic_vector(STEP-1 downto 0);
    variable temp_last_stage_index : std_logic_vector(STEP-1 downto 0);

      begin
        if rising_edge(clk) then
          if reset = '1' then
            index := 0;
            last_index := indexes(step);
            filling_index := 0;
            indexes(0)  <= std_logic_vector(to_signed(-1,STEP));
            reals(0)    <= std_logic_vector(to_signed(-1,bitWidth));
            imags(0)    <= std_logic_vector(to_signed(-1,bitWidth));
            stage_enable <= '0';
            done <= '0';
          elsif enable = '1' then
            stage_enable <= '1';
            if readys(step-1) /= '0' and last_index /= indexes(step) then
              last_index := indexes(step);
              if filling_index < COLS then
                for i in 0 to step-1 loop
                  temp_last_stage_index(step - 1 - i) := indexes(step)(i);
                end loop;
                fft_real_out(to_integer(unsigned(temp_last_stage_index))) <= reals(step);
                fft_imag_out(to_integer(unsigned(temp_last_stage_index))) <= imags(step);
                filling_index := filling_index + 1;
                if(filling_index = COLS) then
                  done <= '1';
                end if;
              end if;
            end if;
            if index < COLS then
              indexes(0) <= std_logic_vector(to_signed(index,STEP));
              reals(0) <= fft_real_in(index);
              imags(0) <= fft_imag_in(index);
              index := index + 1;
            end if;
          else
            indexes(0)  <= std_logic_vector(to_signed(-1,STEP));
            reals(0)    <= std_logic_vector(to_signed(-1,bitWidth));
            imags(0)    <= std_logic_vector(to_signed(-1,bitWidth));
            done <= '0';
            stage_enable <= '0';
          end if;
        end if;
    end process;


end architecture;