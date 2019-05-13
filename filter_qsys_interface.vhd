library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filter_qsys_interface is

	port(

		clk : in std_logic;
		reset : in std_logic;
		
		read_avalon_s0        	: in    std_logic                     ;             -- read
		write_avalon_s0      	: in    std_logic                    ;             -- write
		writedata_avalon_s0  	: in    std_logic_vector(63 downto 0) ; -- write_data
		readdata_avalon_s0   	: out   std_logic_vector(63 downto 0);                  -- read_data

		
		
		outputState : out std_logic_vector(3 downto 0);
		outputMagnitudeA : out unsigned(7 downto 0);
		outputMagnitudeB : out unsigned(7 downto 0);
		outputMagnitudeC : out unsigned(7 downto 0);
		outputMagnitudeD : out unsigned(7 downto 0)
	);
end entity;


architecture beh of filter_qsys_interface is

	
	
	component GeneralFilterTest IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		en :  IN  STD_LOGIC;
		load :  IN  STD_LOGIC;
		filterSelectA :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		filterSelectB :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		filterSelectC :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		inputA 		:  IN  UNSIGNED(7 DOWNTO 0);
		inputB 		:  IN  UNSIGNED(7 DOWNTO 0);
		inputC 		:  IN  UNSIGNED(7 DOWNTO 0);
		inputD 		:  IN  UNSIGNED(7 DOWNTO 0);
		inputE 		:  IN  UNSIGNED(7 DOWNTO 0);
		inputF 		:  IN  UNSIGNED(7 DOWNTO 0);
		inputG 		:  IN  UNSIGNED(7 DOWNTO 0);
		inputH 		:  IN  UNSIGNED(7 DOWNTO 0);
		magnitudeA :  OUT  UNSIGNED(7 DOWNTO 0);
		magnitudeB :  OUT  UNSIGNED(7 DOWNTO 0);
		magnitudeC :  OUT  UNSIGNED(7 DOWNTO 0);
		magnitudeD :  OUT  UNSIGNED(7 DOWNTO 0)
	);
END component;

	type state_type is (idle, loadInputA, loadInputB, loadInputC, loadInputD, loadInputE, loadInputF, loadInputG, loadinputH,enableFilter,dataReady, 
						readMagnitudeA,readMagnitudeB,readMagnitudeC,readMagnitudeD);
	

	-- Register to hold the current state
	
	signal state : state_type := idle;
	
	signal signal_enable_filters : std_logic;
	signal signal_readdata : std_logic_vector (63 downto 0);
	signal signal_writedata : std_logic_vector (63 downto 0);

	signal signal_inputA 	: UNSIGNED(7 downto 0) := x"00";
	signal signal_inputB	: UNSIGNED(7 downto 0) := x"00";
	signal signal_inputC 	: UNSIGNED(7 downto 0) := x"00";
	signal signal_inputD	: UNSIGNED(7 downto 0) := x"00";
	signal signal_inputE	: UNSIGNED(7 downto 0) := x"00";
	signal signal_inputF	: UNSIGNED(7 downto 0) := x"00";
	signal signal_inputG	: UNSIGNED(7 downto 0) := x"00";
	signal signal_inputH 	: UNSIGNED(7 downto 0) := x"00";
	signal signal_magnitudeA, signal_magnitudeB, signal_magnitudeC, signal_magnitudeD : unsigned (7 downto 0) := x"00";
	signal signal_outputState: std_logic_vector(3 downto 0) := x"0";
begin


	Filter_inst_1 : component GeneralFilterTest
	PORT Map
	(
		clk => clk,
		en => signal_enable_filters,
		load => '1',
		filterSelectA => "11",
		filterSelectB => "00",
		filterSelectC => "01",
		inputA => signal_inputA,
		inputB => signal_inputB,
		inputC => signal_inputC,
		inputD => signal_inputD,
		inputE => signal_inputE,
		inputF => signal_inputF,
		inputG => signal_inputG,
		inputH => signal_inputH,
		magnitudeA =>	signal_magnitudeA,
		magnitudeB =>	signal_magnitudeB,
		magnitudeC =>	signal_magnitudeC,
		magnitudeD => signal_magnitudeD
	);



	
	process (clk, write_avalon_s0)
	begin


		if (rising_edge(clk)) then
			-- Determine the next state synchronously, based on
			-- the current state and the input
			case state is
				when idle=>
					if write_avalon_s0 = '1' then
						state <= loadInputA;
					else
						state <= idle;
					end if;
				when loadInputA=>
					if write_avalon_s0 = '1' then
						state <= loadInputB;
					else
						state <= loadInputA;
					end if;
				when loadInputB=>
					if write_avalon_s0 = '1' then
						state <= loadInputC;
					else
						state <= loadInputB;
					end if;
				when loadInputC=>
					if write_avalon_s0 = '1' then
						state <= loadInputD;
					else
						state <= loadInputC;
					end if;

				when loadInputD=>
					if write_avalon_s0 = '1' then
						state <= loadInputE;
					else
						state <= loadInputD;
					end if;
				when loadInputE=>
					if write_avalon_s0 = '1' then
						state <= loadInputF;
					else
						state <= loadInputE;
					end if;
					
				when loadInputF=>
					if write_avalon_s0 = '1' then
						state <= loadInputG;
					else
						state <= loadInputF;
					end if;
					
				when loadInputG=>
					if write_avalon_s0 = '1' then
						state <= loadInputH;
					else
						state <= loadInputG;
					end if;
					
				when loadInputH=>
					if write_avalon_s0 = '1' then
						state <= enableFilter;
					else
						state <= loadInputH;
					end if;
					
					
				when enableFilter=>
					if write_avalon_s0 = '1' then
						state <= dataReady;
					else
						state <= enableFilter;
					end if;
				when dataReady=>
					if write_avalon_s0 = '1' then
						state <= readMagnitudeA;
					else
						state <= dataReady;
					end if;	
				when readMagnitudeA=>
					if write_avalon_s0 = '1' then
						state <= readMagnitudeB;
					else
						state <= readMagnitudeA;
					end if;	
				when readMagnitudeB=>
					if write_avalon_s0 = '1' then
						state <= readMagnitudeC;
					else
						state <= readMagnitudeB;
					end if;	
					
				when readMagnitudeC=>
					if write_avalon_s0 = '1' then
						state <= readMagnitudeD;
					else
						state <= readMagnitudeC;
					end if;	
					
					
				when readMagnitudeD=>
					if write_avalon_s0 = '1' then
						state <= idle;
					else
						state <= readMagnitudeD;
					end if;
			end case;

		end if;
	end process;
	



			

	-- Determine the output based only on the current state
	-- and the input (do not wait for a clock edge).
stateProcess:	process (state, clk)
	begin
			case state is

				when idle =>
					
						readdata_avalon_s0(7 downto 0) <= x"FF";
						signal_outputState <= x"0";
					

				when loadInputA=>
					
						
						signal_inputA <= unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"1";
					
				when loadInputb=>
					
						
						signal_inputB <= unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"2";
		
				when loadInputc=>
					
						signal_inputC <= unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"3";
				when loadInputD=>
					
						signal_inputD <= unsigned(writedata_avalon_s0(7 downto 0));
					
						signal_outputState <= x"4";
					
				when loadInputE=>
					
						signal_inputE <= unsigned(writedata_avalon_s0(7 downto 0));
						
						signal_outputState <= x"5";
					
				when loadInputF=>
					
						signal_inputF <= unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"6";
					
				when loadInputG=>
				
						signal_inputG <= unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"7";

				when loadInputH=>

					signal_inputH <= unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";

				when enableFilter=>
					IF(read_avalon_s0 = '1') THEN
						signal_outputState <= x"9";
					end if;
				when dataReady =>
					if read_avalon_s0 = '1' then
						readdata_avalon_s0(7 downto 0) <= x"AA";
						
					end if;
					signal_outputState <= x"A";
				when readMagnitudeA=>
					if read_avalon_s0 = '1' then
						readdata_avalon_s0(7 downto 0) <=  std_logic_vector(signal_magnitudeA);
						
						outputMagnitudeA <= signal_magnitudeA;
					end if;
					signal_outputState <= x"B";
					
				when readMagnitudeB=>
					if read_avalon_s0 = '1' then
						readdata_avalon_s0(7 downto 0) <=  std_logic_vector(signal_magnitudeB);
						
						outputMagnitudeb <= signal_magnitudeB;
					end if;
					signal_outputState <= x"C";
				when readMagnitudeC=>
					if read_avalon_s0 = '1' then
						readdata_avalon_s0(7 downto 0) <=  std_logic_vector(signal_magnitudeC);
						
						outputMagnitudec <= signal_magnitudeC;
					end if;
					
					signal_outputState <= x"D";
				when readMagnitudeD=>
					if read_avalon_s0 = '1' then
						readdata_avalon_s0(7 downto 0) <=  std_logic_vector(signal_magnitudeD);
						
						outputMagnituded <= signal_magnitudeD;
					end if;
					signal_outputState <= x"E";
			end case;
	end process;
outputState <= signal_outputState;
end architecture;
