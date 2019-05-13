library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filter_qsys_interface_tb is

end entity;


architecture beh of filter_qsys_interface_tb is

		signal clk_tb :  std_logic;
		signal reset_tb :  std_logic:= '0';
		
		signal read_avalon_s0_tb        	:     std_logic                     ;             -- read
		signal write_avalon_s0_tb      	:     std_logic                     := '0';             -- write
		signal writedata_avalon_s0_tb  	:     std_logic_vector(63 downto 0) := (others => 'X'); -- write_data
		signal readdata_avalon_s0_tb   	:    std_logic_vector(63 downto 0) := (others => 'X')  ;                  -- read_data

	SIGNAL	 outputState_tb :  std_logic_vector(3 downto 0);
	SIGNAL	outputMagnitudeA_tb :  unsigned(7 downto 0);
	SIGNAL	outputMagnitudeB_tb :  unsigned(7 downto 0);
	SIGNAL	outputMagnitudeC_tb :  unsigned(7 downto 0);
	SIGNAL	outputMagnitudeD_tb :  unsigned(7 downto 0);	

component filter_qsys_interface is
	port(

		clk : in std_logic;
		reset : in std_logic;
		
		read_avalon_s0        	: in    std_logic                     ;             -- read
		write_avalon_s0      	: in    std_logic                    ;             -- write
		writedata_avalon_s0  	: in    std_logic_vector(63 downto 0) ; -- write_data
		readdata_avalon_s0   	: out   std_logic_vector(63 downto 0);                     -- read_data
		
		outputState : out std_logic_vector(3 downto 0);
		outputMagnitudeA : out unsigned(7 downto 0);
		outputMagnitudeB : out unsigned(7 downto 0);
		outputMagnitudeC : out unsigned(7 downto 0);
		outputMagnitudeD : out unsigned(7 downto 0)
	);
end component;

begin


filter_qsys_interface_inst : component filter_qsys_interface
	port MAP(

		clk => clk_tb,
		reset => reset_tb,
		
		read_avalon_s0        	=> read_avalon_s0_tb,
		write_avalon_s0      	=> write_avalon_s0_tb,
		writedata_avalon_s0  	=> writedata_avalon_s0_tb,
		readdata_avalon_s0   	=>readdata_avalon_s0_tb,
		outputState =>   outputState_tb,
		outputMagnitudeA => outputMagnitudeA_tb,
		outputMagnitudeB => outputMagnitudeB_tb,
		outputMagnitudeC => outputMagnitudeC_tb,
		outputMagnitudeD => outputMagnitudeD_tb
	);


test_signals:process
begin
		wait for 20 ns;
		read_avalon_s0_tb <= '0'; 
		write_avalon_s0_tb <= '1';
		writedata_avalon_s0_tb(7 downto 0) <= x"01";
		writedata_avalon_s0_tb(63 downto 8) <= x"11112222555544"; 
		wait for 20 ns;
		write_avalon_s0_tb <= '1';
		writedata_avalon_s0_tb(7 downto 0) <= x"02";
		wait for 20 ns;
		write_avalon_s0_tb <= '1';
		read_avalon_s0_tb <= '1';
		writedata_avalon_s0_tb(7 downto 0) <= x"03";
		wait for 20 ns;
		write_avalon_s0_tb <= '0';
		read_avalon_s0_tb <= '1';
		writedata_avalon_s0_tb(7 downto 0) <= x"04";
		wait for 690 ns;
		read_avalon_s0_tb <= '1';
		--wait for 50 ns;
		--read_avalon_s0_tb <= '0';
		
		
end process test_signals;

clk_25: process
begin
	clk_tb <= '1';
	wait for 20 ns;
	clk_tb <= '0';
	wait for 20 ns;

end process clk_25;

end architecture ;