library ieee;
use ieee.std_logic_1164.all;
use ieee.float_pkg.all;
library work;
use work.fftpackage.all;
use ieee.numeric_std.all;



entity fft is
  generic ( N : integer := 8; step : integer := 3);
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
    variable flag : integer := 0;
    variable bt_k : integer;

    variable index : std_logic_vector(step-1 downto 0) := "000";
    variable in1   : std_logic_vector(step-1 downto 0) := "000";
    variable in2   : std_logic_vector(step-1 downto 0) := "000";

    begin
      if rising_edge(clk) then
        if input_split_done = '0' then
          if last_index_done <  7 then

            in1 := index;
            index := std_logic_vector(unsigned(index)+1);
            in2 := index;
            index := std_logic_vector(unsigned(index)+1);

            bt_in1_real <= input_array_real(to_integer(unsigned(in1)));
            bt_in1_imag <= input_array_imag(to_integer(unsigned(in1)));
            bt_in2_real <= input_array_real(to_integer(unsigned(in2)));
            bt_in2_imag <= input_array_imag(to_integer(unsigned(in2)));

            bt_coef_real  <= to_float(1);
            bt_coef_imag <= to_float(0);
            
            report "1.The value of 'in1' is " & integer'image(to_integer(unsigned(in1)));
            report "2.The value of 'in2 is" & integer'image(to_integer(unsigned(in2)));

            
          else
            input_split_done <= '1';
            last_index_done := 0;
            index := "000";
            flag := 1;
          end if;
      elsif input_split_done = '1' and middle_done = '0'then
          if last_index_done < 8 then
            flag := 0;
            
            in1 := index(1) & index(0) & index(step-1 downto 2);
            index := std_logic_vector(unsigned(index)+1);
            in2 := index(1) & index(0) & index(step-1 downto 2);
            index := std_logic_vector(unsigned(index)+1);

            
            
            bt_in1_real <= middle_real(to_integer(unsigned(in1)));
            bt_in1_imag <= middle_imag(to_integer(unsigned(in1)));
            bt_in2_real <= middle_real(to_integer(unsigned(in2)));
            bt_in2_imag <= middle_imag(to_integer(unsigned(in2)));

            report "3.The value of 'in1' is " & integer'image(to_integer(unsigned(in1)));
            report "4.The value of 'in2 is" & integer'image(to_integer(unsigned(in2)));
    
            if to_integer(unsigned(in1)) mod 2 = 0 then
              bt_coef_real <= to_float(1);
              bt_coef_imag <= to_float(0);
                  
            else
              bt_coef_real <= to_float(0);
              bt_coef_imag <= to_float(-1);
            end if;
            
          else
            middle_done <= '1';
            last_index_done := 0;
            flag := 1;
            index := "000";
          end if;
      elsif (input_split_done = '1' and middle_done ='1' and final_done = '0') then
        if last_index_done <  8 then
          flag := 0;

          in1 := index(0) & index(step-1 downto 1);
            index := std_logic_vector(unsigned(index)+1);
            in2 := index(0) & index(step-1 downto 1);
            index := std_logic_vector(unsigned(index)+1);

          report "5.The value of 'in1' is " & integer'image(to_integer(unsigned(in1)));
          report "6.The value of 'in2 is" & integer'image(to_integer(unsigned(in2)));

          bt_in1_real <= middle2_real(to_integer(unsigned(in1)));
          bt_in1_imag <= middle2_imag(to_integer(unsigned(in1)));
          bt_in2_real <= middle2_real(to_integer(unsigned(in2)));
          bt_in2_imag <= middle2_imag(to_integer(unsigned(in2)));
    
          bt_coef_real <= to_float(1) when to_integer(unsigned(in1)) = 0 else to_float(0.707107)
              when to_integer(unsigned(in1)) = 1 else to_float(0) when to_integer(unsigned(in1)) = 2 else to_float(-0.707107);
                
          bt_coef_imag <= to_float(0) when to_integer(unsigned(in1)) = 0 else to_float(-0.707107)
              when to_integer(unsigned(in1)) = 1 else to_float(-1) when to_integer(unsigned(in1)) = 2 else to_float(-0.707107);

          
        else
          final_done <= '1';
          last_index_done := 0;
          flag := 1;
        end if;
      end if;
      elsif falling_edge(clk) then
        if input_split_done = '0' then
          if last_index_done < 7 then
            middle_real(to_integer(unsigned(in1))) <= bt_out1_real;
            middle_imag(to_integer(unsigned(in1))) <= bt_out1_imag;
            middle_real(to_integer(unsigned(in2))) <= bt_out2_real;
            middle_imag(to_integer(unsigned(in2))) <= bt_out2_imag;

            last_index_done := last_index_done + 2;
            
          end if;
        elsif input_split_done = '1' and middle_done = '0' and flag = 0 then
          if last_index_done < 8 then
            middle2_real((to_integer(unsigned(in1)))) <= bt_out1_real;
            middle2_imag((to_integer(unsigned(in1)))) <= bt_out1_imag;
            middle2_real((to_integer(unsigned(in2)))) <= bt_out2_real;
            middle2_imag((to_integer(unsigned(in2)))) <= bt_out2_imag;
            
            last_index_done := last_index_done + 2;
          end if;
        elsif input_split_done = '1' and middle_done = '1' and final_done = '0' and flag = 0 then
          if last_index_done <  8 then
              output_array_real(to_integer(unsigned(in1))) <= bt_out1_real;
              output_array_imag(to_integer(unsigned(in1))) <= bt_out1_imag;
              output_array_real(to_integer(unsigned(in2))) <= bt_out2_real;
              output_array_imag(to_integer(unsigned(in2))) <= bt_out2_imag;

            
            last_index_done := last_index_done + 2;
          end if;

        end if;

      end if;
  end process ; -- calculate_bt_inputs

  done <= final_done;

end architecture arch;