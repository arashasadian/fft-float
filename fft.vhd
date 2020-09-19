library ieee;
use ieee.std_logic_1164.all;
use ieee.float_pkg.all;
library work;
use work.fftpackage.all;



entity fft is
  generic ( N : integer := 8);
  port (
    clk : in std_logic;
    input_array_real : in array_of_float32(N - 1 downto 0);
    input_array_imag : in array_of_float32(N - 1 downto 0);
    output_array_real : out array_of_float32(N - 1 downto 0);
    output_array_imag : out array_of_float32(N - 1 downto 0);
    done : out std_logic
  ) ;
end fft;

architecture arch of fft is
    signal bt_in1_imag, bt_in1_real, bt_in2_imag, bt_in2_real : float32;
    signal bt_out1_imag, bt_out1_real, bt_out2_imag, bt_out2_real : float32;
    signal bt_coef_imag, bt_coef_real : float32;
    signal middle_real, middle_imag : array_of_float32(N - 1 downto 0);
    signal middle2_real, middle2_imag : array_of_float32(N - 1 downto 0);

    signal middle_done : std_logic := '0';
    signal input_split_done : std_logic := '0';
    signal final_done : std_logic := '0';

    begin
    butterfly_module : butterfly port map(clk, bt_in1_real, bt_in1_imag, bt_in2_real, bt_in2_imag,
        bt_coef_real, bt_coef_imag, bt_out1_real, bt_out1_imag, bt_out2_real, bt_out2_imag);

    calculate_bt_inputs : process( clk)
    variable last_index_done : integer := 0;
    variable bt_k : integer;
    begin
      if rising_edge(clk) then
        if input_split_done = '0' then
          if last_index_done <  7 then

            bt_in1_real <= input_array_real(input_index_rom(last_index_done));
            bt_in1_imag <= input_array_imag(input_index_rom(last_index_done));
            bt_in2_real <= input_array_real(input_index_rom(last_index_done + 1));
            bt_in2_imag <= input_array_imag(input_index_rom(last_index_done + 1));

            bt_coef_real  <= to_float(1);
            bt_coef_imag <= to_float(0);
            if(last_index_done >= 4) then
              middle_real(input_index_rom(last_index_done)) <= bt_out1_real;
              middle_imag(input_index_rom(last_index_done)) <= bt_out1_imag;
              middle_real(input_index_rom(last_index_done + 1)) <= bt_out2_real;
              middle_imag(input_index_rom(last_index_done + 1)) <= bt_out2_imag;
            end if;
            
            last_index_done := last_index_done + 2;

          else
            input_split_done <= '1';
            last_index_done := 0;
          end if;
        end if;

        if input_split_done = '1' and middle_done = '0'then
          if last_index_done < 8 then
            bt_in1_real <= middle_real(middle_index_rom(last_index_done));
            bt_in1_imag <= middle_imag(middle_index_rom(last_index_done));
            bt_in2_real <= middle_real(middle_index_rom(last_index_done + 1));
            bt_in2_imag <= middle_imag(middle_index_rom(last_index_done + 1));

            if middle_index_rom(last_index_done) < 4 then
              bt_coef_real <= to_float(1);
              bt_coef_imag <= to_float(0);
              
            else
              bt_coef_real <= to_float(0.707107);
              bt_coef_imag <= to_float(0.707107);
            end if;

            middle2_real(last_index_done) <= bt_out1_real;
            middle2_imag(last_index_done) <= bt_out1_imag;
            middle2_real(last_index_done + 1) <= bt_out2_real;
            middle2_imag(last_index_done + 1) <= bt_out2_imag;
            
            

            
            last_index_done := last_index_done + 2;
          else
            middle_done <= '1';
            last_index_done := 0;
          end if;
        end if;

        if input_split_done = '1' and middle_done = '1' and final_done = '0' then
          if last_index_done <  8 then
            bt_in1_real <= middle2_real(output_index_rom(last_index_done));
            bt_in1_imag <= middle2_imag(output_index_rom(last_index_done));
            bt_in2_real <= middle2_real(output_index_rom(last_index_done + 1));
            bt_in2_imag <= middle2_imag(output_index_rom(last_index_done + 1));

            bt_coef_real <= to_float(1) when output_index_rom(last_index_done) = 0 else to_float(0.707107)
              when output_index_rom(last_index_done) = 1 else to_float(0) when output_index_rom(last_index_done) = 2 else to_float(-0.707107);
            
            bt_coef_imag <= to_float(0) when output_index_rom(last_index_done) = 0 else to_float(0.707107)
              when output_index_rom(last_index_done) = 1 else to_float(1) when output_index_rom(last_index_done) = 2 else to_float(0.707107);
            
              output_array_real(output_index_rom(last_index_done)) <= bt_out1_real;
              output_array_imag(output_index_rom(last_index_done)) <= bt_out1_imag;
              
              output_array_real(output_index_rom(last_index_done + 1)) <= bt_out2_real;
              output_array_imag(output_index_rom(last_index_done + 1)) <= bt_out2_imag;

            
            last_index_done := last_index_done + 2;
          else
            final_done <= '1';
            last_index_done := 0;
          end if;
        end if;
    end if;
  end process ; -- calculate_bt_inputs

  done <= final_done;

end architecture arch;