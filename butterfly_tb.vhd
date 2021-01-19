library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity butterfly_tb is
end entity;

architecture bt_tb of butterfly_tb is
    component butterfly is
        generic(bitWidth : integer := 18);
        port (
            clk : in std_logic;
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
        );
    end component butterfly;
    signal wordlength : integer := 15;
    signal clk : std_logic := '0';
    signal in1_re,in1_img,in2_re,in2_img,coeff_re,coeff_img,out1_re,out1_img,out2_re,out2_img : std_logic_vector(wordlength-1 downto 0);
begin

    dut : butterfly generic map (wordlength) port map(clk,in1_re,in1_img,in2_re,in2_img,coeff_re,coeff_img,out1_re,out1_img,out2_re,out2_img);
    clk <= not(clk) after 10 ns;
    test2 : process 
    begin
  
        report "start";
        --First Stage
        in1_re <= std_logic_vector(to_signed(-900,wordlength));
        in1_img <= std_logic_vector(to_signed(800,wordlength));
        in2_re <= std_logic_vector(to_signed(-500,wordlength));
        in2_img <= std_logic_vector(to_signed(400,wordlength));
        coeff_re <= std_logic_vector(to_signed(100,wordlength));
        coeff_img <= std_logic_vector(to_signed(0,wordlength));
        wait on clk;
        in1_re <= std_logic_vector(to_signed(-800,wordlength));
        in1_img <= std_logic_vector(to_signed(700,wordlength));
        in2_re <= std_logic_vector(to_signed(-400,wordlength));
        in2_img <= std_logic_vector(to_signed(300,wordlength));
        coeff_re <= std_logic_vector(to_signed(70,wordlength));
        coeff_img <= std_logic_vector(to_signed(-70,wordlength));
        wait on clk;
        in1_re <= std_logic_vector(to_signed(-700,wordlength));
        in1_img <= std_logic_vector(to_signed(600,wordlength));
        in2_re <= std_logic_vector(to_signed(-300,wordlength));
        in2_img <= std_logic_vector(to_signed(200,wordlength));
        coeff_re <= std_logic_vector(to_signed(0,wordlength));
        coeff_img <= std_logic_vector(to_signed(-100,wordlength));
        wait on clk;
        in1_re <= std_logic_vector(to_signed(-600,wordlength));
        in1_img <= std_logic_vector(to_signed(500,wordlength));
        in2_re <= std_logic_vector(to_signed(-200,wordlength));
        in2_img <= std_logic_vector(to_signed(100,wordlength));
        coeff_re <= std_logic_vector(to_signed(-70,wordlength));
        coeff_img <= std_logic_vector(to_signed(-70,wordlength));
        wait on clk;
        --second stage
        in1_re <= std_logic_vector(to_signed(-1400,wordlength));
        in1_img <= std_logic_vector(to_signed(1200,wordlength));
        in2_re <= std_logic_vector(to_signed(-1000,wordlength));
        in2_img <= std_logic_vector(to_signed(800,wordlength));
        coeff_re <= std_logic_vector(to_signed(100,wordlength));
        coeff_img <= std_logic_vector(to_signed(0,wordlength));
        wait on clk;
        in1_re <= std_logic_vector(to_signed(-1200,wordlength));
        in1_img <= std_logic_vector(to_signed(1000,wordlength));
        in2_re <= std_logic_vector(to_signed(-800,wordlength));
        in2_img <= std_logic_vector(to_signed(600,wordlength));
        coeff_re <= std_logic_vector(to_signed(0,wordlength));
        coeff_img <= std_logic_vector(to_signed(-100,wordlength));
        wait on clk;
        in1_re <= std_logic_vector(to_signed(-400,wordlength));
        in1_img <= std_logic_vector(to_signed(400,wordlength));
        in2_re <= std_logic_vector(to_signed(400,wordlength));
        in2_img <= std_logic_vector(to_signed(400,wordlength));
        coeff_re <= std_logic_vector(to_signed(100,wordlength));
        coeff_img <= std_logic_vector(to_signed(0,wordlength));
        wait on clk;
        in1_re <= std_logic_vector(to_signed(0,wordlength));
        in1_img <= std_logic_vector(to_signed(560,wordlength));
        in2_re <= std_logic_vector(to_signed(560,wordlength));
        in2_img <= std_logic_vector(to_signed(0,wordlength));
        coeff_re <= std_logic_vector(to_signed(0,wordlength));
        coeff_img <= std_logic_vector(to_signed(-100,wordlength));
        wait on clk;
        --third stage
        in1_re <= std_logic_vector(to_signed(-2400,wordlength));
        in1_img <= std_logic_vector(to_signed(2000,wordlength));
        in2_re <= std_logic_vector(to_signed(-2000,wordlength));
        in2_img <= std_logic_vector(to_signed(1600,wordlength));
        coeff_re <= std_logic_vector(to_signed(100,wordlength));
        coeff_img <= std_logic_vector(to_signed(0,wordlength));
        wait on clk;
        in1_re <= std_logic_vector(to_signed(-400,wordlength));
        in1_img <= std_logic_vector(to_signed(400,wordlength));
        in2_re <= std_logic_vector(to_signed(400,wordlength));
        in2_img <= std_logic_vector(to_signed(400,wordlength));
        coeff_re <= std_logic_vector(to_signed(100,wordlength));
        coeff_img <= std_logic_vector(to_signed(0,wordlength));
        wait on clk;
        in1_re <= std_logic_vector(to_signed(0,wordlength));
        in1_img <= std_logic_vector(to_signed(800,wordlength));
        in2_re <= std_logic_vector(to_signed(500,wordlength));
        in2_img <= std_logic_vector(to_signed(500,wordlength));
        coeff_re <= std_logic_vector(to_signed(100,wordlength));
        coeff_img <= std_logic_vector(to_signed(0,wordlength));
        wait on clk;
        in1_re <= std_logic_vector(to_signed(-800,wordlength));
        in1_img <= std_logic_vector(to_signed(0,wordlength));
        in2_re <= std_logic_vector(to_signed(500,wordlength));
        in2_img <= std_logic_vector(to_signed(500,wordlength));
        coeff_re <= std_logic_vector(to_signed(100,wordlength));
        coeff_img <= std_logic_vector(to_signed(0,wordlength));
        wait;
    
    end process ; -- test2



end bt_tb ;  
    