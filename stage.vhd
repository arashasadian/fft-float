library ieee;
use ieee.std_logic_1164.all;
library work;
use work.fftpackage.all;
use ieee.numeric_std.all;

entity stage is
    generic (size : integer ; bitWidth : integer; two_power : integer);
    port (
        clk : in std_logic;
        reset: in std_logic;
        input_index : in std_logic_vector(31 downto 0);
        bt1_input_real : in std_logic_vector(bitWidth-1 downto 0);
        bt1_input_imag : in std_logic_vector(bitWidth-1 downto 0);  
        output_index : out std_logic_vector(31 downto 0);
        bt1_output_real : out std_logic_vector(bitWidth-1 downto 0);
        bt1_output_imag : out std_logic_vector(bitWidth-1 downto 0)
    );
end entity;

architecture stage_arch of stage is
    signal bt_in1_imag, bt_in1_real, bt_in2_imag, bt_in2_real : std_logic_vector(bitWidth-1 downto 0);
    signal bt_out1_imag, bt_out1_real, bt_out2_imag, bt_out2_real : std_logic_vector(bitWidth-1 downto 0);
    signal bt_coef_imag, bt_coef_real : std_logic_vector(bitWidth-1 downto 0);
    signal enable : std_logic := '0';
    
    
    type shift_register_2d_array is array (size-1 downto 0) of std_logic_vector(31 downto 0);
    type data_array is array (size-1 downto 0) of std_logic_vector(bitWidth-1 downto 0);
    begin
        butterfly_module : butterfly generic map (bitWidth) port map(clk, enable, bt_in1_real, bt_in1_imag, bt_in2_real, bt_in2_imag,
            bt_coef_real, bt_coef_imag, bt_out1_real, bt_out1_imag, bt_out2_real, bt_out2_imag);
        process(clk) 
            variable din, dout : std_logic_vector(31 downto 0);
            variable real_dout, imag_dout : std_logic_vector(bitWidth-1 downto 0);
            variable sr : shift_register_2d_array;
            variable real_array, imag_array : data_array;
            variable degree : integer;
            variable k : integer := 0;
            variable dout_temp, input_index_temp : std_logic_vector(31 downto 0);
            variable bt_index : integer := 0;
            variable flush_index : integer := -1;
            variable bt_remaining : integer := COLS/2;
            variable start : std_logic := '0';
            variable last_index_input : std_logic_vector(31 downto 0) := (std_logic_vector(to_signed(-1,32)));
            variable state : integer := 0;
            variable flush_time : integer := size + (size/2);
        begin
            if rising_edge(clk) then
                if reset = '1' then
                    sr := (others => std_logic_vector(to_signed(-1,32)));
                    real_array := (others => std_logic_vector(to_signed(-1,bitWidth)));
                    imag_array := (others => std_logic_vector(to_signed(-1,bitWidth)));
                    bt_remaining := COLS/2;
                    bt_index := 0;
                    flush_index := -1;
                    k := 0;
                    state := 0;
                    output_index <= std_logic_vector(to_signed(-1,32));
                    bt1_output_real <= std_logic_vector(to_signed(-1,32));
                    bt1_output_imag <= std_logic_vector(to_signed(-1,32));
                    -- degree := 0;
                else
                    if start = '1' then
                        state := 1;
                        for i in size-1 downto 1 loop
                            sr(i) := sr(i-1);
                            real_array(i) := real_array(i-1);
                            imag_array(i):= imag_array(i-1);
                        end loop;
                        sr(0) := std_logic_vector(signed(last_index_input));
                        
                        real_array(0) := bt_out2_real;
                        imag_array(0):= bt_out2_imag;
                        bt1_output_real <= bt_out1_real;
                        bt1_output_imag <= bt_out1_imag;
                        output_index <= dout;
                        start := '0';
                    end if;
                    if  to_integer(signed(sr(size-1))) = -1 and bt_remaining /= 0 then
                        state := 2;
                        for i in size-1 downto 1 loop
                            sr(i) := sr(i-1);
                            real_array(i) := real_array(i-1);
                            imag_array(i):= imag_array(i-1);
                        end loop;
                        sr(0) := std_logic_vector(signed(input_index));
                        real_array(0) := bt1_input_real;
                        imag_array(0):= bt1_input_imag;
                        
                        output_index <= std_logic_vector(to_signed(-1,32));
                        bt1_output_real <= std_logic_vector(to_signed(-1,32));
                        bt1_output_imag <= std_logic_vector(to_signed(-1,32));
                    else
                        if bt_index < size and bt_remaining /= 0 then
                            state := 3;
                            bt_remaining := bt_remaining - 1;
                            bt_index := bt_index + 1;
                            dout := sr(size - 1);
                            real_dout := real_array(size - 1);
                            imag_dout := imag_array(size - 1);
                            
                            bt_in1_real <= real_dout;
                            bt_in1_imag <= imag_dout;
                            bt_in2_real <= bt1_input_real;
                            bt_in2_imag <= bt1_input_imag;
                            if k >= COLS / two_power then
                                k := 0;
                            end if;
                            degree := -1 * k * two_power * TwoPI  /(2* COLS) ;
                            degree := degree mod TwoPI; 
                            k := k+1;
                            
                            bt_coef_real <= cos_rom(degree);             
                            bt_coef_imag <= sin_rom(degree);
                            
                            if last_index_input /= input_index then
                                start := '1';
                                last_index_input := input_index;
                                enable <= not enable;
                            end if;
                        else 
                            if flush_index /= -1 then
                                state := 4;
                                start := '0';
                                if flush_index < flush_time  then
                                    if flush_index < size/2 then
                                        output_index <= std_logic_vector(to_signed(-1,32));
                                        bt1_output_real <= std_logic_vector(to_signed(-1,32));
                                        bt1_output_imag <= std_logic_vector(to_signed(-1,32));
                                    else
                                        output_index <= sr(size-1);
                                        bt1_output_real <= real_array(size-1);
                                        bt1_output_imag <= imag_array(size-1);
                                        for i in size-1 downto 1 loop
                                            sr(i) := sr(i-1);
                                            real_array(i) := real_array(i-1);
                                            imag_array(i):= imag_array(i-1);
                                        end loop;
                                        sr(0) := std_logic_vector(signed(input_index));
                                        real_array(0) := bt1_input_real;
                                        imag_array(0):= bt1_input_imag;
                                    end if;
                                    flush_index := flush_index + 1;
                                    if size /= COLS/2 and flush_index >= flush_time then
                                        if bt_remaining /= 0 then
                                            flush_index := -1;
                                            bt_index := 0;
                                        else
                                            flush_index := -1;
                                            -- output_index <= std_logic_vector(to_signed(-1,32));
                                            -- bt1_output_real <= std_logic_vector(to_signed(-1,32));
                                            -- bt1_output_imag <= std_logic_vector(to_signed(-1,32));
                                        end if;
                                    end if;
                                else
                                    if bt_remaining /= 0 then
                                        flush_index := -1;
                                        bt_index := 0;
                                    else
                                        output_index <= std_logic_vector(to_signed(-1,32));
                                        bt1_output_real <= std_logic_vector(to_signed(-1,32));
                                        bt1_output_imag <= std_logic_vector(to_signed(-1,32));
                                    end if;
                                end if;
                            else
                                flush_index := 0; -- bt output done
                            end if;
                        end if; 
                    end if;
                end if;
            end if;
        end process;

end architecture;