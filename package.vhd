library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package fftpackage is
    constant PI : integer := 180;
    constant TwoPI : integer := 360;
    constant ROWS, COLS : integer := 16;
    constant STEP : integer := 4;

    constant bitWidth : integer := 32;

    type array_of_slv is array (COLS-1 downto 0) of std_logic_vector(bitWidth-1 downto 0);
    type array_2d_slv is array (ROWS-1 downto 0) of array_of_slv;
    type array_of_slv_s is array (360 downto 0) of std_logic_vector(bitWidth-1 downto 0);

    type fft_state is (RESET_STATE, IDLE, INIT, INIT2, BUSY1, BUSY2);
    type fft2d_state is (IDLE ,FFT_RESET, FAKE, FFT_BUSY, FFT_P, FFT_DONE);

    signal image_real, image_imag, image_real_out, image_imag_out : array_2d_slv;
   
    signal fft_real_in, fft_imag_in, fft_real_out, fft_imag_out : array_of_slv;

    signal middle_real, middle_imag : array_of_slv;
    signal sin_rom, cos_rom : array_of_slv_s;



  component trigo is
      port (enable : in std_logic);
  end component;


  component shift_register is
      generic(capacity : integer);
      port(
        clk : in  std_logic;
        reset : in  std_logic;
        d_in : in std_logic_vector(31 downto 0);
        dout: out  std_logic_vector(31 downto 0)
      );
  end component;

  component stage is
      generic (size : integer ; bitWidth : integer; two_power : integer); 
      port (
        clk : in std_logic;
        reset: in std_logic;
        input_index : in std_logic_vector(STEP-1 downto 0);
        bt1_input_real : in std_logic_vector(bitWidth-1 downto 0);
        bt1_input_imag : in std_logic_vector(bitWidth-1 downto 0);  
        output_index : out std_logic_vector(STEP-1 downto 0);
        bt1_output_real : out std_logic_vector(bitWidth-1 downto 0);
        bt1_output_imag : out std_logic_vector(bitWidth-1 downto 0);
        ready : out std_logic
    );
  end component;

  component last_stage is
    generic (size : integer ; bitWidth : integer; two_power : integer);
    port (
        clk : in std_logic;
        reset: in std_logic;
        input_index : in std_logic_vector(31 downto 0);
        bt1_input_real : in std_logic_vector(bitWidth-1 downto 0);
        bt1_input_imag : in std_logic_vector(bitWidth-1 downto 0);  
        output1_index : out std_logic_vector(31 downto 0);
        output2_index : out std_logic_vector(31 downto 0);
        bt1_output_real : out std_logic_vector(bitWidth-1 downto 0);
        bt1_output_imag : out std_logic_vector(bitWidth-1 downto 0);
        bt2_output_real : out std_logic_vector(bitWidth-1 downto 0);
        bt2_output_imag : out std_logic_vector(bitWidth-1 downto 0)
    );
end component;


  component fft_pipeline is
    generic ( COLS : integer := 8; step : integer := 3);
    port (
      clk : in std_logic;
      reset : in std_logic;
      done : out std_logic
    ) ;
  end component;

  component fft_pipeline_generic is
    generic ( COLS : integer := 8; step : integer := 3);
    port (
      clk : in std_logic;
      reset : in std_logic;
      done : out std_logic
    ) ;
  end component fft_pipeline_generic;

    component butterfly is
      generic(bitWidth : integer := 32);
      port (
        clk : in std_logic;
        en : in std_logic;
        input1_real : in std_logic_vector(bitWidth-1 downto 0);
        input1_imag : in std_logic_vector(bitWidth-1 downto 0);
        input2_real : in std_logic_vector(bitWidth-1 downto 0);
        input2_imag : in std_logic_vector(bitWidth-1 downto 0);
        coefficient_real : in std_logic_vector(bitWidth-1 downto 0);
        coefficient_imag : in std_logic_vector(bitWidth-1 downto 0);
        output1_real : out std_logic_vector(bitWidth-1 downto 0);
        output1_imag : out std_logic_vector(bitWidth-1 downto 0);
        output2_real : out std_logic_vector(bitWidth-1 downto 0);
        output2_imag : out std_logic_vector(bitWidth-1 downto 0)
      ) ;
    end component butterfly;

      component fft is
        generic ( N : integer := 8; step : integer := 3);
        port (
          clk : in std_logic;
          reset : in std_logic;
          done : out std_logic
        ) ;
      end component fft;


    component fft2d is
      generic ( ROWS : integer ; COLS : integer );
      port (
      clk : in std_logic;
      reset : in std_logic;
      enable : in std_logic;
      done : out std_logic
    ) ;
    end component fft2d;

    
 
end package fftpackage;

package body fftpackage is 
  



end package body fftpackage;