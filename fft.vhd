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
    reset : in std_logic;
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
  signal final_done, init_done, last_level : std_logic := '0';
  signal clk_cycles : integer := 0;
  begin

    butterfly_module : butterfly port map(clk, bt_in1_real, bt_in1_imag, bt_in2_real, bt_in2_imag,
      bt_coef_real, bt_coef_imag, bt_out1_real, bt_out1_imag, bt_out2_real, bt_out2_imag);
    
    main_process : process( clk, reset )
      variable current_step : integer := 0;
      variable i : integer := 0;
      variable last_index_done : integer := 0;
      variable index : std_logic_vector(step-1 downto 0) := (others => '0');
      variable in1   : std_logic_vector(step-1 downto 0) := (others => '0');
      variable in2   : std_logic_vector(step-1 downto 0) := (others => '0');
      variable in1_temp   : std_logic_vector(step-1 downto 0) := (others => '0');
      variable in2_temp   : std_logic_vector(step-1 downto 0) := (others => '0');
      variable temp_index : std_logic_vector(step-1 downto 0) := (others => '0');
      variable init_i : integer := 0;
      variable degree : integer;
      variable k : integer := 0;
      variable two_power : integer := 2;

      variable base_index : integer := 0;
      variable marked : std_logic_vector(N-1 downto 0);
      begin
        if rising_edge(clk) then
          if reset = '1' then
            final_done <= '0';
            init_done <= '0';
            last_index_done := 0;
            current_step := 0;
            i := 0;
            init_i := 0;
            k := 0;
            last_level <= '0';
            two_power := 2;
            base_index := 0;
            in1 := (others => '0');
            in2 := (others => '0');
            in1_temp := (others => '0');
            in2_temp := (others => '0');
           clk_cycles <= clk_cycles + 1;
          --  report "elapsed clock cycles : " & integer'image(clk_cycles);
          elsif init_done = '0' then
            if init_i < N then
              middle_real(init_i) <= input_array_real(init_i);
              middle_imag(init_i) <= input_array_imag(init_i);
              init_i := init_i + 1;
            end if;

          else
            if (i < step) then

              if (last_index_done < N ) then
                
                --report "base_index   : " & integer'image(base_index);

                in1 := std_logic_vector(to_unsigned(base_index, in1'length));
                marked(base_index) := '1';
                in2 := std_logic_vector(to_unsigned(base_index + N/two_power,in2'length));
                marked(to_integer(unsigned(in2))) := '1';
                
                while marked(base_index) = '1' loop
                  base_index := base_index + 1;
                  if base_index > N - 1 then
                    exit;
                  end if;
                end loop; 

                --report "in1   : " & integer'image(to_integer(unsigned(in1)));
                --report "in2   : " & integer'image(to_integer(unsigned(in2)));
                
                bt_in1_real <= middle_real(to_integer(unsigned(in1)));
                bt_in1_imag <= middle_imag(to_integer(unsigned(in1)));
                bt_in2_real <= middle_real(to_integer(unsigned(in2)));
                bt_in2_imag <= middle_imag(to_integer(unsigned(in2)));

                -- calculating degree
                
                
                
                -- report "in1 = " & integer'image(to_integer(unsigned(in1)));
                -- report "in2 = " & integer'image(to_integer(unsigned(in2)));

                -- report "degree = " & integer'image(degree);
                -- report "2pi - degree = " & integer'image((TwoPI-degree) mod TwoPI);
                
                

                -- report "current step = " & integer'image(current_step);

                if k >= N / two_power then
                  k := 0;
                end if;

                degree := -1 * k * two_power * TwoPI  /(2* N) ;

                degree := degree mod TwoPI; 
                --report "degree = " & integer'image(degree);
                -- report "k = " & integer'image(k);
                -- report "two_power = " & integer'image(two_power);
                
                k := k+1;
                
                bt_coef_real <= cos_rom(degree);             
                bt_coef_imag <= sin_rom(degree);
              else
              --report "last i  : " & integer'image(last_index_done);
                -- report "==================================";
                last_index_done := -2     ;
                i := i + 1;  
                index := (others => '0');
                current_step := current_step + 1; 
                last_level <= '1' when i = step-1  else last_level;
                k := 0;
                base_index := 0;
                marked := (others => '0');
                two_power := 2 * two_power;
              end if;
            else
              final_done <= '1';
            end if;
          end if;
          else if done /= '1' then
            if init_done /= '0' then
              if last_level /= '1' then
                middle_real((to_integer(unsigned(in1)))) <= bt_out1_real;
                middle_imag((to_integer(unsigned(in1)))) <= bt_out1_imag;
                middle_real((to_integer(unsigned(in2)))) <= bt_out2_real;
                middle_imag((to_integer(unsigned(in2)))) <= bt_out2_imag;
              else
                for i in 0 to step-1 loop
                  in1_temp(step - 1 - i) := in1(i);
                  in2_temp(step - 1 - i) := in2(i);
                end loop;
                -- in1_temp(step - 1 downto 0) := in1;
                -- in2_temp(step - 1 downto 0) := in2;
                -- report "in1_t   : " & integer'image(to_integer(unsigned(in1_temp)));
                -- report "in2_t   : " & integer'image(to_integer(unsigned(in2_temp)));
                output_array_real(to_integer(unsigned(in1_temp))) <= bt_out1_real;
                output_array_imag(to_integer(unsigned(in1_temp))) <= bt_out1_imag;
                output_array_real(to_integer(unsigned(in2_temp))) <= bt_out2_real;
                output_array_imag(to_integer(unsigned(in2_temp))) <= bt_out2_imag;
              end if;
              last_index_done := last_index_done + 2;
            else
              
              init_done <= '1' when init_i = N;

            end if;
            
            end if;        
          end if;
    end process ; -- main_process        

  
  done <= final_done;

end architecture arch;