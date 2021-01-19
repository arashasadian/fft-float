-- library ieee;
-- use ieee.std_logic_1164.all;
-- use ieee.float_pkg.all;
-- library work;
-- use work.fftpackage.all;
-- use ieee.numeric_std.all;


-- entity filter is
--     generic ( ROWS : integer ; COLS : integer );
--     port (
--       enable : in std_logic;
--       buffer_real_in  : in array_2d_float(ROWS-1 downto 0)(COLS-1 downto 0);
--       buffer_imag_in  : in array_2d_float(ROWS-1 downto 0)(COLS-1 downto 0);
--       buffer_real_out : out array_2d_float(COLS-1 downto 0)(ROWS-1 downto 0);
--       buffer_imag_out : out array_2d_float(COLS-1 downto 0)(ROWS-1 downto 0)
--     ) ;
-- end filter;


-- architecture arch of filter is
 
--     begin
--        process(enable) begin
--         if rising_edge(enable) then
--             for i in 0 to ROWS-1 loop
--                 for j in 0 to COLS-1 loop
--                     if (buffer_real_in >= THRESHOLD) then
--                         buffer_real_out(j)(i) <= to_float(0);
--                     else
--                         buffer_real_out(j)(i) <= buffer_real_in(i)(j);
--                     end if;
--                     if (buffer_imag_in >= THRESHOLD) then
--                         buffer_imag_out(j)(i) <= to_float(0);
--                     else
--                         buffer_imag_out(j)(i) <= buffer_imag_in(i)(j);
--                     end if;
--                 end loop;
--             end loop;
--             -- report("transpose");
--         end if;
--     end process;
-- end arch ; 