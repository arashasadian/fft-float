library ieee;
use ieee.std_logic_1164.all;
use ieee.float_pkg.all;


package fftpackage is
    type array_of_float32 is array(natural range <>) of float32;
    type array_of_integer is array(natural range <>) of integer;
    component butterfly is
        port (
          clk : in std_logic;
          input1_real : in float32;
          input1_imag : in float32;
          input2_real : in float32;
          input2_imag : in float32;
          coefficient_real : in float32;
          coefficient_imag : in float32;
          output1_real : out float32;
          output1_imag : out float32;
          output2_real : out float32;
          output2_imag : out float32
        ) ;
      end component butterfly;

      component fft is
        generic ( N : integer := 8);
        port (
          clk : in std_logic;
          input_array_real : in array_of_float32(N - 1 downto 0);
          input_array_imag : in array_of_float32(N - 1 downto 0);
          output_array_real : out array_of_float32(N - 1 downto 0);
          output_array_imag : out array_of_float32(N - 1 downto 0);
          done : out std_logic
        ) ;
      end component fft;
    signal middle_index_rom : array_of_integer(7 downto 0);
    signal output_index_rom : array_of_integer(7 downto 0);
    signal input_index_rom : array_of_integer(7 downto 0);
    signal sin_rom, cos_rom : array_of_float32(360 downto 0);

    procedure index_rom_generator (signal enable : in std_logic; 
    signal input_index, mid_index, final_index : inout array_of_integer(7 downto 0));


end package fftpackage;

package body fftpackage is 
  procedure index_rom_generator (signal enable : in std_logic; 
    signal input_index, mid_index, final_index : inout array_of_integer(7 downto 0)) is
    begin
        if rising_edge(enable) then
          input_index(0) <= 0;
          input_index(1) <= 4;
          input_index(2) <= 2;
          input_index(3) <= 6;
          input_index(4) <= 1;
          input_index(5) <= 5;
          input_index(6) <= 3;
          input_index(7) <= 7;

          mid_index(0) <= 0;
          mid_index(1) <= 2;
          mid_index(2) <= 1;
          mid_index(3) <= 3;
          mid_index(4) <= 4;
          mid_index(5) <= 6;
          mid_index(6) <= 5;
          mid_index(7) <= 7;


          final_index(0) <= 0;
          final_index(1) <= 4;
          final_index(2) <= 1;
          final_index(3) <= 5;
          final_index(4) <= 2;
          final_index(5) <= 6;
          final_index(6) <= 3;
          final_index(7) <= 7;

        end if;
  end procedure index_rom_generator;



  procedure trigonometrics_rom_generator (
      signal enable : in std_logic ;
      signal s_rom, c_rom : inout array_of_float32(360 downto 0)
      )is
    begin
      if rising_edge(enable) then 
      s_rom(0) <= to_float(0.000000);
      s_rom(1) <= to_float(0.017452);
      s_rom(2) <= to_float(0.034899);
      s_rom(3) <= to_float(0.052336);
      s_rom(4) <= to_float(0.069756);
      s_rom(5) <= to_float(0.087156);
      s_rom(6) <= to_float(0.104528);
      s_rom(7) <= to_float(0.121869);
      s_rom(8) <= to_float(0.139173);
      s_rom(9) <= to_float(0.156434);
      s_rom(10) <= to_float(0.173648);
      s_rom(11) <= to_float(0.190809);
      s_rom(12) <= to_float(0.207912);
      s_rom(13) <= to_float(0.224951);
      s_rom(14) <= to_float(0.241922);
      s_rom(15) <= to_float(0.258819);
      s_rom(16) <= to_float(0.275637);
      s_rom(17) <= to_float(0.292372);
      s_rom(18) <= to_float(0.309017);
      s_rom(19) <= to_float(0.325568);
      s_rom(20) <= to_float(0.342020);
      s_rom(21) <= to_float(0.358368);
      s_rom(22) <= to_float(0.374607);
      s_rom(23) <= to_float(0.390731);
      s_rom(24) <= to_float(0.406737);
      s_rom(25) <= to_float(0.422618);
      s_rom(26) <= to_float(0.438371);
      s_rom(27) <= to_float(0.453990);
      s_rom(28) <= to_float(0.469472);
      s_rom(29) <= to_float(0.484810);
      s_rom(30) <= to_float(0.500000);
      s_rom(31) <= to_float(0.515038);
      s_rom(32) <= to_float(0.529919);
      s_rom(33) <= to_float(0.544639);
      s_rom(34) <= to_float(0.559193);
      s_rom(35) <= to_float(0.573576);
      s_rom(36) <= to_float(0.587785);
      s_rom(37) <= to_float(0.601815);
      s_rom(38) <= to_float(0.615661);
      s_rom(39) <= to_float(0.629320);
      s_rom(40) <= to_float(0.642788);
      s_rom(41) <= to_float(0.656059);
      s_rom(42) <= to_float(0.669131);
      s_rom(43) <= to_float(0.681998);
      s_rom(44) <= to_float(0.694658);
      s_rom(45) <= to_float(0.707107);
      s_rom(46) <= to_float(0.719340);
      s_rom(47) <= to_float(0.731354);
      s_rom(48) <= to_float(0.743145);
      s_rom(49) <= to_float(0.754710);
      s_rom(50) <= to_float(0.766044);
      s_rom(51) <= to_float(0.777146);
      s_rom(52) <= to_float(0.788011);
      s_rom(53) <= to_float(0.798636);
      s_rom(54) <= to_float(0.809017);
      s_rom(55) <= to_float(0.819152);
      s_rom(56) <= to_float(0.829038);
      s_rom(57) <= to_float(0.838671);
      s_rom(58) <= to_float(0.848048);
      s_rom(59) <= to_float(0.857167);
      s_rom(60) <= to_float(0.866025);
      s_rom(61) <= to_float(0.874620);
      s_rom(62) <= to_float(0.882948);
      s_rom(63) <= to_float(0.891007);
      s_rom(64) <= to_float(0.898794);
      s_rom(65) <= to_float(0.906308);
      s_rom(66) <= to_float(0.913545);
      s_rom(67) <= to_float(0.920505);
      s_rom(68) <= to_float(0.927184);
      s_rom(69) <= to_float(0.933580);
      s_rom(70) <= to_float(0.939693);
      s_rom(71) <= to_float(0.945519);
      s_rom(72) <= to_float(0.951057);
      s_rom(73) <= to_float(0.956305);
      s_rom(74) <= to_float(0.961262);
      s_rom(75) <= to_float(0.965926);
      s_rom(76) <= to_float(0.970296);
      s_rom(77) <= to_float(0.974370);
      s_rom(78) <= to_float(0.978148);
      s_rom(79) <= to_float(0.981627);
      s_rom(80) <= to_float(0.984808);
      s_rom(81) <= to_float(0.987688);
      s_rom(82) <= to_float(0.990268);
      s_rom(83) <= to_float(0.992546);
      s_rom(84) <= to_float(0.994522);
      s_rom(85) <= to_float(0.996195);
      s_rom(86) <= to_float(0.997564);
      s_rom(87) <= to_float(0.998630);
      s_rom(88) <= to_float(0.999391);
      s_rom(89) <= to_float(0.999848);
      s_rom(90) <= to_float(1.000000);
      s_rom(91) <= to_float(0.999848);
      s_rom(92) <= to_float(0.999391);
      s_rom(93) <= to_float(0.998630);
      s_rom(94) <= to_float(0.997564);
      s_rom(95) <= to_float(0.996195);
      s_rom(96) <= to_float(0.994522);
      s_rom(97) <= to_float(0.992546);
      s_rom(98) <= to_float(0.990268);
      s_rom(99) <= to_float(0.987688);
      s_rom(100) <= to_float(0.984808);
      s_rom(101) <= to_float(0.981627);
      s_rom(102) <= to_float(0.978148);
      s_rom(103) <= to_float(0.974370);
      s_rom(104) <= to_float(0.970296);
      s_rom(105) <= to_float(0.965926);
      s_rom(106) <= to_float(0.961262);
      s_rom(107) <= to_float(0.956305);
      s_rom(108) <= to_float(0.951057);
      s_rom(109) <= to_float(0.945519);
      s_rom(110) <= to_float(0.939693);
      s_rom(111) <= to_float(0.933580);
      s_rom(112) <= to_float(0.927184);
      s_rom(113) <= to_float(0.920505);
      s_rom(114) <= to_float(0.913545);
      s_rom(115) <= to_float(0.906308);
      s_rom(116) <= to_float(0.898794);
      s_rom(117) <= to_float(0.891007);
      s_rom(118) <= to_float(0.882948);
      s_rom(119) <= to_float(0.874620);
      s_rom(120) <= to_float(0.866025);
      s_rom(121) <= to_float(0.857167);
      s_rom(122) <= to_float(0.848048);
      s_rom(123) <= to_float(0.838671);
      s_rom(124) <= to_float(0.829038);
      s_rom(125) <= to_float(0.819152);
      s_rom(126) <= to_float(0.809017);
      s_rom(127) <= to_float(0.798636);
      s_rom(128) <= to_float(0.788011);
      s_rom(129) <= to_float(0.777146);
      s_rom(130) <= to_float(0.766044);
      s_rom(131) <= to_float(0.754710);
      s_rom(132) <= to_float(0.743145);
      s_rom(133) <= to_float(0.731354);
      s_rom(134) <= to_float(0.719340);
      s_rom(135) <= to_float(0.707107);
      s_rom(136) <= to_float(0.694658);
      s_rom(137) <= to_float(0.681998);
      s_rom(138) <= to_float(0.669131);
      s_rom(139) <= to_float(0.656059);
      s_rom(140) <= to_float(0.642788);
      s_rom(141) <= to_float(0.629320);
      s_rom(142) <= to_float(0.615661);
      s_rom(143) <= to_float(0.601815);
      s_rom(144) <= to_float(0.587785);
      s_rom(145) <= to_float(0.573576);
      s_rom(146) <= to_float(0.559193);
      s_rom(147) <= to_float(0.544639);
      s_rom(148) <= to_float(0.529919);
      s_rom(149) <= to_float(0.515038);
      s_rom(150) <= to_float(0.500000);
      s_rom(151) <= to_float(0.484810);
      s_rom(152) <= to_float(0.469472);
      s_rom(153) <= to_float(0.453990);
      s_rom(154) <= to_float(0.438371);
      s_rom(155) <= to_float(0.422618);
      s_rom(156) <= to_float(0.406737);
      s_rom(157) <= to_float(0.390731);
      s_rom(158) <= to_float(0.374607);
      s_rom(159) <= to_float(0.358368);
      s_rom(160) <= to_float(0.342020);
      s_rom(161) <= to_float(0.325568);
      s_rom(162) <= to_float(0.309017);
      s_rom(163) <= to_float(0.292372);
      s_rom(164) <= to_float(0.275637);
      s_rom(165) <= to_float(0.258819);
      s_rom(166) <= to_float(0.241922);
      s_rom(167) <= to_float(0.224951);
      s_rom(168) <= to_float(0.207912);
      s_rom(169) <= to_float(0.190809);
      s_rom(170) <= to_float(0.173648);
      s_rom(171) <= to_float(0.156434);
      s_rom(172) <= to_float(0.139173);
      s_rom(173) <= to_float(0.121869);
      s_rom(174) <= to_float(0.104528);
      s_rom(175) <= to_float(0.087156);
      s_rom(176) <= to_float(0.069756);
      s_rom(177) <= to_float(0.052336);
      s_rom(178) <= to_float(0.034899);
      s_rom(179) <= to_float(0.017452);
      s_rom(180) <= to_float(0.000000);
      s_rom(181) <= to_float(-0.017452);
      s_rom(182) <= to_float(-0.034899);
      s_rom(183) <= to_float(-0.052336);
      s_rom(184) <= to_float(-0.069756);
      s_rom(185) <= to_float(-0.087156);
      s_rom(186) <= to_float(-0.104528);
      s_rom(187) <= to_float(-0.121869);
      s_rom(188) <= to_float(-0.139173);
      s_rom(189) <= to_float(-0.156434);
      s_rom(190) <= to_float(-0.173648);
      s_rom(191) <= to_float(-0.190809);
      s_rom(192) <= to_float(-0.207912);
      s_rom(193) <= to_float(-0.224951);
      s_rom(194) <= to_float(-0.241922);
      s_rom(195) <= to_float(-0.258819);
      s_rom(196) <= to_float(-0.275637);
      s_rom(197) <= to_float(-0.292372);
      s_rom(198) <= to_float(-0.309017);
      s_rom(199) <= to_float(-0.325568);
      s_rom(200) <= to_float(-0.342020);
      s_rom(201) <= to_float(-0.358368);
      s_rom(202) <= to_float(-0.374607);
      s_rom(203) <= to_float(-0.390731);
      s_rom(204) <= to_float(-0.406737);
      s_rom(205) <= to_float(-0.422618);
      s_rom(206) <= to_float(-0.438371);
      s_rom(207) <= to_float(-0.453990);
      s_rom(208) <= to_float(-0.469472);
      s_rom(209) <= to_float(-0.484810);
      s_rom(210) <= to_float(-0.500000);
      s_rom(211) <= to_float(-0.515038);
      s_rom(212) <= to_float(-0.529919);
      s_rom(213) <= to_float(-0.544639);
      s_rom(214) <= to_float(-0.559193);
      s_rom(215) <= to_float(-0.573576);
      s_rom(216) <= to_float(-0.587785);
      s_rom(217) <= to_float(-0.601815);
      s_rom(218) <= to_float(-0.615661);
      s_rom(219) <= to_float(-0.629320);
      s_rom(220) <= to_float(-0.642788);
      s_rom(221) <= to_float(-0.656059);
      s_rom(222) <= to_float(-0.669131);
      s_rom(223) <= to_float(-0.681998);
      s_rom(224) <= to_float(-0.694658);
      s_rom(225) <= to_float(-0.707107);
      s_rom(226) <= to_float(-0.719340);
      s_rom(227) <= to_float(-0.731354);
      s_rom(228) <= to_float(-0.743145);
      s_rom(229) <= to_float(-0.754710);
      s_rom(230) <= to_float(-0.766044);
      s_rom(231) <= to_float(-0.777146);
      s_rom(232) <= to_float(-0.788011);
      s_rom(233) <= to_float(-0.798636);
      s_rom(234) <= to_float(-0.809017);
      s_rom(235) <= to_float(-0.819152);
      s_rom(236) <= to_float(-0.829038);
      s_rom(237) <= to_float(-0.838671);
      s_rom(238) <= to_float(-0.848048);
      s_rom(239) <= to_float(-0.857167);
      s_rom(240) <= to_float(-0.866025);
      s_rom(241) <= to_float(-0.874620);
      s_rom(242) <= to_float(-0.882948);
      s_rom(243) <= to_float(-0.891007);
      s_rom(244) <= to_float(-0.898794);
      s_rom(245) <= to_float(-0.906308);
      s_rom(246) <= to_float(-0.913545);
      s_rom(247) <= to_float(-0.920505);
      s_rom(248) <= to_float(-0.927184);
      s_rom(249) <= to_float(-0.933580);
      s_rom(250) <= to_float(-0.939693);
      s_rom(251) <= to_float(-0.945519);
      s_rom(252) <= to_float(-0.951057);
      s_rom(253) <= to_float(-0.956305);
      s_rom(254) <= to_float(-0.961262);
      s_rom(255) <= to_float(-0.965926);
      s_rom(256) <= to_float(-0.970296);
      s_rom(257) <= to_float(-0.974370);
      s_rom(258) <= to_float(-0.978148);
      s_rom(259) <= to_float(-0.981627);
      s_rom(260) <= to_float(-0.984808);
      s_rom(261) <= to_float(-0.987688);
      s_rom(262) <= to_float(-0.990268);
      s_rom(263) <= to_float(-0.992546);
      s_rom(264) <= to_float(-0.994522);
      s_rom(265) <= to_float(-0.996195);
      s_rom(266) <= to_float(-0.997564);
      s_rom(267) <= to_float(-0.998630);
      s_rom(268) <= to_float(-0.999391);
      s_rom(269) <= to_float(-0.999848);
      s_rom(270) <= to_float(-1.000000);
      s_rom(271) <= to_float(-0.999848);
      s_rom(272) <= to_float(-0.999391);
      s_rom(273) <= to_float(-0.998630);
      s_rom(274) <= to_float(-0.997564);
      s_rom(275) <= to_float(-0.996195);
      s_rom(276) <= to_float(-0.994522);
      s_rom(277) <= to_float(-0.992546);
      s_rom(278) <= to_float(-0.990268);
      s_rom(279) <= to_float(-0.987688);
      s_rom(280) <= to_float(-0.984808);
      s_rom(281) <= to_float(-0.981627);
      s_rom(282) <= to_float(-0.978148);
      s_rom(283) <= to_float(-0.974370);
      s_rom(284) <= to_float(-0.970296);
      s_rom(285) <= to_float(-0.965926);
      s_rom(286) <= to_float(-0.961262);
      s_rom(287) <= to_float(-0.956305);
      s_rom(288) <= to_float(-0.951057);
      s_rom(289) <= to_float(-0.945519);
      s_rom(290) <= to_float(-0.939693);
      s_rom(291) <= to_float(-0.933580);
      s_rom(292) <= to_float(-0.927184);
      s_rom(293) <= to_float(-0.920505);
      s_rom(294) <= to_float(-0.913545);
      s_rom(295) <= to_float(-0.906308);
      s_rom(296) <= to_float(-0.898794);
      s_rom(297) <= to_float(-0.891007);
      s_rom(298) <= to_float(-0.882948);
      s_rom(299) <= to_float(-0.874620);
      s_rom(300) <= to_float(-0.866025);
      s_rom(301) <= to_float(-0.857167);
      s_rom(302) <= to_float(-0.848048);
      s_rom(303) <= to_float(-0.838671);
      s_rom(304) <= to_float(-0.829038);
      s_rom(305) <= to_float(-0.819152);
      s_rom(306) <= to_float(-0.809017);
      s_rom(307) <= to_float(-0.798636);
      s_rom(308) <= to_float(-0.788011);
      s_rom(309) <= to_float(-0.777146);
      s_rom(310) <= to_float(-0.766044);
      s_rom(311) <= to_float(-0.754710);
      s_rom(312) <= to_float(-0.743145);
      s_rom(313) <= to_float(-0.731354);
      s_rom(314) <= to_float(-0.719340);
      s_rom(315) <= to_float(-0.707107);
      s_rom(316) <= to_float(-0.694658);
      s_rom(317) <= to_float(-0.681998);
      s_rom(318) <= to_float(-0.669131);
      s_rom(319) <= to_float(-0.656059);
      s_rom(320) <= to_float(-0.642788);
      s_rom(321) <= to_float(-0.629320);
      s_rom(322) <= to_float(-0.615661);
      s_rom(323) <= to_float(-0.601815);
      s_rom(324) <= to_float(-0.587785);
      s_rom(325) <= to_float(-0.573576);
      s_rom(326) <= to_float(-0.559193);
      s_rom(327) <= to_float(-0.544639);
      s_rom(328) <= to_float(-0.529919);
      s_rom(329) <= to_float(-0.515038);
      s_rom(330) <= to_float(-0.500000);
      s_rom(331) <= to_float(-0.484810);
      s_rom(332) <= to_float(-0.469472);
      s_rom(333) <= to_float(-0.453990);
      s_rom(334) <= to_float(-0.438371);
      s_rom(335) <= to_float(-0.422618);
      s_rom(336) <= to_float(-0.406737);
      s_rom(337) <= to_float(-0.390731);
      s_rom(338) <= to_float(-0.374607);
      s_rom(339) <= to_float(-0.358368);
      s_rom(340) <= to_float(-0.342020);
      s_rom(341) <= to_float(-0.325568);
      s_rom(342) <= to_float(-0.309017);
      s_rom(343) <= to_float(-0.292372);
      s_rom(344) <= to_float(-0.275637);
      s_rom(345) <= to_float(-0.258819);
      s_rom(346) <= to_float(-0.241922);
      s_rom(347) <= to_float(-0.224951);
      s_rom(348) <= to_float(-0.207912);
      s_rom(349) <= to_float(-0.190809);
      s_rom(350) <= to_float(-0.173648);
      s_rom(351) <= to_float(-0.156434);
      s_rom(352) <= to_float(-0.139173);
      s_rom(353) <= to_float(-0.121869);
      s_rom(354) <= to_float(-0.104528);
      s_rom(355) <= to_float(-0.087156);
      s_rom(356) <= to_float(-0.069756);
      s_rom(357) <= to_float(-0.052336);
      s_rom(358) <= to_float(-0.034899);
      s_rom(359) <= to_float(-0.017452);
      s_rom(360) <= to_float(-0.000000);
      
      c_rom(0) <= to_float(1.000000);
      c_rom(1) <= to_float(0.999848);
      c_rom(2) <= to_float(0.999391);
      c_rom(3) <= to_float(0.998630);
      c_rom(4) <= to_float(0.997564);
      c_rom(5) <= to_float(0.996195);
      c_rom(6) <= to_float(0.994522);
      c_rom(7) <= to_float(0.992546);
      c_rom(8) <= to_float(0.990268);
      c_rom(9) <= to_float(0.987688);
      c_rom(10) <= to_float(0.984808);
      c_rom(11) <= to_float(0.981627);
      c_rom(12) <= to_float(0.978148);
      c_rom(13) <= to_float(0.974370);
      c_rom(14) <= to_float(0.970296);
      c_rom(15) <= to_float(0.965926);
      c_rom(16) <= to_float(0.961262);
      c_rom(17) <= to_float(0.956305);
      c_rom(18) <= to_float(0.951057);
      c_rom(19) <= to_float(0.945519);
      c_rom(20) <= to_float(0.939693);
      c_rom(21) <= to_float(0.933580);
      c_rom(22) <= to_float(0.927184);
      c_rom(23) <= to_float(0.920505);
      c_rom(24) <= to_float(0.913545);
      c_rom(25) <= to_float(0.906308);
      c_rom(26) <= to_float(0.898794);
      c_rom(27) <= to_float(0.891007);
      c_rom(28) <= to_float(0.882948);
      c_rom(29) <= to_float(0.874620);
      c_rom(30) <= to_float(0.866025);
      c_rom(31) <= to_float(0.857167);
      c_rom(32) <= to_float(0.848048);
      c_rom(33) <= to_float(0.838671);
      c_rom(34) <= to_float(0.829038);
      c_rom(35) <= to_float(0.819152);
      c_rom(36) <= to_float(0.809017);
      c_rom(37) <= to_float(0.798636);
      c_rom(38) <= to_float(0.788011);
      c_rom(39) <= to_float(0.777146);
      c_rom(40) <= to_float(0.766044);
      c_rom(41) <= to_float(0.754710);
      c_rom(42) <= to_float(0.743145);
      c_rom(43) <= to_float(0.731354);
      c_rom(44) <= to_float(0.719340);
      c_rom(45) <= to_float(0.707107);
      c_rom(46) <= to_float(0.694658);
      c_rom(47) <= to_float(0.681998);
      c_rom(48) <= to_float(0.669131);
      c_rom(49) <= to_float(0.656059);
      c_rom(50) <= to_float(0.642788);
      c_rom(51) <= to_float(0.629320);
      c_rom(52) <= to_float(0.615661);
      c_rom(53) <= to_float(0.601815);
      c_rom(54) <= to_float(0.587785);
      c_rom(55) <= to_float(0.573576);
      c_rom(56) <= to_float(0.559193);
      c_rom(57) <= to_float(0.544639);
      c_rom(58) <= to_float(0.529919);
      c_rom(59) <= to_float(0.515038);
      c_rom(60) <= to_float(0.500000);
      c_rom(61) <= to_float(0.484810);
      c_rom(62) <= to_float(0.469472);
      c_rom(63) <= to_float(0.453990);
      c_rom(64) <= to_float(0.438371);
      c_rom(65) <= to_float(0.422618);
      c_rom(66) <= to_float(0.406737);
      c_rom(67) <= to_float(0.390731);
      c_rom(68) <= to_float(0.374607);
      c_rom(69) <= to_float(0.358368);
      c_rom(70) <= to_float(0.342020);
      c_rom(71) <= to_float(0.325568);
      c_rom(72) <= to_float(0.309017);
      c_rom(73) <= to_float(0.292372);
      c_rom(74) <= to_float(0.275637);
      c_rom(75) <= to_float(0.258819);
      c_rom(76) <= to_float(0.241922);
      c_rom(77) <= to_float(0.224951);
      c_rom(78) <= to_float(0.207912);
      c_rom(79) <= to_float(0.190809);
      c_rom(80) <= to_float(0.173648);
      c_rom(81) <= to_float(0.156434);
      c_rom(82) <= to_float(0.139173);
      c_rom(83) <= to_float(0.121869);
      c_rom(84) <= to_float(0.104528);
      c_rom(85) <= to_float(0.087156);
      c_rom(86) <= to_float(0.069756);
      c_rom(87) <= to_float(0.052336);
      c_rom(88) <= to_float(0.034899);
      c_rom(89) <= to_float(0.017452);
      c_rom(90) <= to_float(0.000000);
      c_rom(91) <= to_float(-0.017452);
      c_rom(92) <= to_float(-0.034899);
      c_rom(93) <= to_float(-0.052336);
      c_rom(94) <= to_float(-0.069756);
      c_rom(95) <= to_float(-0.087156);
      c_rom(96) <= to_float(-0.104528);
      c_rom(97) <= to_float(-0.121869);
      c_rom(98) <= to_float(-0.139173);
      c_rom(99) <= to_float(-0.156434);
      c_rom(100) <= to_float(-0.173648);
      c_rom(101) <= to_float(-0.190809);
      c_rom(102) <= to_float(-0.207912);
      c_rom(103) <= to_float(-0.224951);
      c_rom(104) <= to_float(-0.241922);
      c_rom(105) <= to_float(-0.258819);
      c_rom(106) <= to_float(-0.275637);
      c_rom(107) <= to_float(-0.292372);
      c_rom(108) <= to_float(-0.309017);
      c_rom(109) <= to_float(-0.325568);
      c_rom(110) <= to_float(-0.342020);
      c_rom(111) <= to_float(-0.358368);
      c_rom(112) <= to_float(-0.374607);
      c_rom(113) <= to_float(-0.390731);
      c_rom(114) <= to_float(-0.406737);
      c_rom(115) <= to_float(-0.422618);
      c_rom(116) <= to_float(-0.438371);
      c_rom(117) <= to_float(-0.453990);
      c_rom(118) <= to_float(-0.469472);
      c_rom(119) <= to_float(-0.484810);
      c_rom(120) <= to_float(-0.500000);
      c_rom(121) <= to_float(-0.515038);
      c_rom(122) <= to_float(-0.529919);
      c_rom(123) <= to_float(-0.544639);
      c_rom(124) <= to_float(-0.559193);
      c_rom(125) <= to_float(-0.573576);
      c_rom(126) <= to_float(-0.587785);
      c_rom(127) <= to_float(-0.601815);
      c_rom(128) <= to_float(-0.615661);
      c_rom(129) <= to_float(-0.629320);
      c_rom(130) <= to_float(-0.642788);
      c_rom(131) <= to_float(-0.656059);
      c_rom(132) <= to_float(-0.669131);
      c_rom(133) <= to_float(-0.681998);
      c_rom(134) <= to_float(-0.694658);
      c_rom(135) <= to_float(-0.707107);
      c_rom(136) <= to_float(-0.719340);
      c_rom(137) <= to_float(-0.731354);
      c_rom(138) <= to_float(-0.743145);
      c_rom(139) <= to_float(-0.754710);
      c_rom(140) <= to_float(-0.766044);
      c_rom(141) <= to_float(-0.777146);
      c_rom(142) <= to_float(-0.788011);
      c_rom(143) <= to_float(-0.798636);
      c_rom(144) <= to_float(-0.809017);
      c_rom(145) <= to_float(-0.819152);
      c_rom(146) <= to_float(-0.829038);
      c_rom(147) <= to_float(-0.838671);
      c_rom(148) <= to_float(-0.848048);
      c_rom(149) <= to_float(-0.857167);
      c_rom(150) <= to_float(-0.866025);
      c_rom(151) <= to_float(-0.874620);
      c_rom(152) <= to_float(-0.882948);
      c_rom(153) <= to_float(-0.891007);
      c_rom(154) <= to_float(-0.898794);
      c_rom(155) <= to_float(-0.906308);
      c_rom(156) <= to_float(-0.913545);
      c_rom(157) <= to_float(-0.920505);
      c_rom(158) <= to_float(-0.927184);
      c_rom(159) <= to_float(-0.933580);
      c_rom(160) <= to_float(-0.939693);
      c_rom(161) <= to_float(-0.945519);
      c_rom(162) <= to_float(-0.951057);
      c_rom(163) <= to_float(-0.956305);
      c_rom(164) <= to_float(-0.961262);
      c_rom(165) <= to_float(-0.965926);
      c_rom(166) <= to_float(-0.970296);
      c_rom(167) <= to_float(-0.974370);
      c_rom(168) <= to_float(-0.978148);
      c_rom(169) <= to_float(-0.981627);
      c_rom(170) <= to_float(-0.984808);
      c_rom(171) <= to_float(-0.987688);
      c_rom(172) <= to_float(-0.990268);
      c_rom(173) <= to_float(-0.992546);
      c_rom(174) <= to_float(-0.994522);
      c_rom(175) <= to_float(-0.996195);
      c_rom(176) <= to_float(-0.997564);
      c_rom(177) <= to_float(-0.998630);
      c_rom(178) <= to_float(-0.999391);
      c_rom(179) <= to_float(-0.999848);
      c_rom(180) <= to_float(-1.000000);
      c_rom(181) <= to_float(-0.999848);
      c_rom(182) <= to_float(-0.999391);
      c_rom(183) <= to_float(-0.998630);
      c_rom(184) <= to_float(-0.997564);
      c_rom(185) <= to_float(-0.996195);
      c_rom(186) <= to_float(-0.994522);
      c_rom(187) <= to_float(-0.992546);
      c_rom(188) <= to_float(-0.990268);
      c_rom(189) <= to_float(-0.987688);
      c_rom(190) <= to_float(-0.984808);
      c_rom(191) <= to_float(-0.981627);
      c_rom(192) <= to_float(-0.978148);
      c_rom(193) <= to_float(-0.974370);
      c_rom(194) <= to_float(-0.970296);
      c_rom(195) <= to_float(-0.965926);
      c_rom(196) <= to_float(-0.961262);
      c_rom(197) <= to_float(-0.956305);
      c_rom(198) <= to_float(-0.951057);
      c_rom(199) <= to_float(-0.945519);
      c_rom(200) <= to_float(-0.939693);
      c_rom(201) <= to_float(-0.933580);
      c_rom(202) <= to_float(-0.927184);
      c_rom(203) <= to_float(-0.920505);
      c_rom(204) <= to_float(-0.913545);
      c_rom(205) <= to_float(-0.906308);
      c_rom(206) <= to_float(-0.898794);
      c_rom(207) <= to_float(-0.891007);
      c_rom(208) <= to_float(-0.882948);
      c_rom(209) <= to_float(-0.874620);
      c_rom(210) <= to_float(-0.866025);
      c_rom(211) <= to_float(-0.857167);
      c_rom(212) <= to_float(-0.848048);
      c_rom(213) <= to_float(-0.838671);
      c_rom(214) <= to_float(-0.829038);
      c_rom(215) <= to_float(-0.819152);
      c_rom(216) <= to_float(-0.809017);
      c_rom(217) <= to_float(-0.798636);
      c_rom(218) <= to_float(-0.788011);
      c_rom(219) <= to_float(-0.777146);
      c_rom(220) <= to_float(-0.766044);
      c_rom(221) <= to_float(-0.754710);
      c_rom(222) <= to_float(-0.743145);
      c_rom(223) <= to_float(-0.731354);
      c_rom(224) <= to_float(-0.719340);
      c_rom(225) <= to_float(-0.707107);
      c_rom(226) <= to_float(-0.694658);
      c_rom(227) <= to_float(-0.681998);
      c_rom(228) <= to_float(-0.669131);
      c_rom(229) <= to_float(-0.656059);
      c_rom(230) <= to_float(-0.642788);
      c_rom(231) <= to_float(-0.629320);
      c_rom(232) <= to_float(-0.615661);
      c_rom(233) <= to_float(-0.601815);
      c_rom(234) <= to_float(-0.587785);
      c_rom(235) <= to_float(-0.573576);
      c_rom(236) <= to_float(-0.559193);
      c_rom(237) <= to_float(-0.544639);
      c_rom(238) <= to_float(-0.529919);
      c_rom(239) <= to_float(-0.515038);
      c_rom(240) <= to_float(-0.500000);
      c_rom(241) <= to_float(-0.484810);
      c_rom(242) <= to_float(-0.469472);
      c_rom(243) <= to_float(-0.453990);
      c_rom(244) <= to_float(-0.438371);
      c_rom(245) <= to_float(-0.422618);
      c_rom(246) <= to_float(-0.406737);
      c_rom(247) <= to_float(-0.390731);
      c_rom(248) <= to_float(-0.374607);
      c_rom(249) <= to_float(-0.358368);
      c_rom(250) <= to_float(-0.342020);
      c_rom(251) <= to_float(-0.325568);
      c_rom(252) <= to_float(-0.309017);
      c_rom(253) <= to_float(-0.292372);
      c_rom(254) <= to_float(-0.275637);
      c_rom(255) <= to_float(-0.258819);
      c_rom(256) <= to_float(-0.241922);
      c_rom(257) <= to_float(-0.224951);
      c_rom(258) <= to_float(-0.207912);
      c_rom(259) <= to_float(-0.190809);
      c_rom(260) <= to_float(-0.173648);
      c_rom(261) <= to_float(-0.156434);
      c_rom(262) <= to_float(-0.139173);
      c_rom(263) <= to_float(-0.121869);
      c_rom(264) <= to_float(-0.104528);
      c_rom(265) <= to_float(-0.087156);
      c_rom(266) <= to_float(-0.069756);
      c_rom(267) <= to_float(-0.052336);
      c_rom(268) <= to_float(-0.034899);
      c_rom(269) <= to_float(-0.017452);
      c_rom(270) <= to_float(-0.000000);
      c_rom(271) <= to_float(0.017452);
      c_rom(272) <= to_float(0.034899);
      c_rom(273) <= to_float(0.052336);
      c_rom(274) <= to_float(0.069756);
      c_rom(275) <= to_float(0.087156);
      c_rom(276) <= to_float(0.104528);
      c_rom(277) <= to_float(0.121869);
      c_rom(278) <= to_float(0.139173);
      c_rom(279) <= to_float(0.156434);
      c_rom(280) <= to_float(0.173648);
      c_rom(281) <= to_float(0.190809);
      c_rom(282) <= to_float(0.207912);
      c_rom(283) <= to_float(0.224951);
      c_rom(284) <= to_float(0.241922);
      c_rom(285) <= to_float(0.258819);
      c_rom(286) <= to_float(0.275637);
      c_rom(287) <= to_float(0.292372);
      c_rom(288) <= to_float(0.309017);
      c_rom(289) <= to_float(0.325568);
      c_rom(290) <= to_float(0.342020);
      c_rom(291) <= to_float(0.358368);
      c_rom(292) <= to_float(0.374607);
      c_rom(293) <= to_float(0.390731);
      c_rom(294) <= to_float(0.406737);
      c_rom(295) <= to_float(0.422618);
      c_rom(296) <= to_float(0.438371);
      c_rom(297) <= to_float(0.453990);
      c_rom(298) <= to_float(0.469472);
      c_rom(299) <= to_float(0.484810);
      c_rom(300) <= to_float(0.500000);
      c_rom(301) <= to_float(0.515038);
      c_rom(302) <= to_float(0.529919);
      c_rom(303) <= to_float(0.544639);
      c_rom(304) <= to_float(0.559193);
      c_rom(305) <= to_float(0.573576);
      c_rom(306) <= to_float(0.587785);
      c_rom(307) <= to_float(0.601815);
      c_rom(308) <= to_float(0.615661);
      c_rom(309) <= to_float(0.629320);
      c_rom(310) <= to_float(0.642788);
      c_rom(311) <= to_float(0.656059);
      c_rom(312) <= to_float(0.669131);
      c_rom(313) <= to_float(0.681998);
      c_rom(314) <= to_float(0.694658);
      c_rom(315) <= to_float(0.707107);
      c_rom(316) <= to_float(0.719340);
      c_rom(317) <= to_float(0.731354);
      c_rom(318) <= to_float(0.743145);
      c_rom(319) <= to_float(0.754710);
      c_rom(320) <= to_float(0.766044);
      c_rom(321) <= to_float(0.777146);
      c_rom(322) <= to_float(0.788011);
      c_rom(323) <= to_float(0.798636);
      c_rom(324) <= to_float(0.809017);
      c_rom(325) <= to_float(0.819152);
      c_rom(326) <= to_float(0.829038);
      c_rom(327) <= to_float(0.838671);
      c_rom(328) <= to_float(0.848048);
      c_rom(329) <= to_float(0.857167);
      c_rom(330) <= to_float(0.866025);
      c_rom(331) <= to_float(0.874620);
      c_rom(332) <= to_float(0.882948);
      c_rom(333) <= to_float(0.891007);
      c_rom(334) <= to_float(0.898794);
      c_rom(335) <= to_float(0.906308);
      c_rom(336) <= to_float(0.913545);
      c_rom(337) <= to_float(0.920505);
      c_rom(338) <= to_float(0.927184);
      c_rom(339) <= to_float(0.933580);
      c_rom(340) <= to_float(0.939693);
      c_rom(341) <= to_float(0.945519);
      c_rom(342) <= to_float(0.951057);
      c_rom(343) <= to_float(0.956305);
      c_rom(344) <= to_float(0.961262);
      c_rom(345) <= to_float(0.965926);
      c_rom(346) <= to_float(0.970296);
      c_rom(347) <= to_float(0.974370);
      c_rom(348) <= to_float(0.978148);
      c_rom(349) <= to_float(0.981627);
      c_rom(350) <= to_float(0.984808);
      c_rom(351) <= to_float(0.987688);
      c_rom(352) <= to_float(0.990268);
      c_rom(353) <= to_float(0.992546);
      c_rom(354) <= to_float(0.994522);
      c_rom(355) <= to_float(0.996195);
      c_rom(356) <= to_float(0.997564);
      c_rom(357) <= to_float(0.998630);
      c_rom(358) <= to_float(0.999391);
      c_rom(359) <= to_float(0.999848);
      c_rom(360) <= to_float(1.000000);
      
      end if;
    end procedure;
end package body fftpackage;