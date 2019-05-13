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

	
	
	
	
	Component Filterfivebyfive IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		enable :  IN  STD_LOGIC;
		filterSelect_A :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		filterSelect_B :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		filterSelect_C :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		gaussA :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussB :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussC :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussD :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussE :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussF :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussG :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussH :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussI :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussJ :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussK :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussL :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussM :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussN :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussO :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussP :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussQ :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussR :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussS :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussT :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussU :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussV :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussW :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussX :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		gaussY :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		magnitude :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END component;


	type state_type is (idle, loadInputA, loadInputB, loadInputC, loadInputD, loadInputE, loadInputF, loadInputG, loadinputH,
								loadInputi, loadInputj, loadInputk, loadInputl, loadInputm, loadInputn, loadInputo, loadinputp,
								loadInputq, loadInputR, loadInputs, loadInputT, loadInputU, loadInputV, loadInputW, loadinputX,
								loadInputY, enableFilter,dataReady, 
						readMagnitude);
	

	-- Register to hold the current state
	
	signal state : state_type := idle;
	
	signal signal_enable_filters : std_logic;
	signal signal_readdata : std_logic_vector (63 downto 0);
	signal signal_writedata : std_logic_vector (63 downto 0);

	signal signal_inputA 	: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputB		: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputC 	: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputD		: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputE		: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputF		: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputG		: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputH 	: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputI 	: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputJ		: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputK 	: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputL		: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputM		: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputN		: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputO		: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputP 	: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputQ		: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputR 	: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputS		: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputT		: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputU		: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputV		: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputW 	: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputX		: UNSIGNED(15 downto 0) := x"0000";
	signal signal_inputY 	: UNSIGNED(15 downto 0) := x"0000";
	
	
	
	
	signal signal_magnitude: unsigned (7 downto 0) := x"00";
	signal signal_outputState: std_logic_vector(3 downto 0) := x"0";
begin


	Filter_inst_1 : component GeneralFilterTest
	PORT Map
	(
		clk => clk,
		en => '1',
		load => '1',
		filterSelectA => "11",
		filterSelectB => "00",
		filterSelectC => "01",
		gaussA =>	signal_inputA,
		gaussB =>	signal_inputB,
		gaussC =>	signal_inputC,
		gaussD =>	signal_inputD,
		gaussE =>	signal_inputE,
		gaussF =>	signal_inputF,
		gaussG =>	signal_inputG,
		gaussH =>	signal_inputH,
		gaussI =>	signal_inputI,
		gaussJ =>	signal_inputJ,
		gaussK =>	signal_inputK,
		gaussL =>	signal_inputL,
		gaussM =>	signal_inputM,
		gaussN =>	signal_inputN,
		gaussO =>	signal_inputO,
		gaussP =>	signal_inputP,
		gaussQ =>	signal_inputQ,
		gaussR =>	signal_inputR,
		gaussS =>	signal_inputS,
		gaussT =>	signal_inputT,
		gaussU =>	signal_inputU,
		gaussV =>	signal_inputV,
		gaussW =>	signal_inputW,
		gaussX =>	signal_inputX,
		gaussY =>	signal_inputY,
		magnitude =>	signal_magnitude
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
					----------------------------------------------------------------------------------
				when loadInputA=>							----------------------A--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputB;
					else
						state <= loadInputA;
					end if;
					----------------------------------------------------------------------------------
				when loadInputB=>							----------------------B--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputC;
					else
						state <= loadInputB;
					end if;
					----------------------------------------------------------------------------------
				when loadInputC=>							----------------------C--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputD;
					else
						state <= loadInputC;
					end if;
					----------------------------------------------------------------------------------
				when loadInputD=>							----------------------D--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputE;
					else
						state <= loadInputD;
					end if;
					----------------------------------------------------------------------------------
				when loadInputE=>							----------------------E--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputF;
					else
						state <= loadInputE;
					end if;
					----------------------------------------------------------------------------------
				when loadInputF=>							----------------------F--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputG;
					else
						state <= loadInputF;
					end if;
					----------------------------------------------------------------------------------
				when loadInputG=>							----------------------G--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputH;
					else
						state <= loadInputG;
					end if;
					----------------------------------------------------------------------------------
				when loadInputH=>							----------------------H--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputi;
					else
						state <= loadInputH;
					end if;
					
					----------------------------------------------------------------------------------
				when loadInputI=>							----------------------I--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputJ;
					else
						state <= loadInputI;
					end if;
					----------------------------------------------------------------------------------
				when loadInputJ=>							----------------------J--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputK;
					else
						state <= loadInputJ;
					end if;
					----------------------------------------------------------------------------------
				when loadInputK=>							----------------------K--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputL;
					else
						state <= loadInputK;
					end if;
					----------------------------------------------------------------------------------
				when loadInputL=>							----------------------L--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputM;
					else
						state <= loadInputL;
					end if;
					----------------------------------------------------------------------------------
				when loadInputM=>							----------------------M--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputN;
					else
						state <= loadInputM;
					end if;
					----------------------------------------------------------------------------------
				when loadInputN=>							----------------------N--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputO;
					else
						state <= loadInputN;
					end if;
					----------------------------------------------------------------------------------
				when loadInputO=>							----------------------O--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputP;
					else
						state <= loadInputO;
					end if;
					----------------------------------------------------------------------------------
				when loadInputP=>							----------------------P--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputQ;
					else
						state <= loadInputP;
					end if;
					----------------------------------------------------------------------------------
				when loadInputQ=>							----------------------Q--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputR;
					else
						state <= loadInputQ;
					end if;
					----------------------------------------------------------------------------------
				when loadInputR=>							----------------------R--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputS;
					else
						state <= loadInputR;
					end if;
					----------------------------------------------------------------------------------
				when loadInputS=>							----------------------S--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputT;
					else
						state <= loadInputS;
					end if;
					----------------------------------------------------------------------------------
				when loadInputT=>							----------------------T--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputU;
					else
						state <= loadInputT;
					end if;
				when loadInputU=>							----------------------U--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputv;
					else
						state <= loadInputU;
					end if;
				when loadInputv=>							----------------------V--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputw;
					else
						state <= loadInputv;
					end if;
					----------------------------------------------------------------------------------

				when loadInputw=>							----------------------W--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputX;
					else
						state <= loadInputw;
					end if;
					----------------------------------------------------------------------------------

				when loadInputX=>							----------------------X--------------------
					if write_avalon_s0 = '1' then
						state <= loadInputY;
					else
						state <= loadInputX;
					end if;
					----------------------------------------------------------------------------------
				when loadInputY=>							----------------------Y--------------------
					if write_avalon_s0 = '1' then
						state <= enableFilter;
					else
						state <= loadInputY;
					end if;
					----------------------------------------------------------------------------------
				when enableFilter=>							----------------------enableFilter--------------------
					if write_avalon_s0 = '1' then
						state <= dataReady;
					else
						state <= enableFilter;
					end if;
					----------------------------------------------------------------------------------
				when dataReady=>							----------------------dataReady--------------------
					if write_avalon_s0 = '1' then
						state <= readMagnitude;
					else
						state <= dataReady;
					end if;
				----------------------------------------------------------------------------------	
				when readMagnitude=>							----------------------readMagnitude--------------------
					if write_avalon_s0 = '1' then
						state <= idle;
					else
						state <= readMagnitude;
					end if;	
			----------------------------------------------------------------------------------
			end case;

		end if;
	end process;
	


-----------------------------------------------------------------------------------State Process ---------------------------------------------------------------------
			

	-- Determine the output based only on the current state
	-- and the input (do not wait for a clock edge).
stateProcess:	process (state, clk)
	begin
			case state is

				when idle =>
					
						readdata_avalon_s0(7 downto 0) <= x"FF";
						signal_outputState <= x"0";
					

				when loadInputA=>
					
						
						signal_inputA <= x"00" & unsigned(writedata_avalon_s0(7 downto 0)); --assigning 15 bits to the signal_inputA
						signal_outputState <= x"1";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"01";
						end if;
		--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
				when loadInputb=>
					
						
						signal_inputB <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"2";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"02";
						end if;
			--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
				when loadInputc=>
					
						signal_inputC <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"3";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"03";
						end if;
			--------------------------------------------------------------------------------
		------------------------------------------------------------------------------				
				when loadInputD=>
					
						signal_inputD <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"4";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"04";
						end if;
			--------------------------------------------------------------------------------
		------------------------------------------------------------------------------			
				when loadInputE=>
					
						signal_inputE <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"5";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"05";
						end if;
			--------------------------------------------------------------------------------
		------------------------------------------------------------------------------			
				when loadInputF=>
					
						signal_inputF <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"6";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"06";
						end if;
			--------------------------------------------------------------------------------
		------------------------------------------------------------------------------			
				when loadInputG=>
				
						signal_inputG <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"7";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"07";
						end if;
	--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
				when loadInputH=>

					signal_inputH <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"08";
						end if;
		--------------------------------------------------------------------------------
		------------------------------------------------------------------------------			
				when loadInputI=>

					signal_inputH <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"09";
						end if;
		--------------------------------------------------------------------------------
		------------------------------------------------------------------------------					
				when loadInputj=>

					signal_inputJ <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"10";
						end if;
		--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
				when loadInputK=>

					signal_inputK <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"11";
						end if;
		--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
				when loadInputL=>

					signal_inputL <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"12";
						end if;
	--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
		when loadInputM=>

					signal_inputM <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"13";
						end if;
	--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
		when loadInputN=>

					signal_inputN <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"14";
						end if;
	--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
		when loadInputO=>

					signal_inputO <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"15";
						end if;
	--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
		
			when loadInputP=>

					signal_inputP <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"16";
						end if;
	--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
			when loadInputQ=>

					signal_inputQ <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"17";
						end if;
	--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
				when loadInputR=>

					signal_inputR <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"18";
						end if;
	--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
					when loadInputS=>

					signal_inputS <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"19";
						end if;
	--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
					when loadInputT=>

					signal_inputT <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"20";
						end if;
	--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
					when loadInputU=>

					signal_inputU <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"21";
						end if;
	--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
						when loadInputV=>

					signal_inputV <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"22";
						end if;
	--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
					when loadInputW=>

					signal_inputW <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"23";
						end if;
	--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
					when loadInputX=>

					signal_inputX <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						IF(read_avalon_s0 = '1') THEN
						readdata_avalon_s0(7 downto 0) <= x"24";
						end if;
	--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
					when loadInputY=>

					signal_inputY <= x"00" & unsigned(writedata_avalon_s0(7 downto 0));
						signal_outputState <= x"8";
						IF(read_avalon_s0 = '1') THEN
							readdata_avalon_s0(7 downto 0) <= x"25";
						end if;
	--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
				when enableFilter=>
					IF(read_avalon_s0 = '1') THEN
						signal_outputState <= x"9";
						readdata_avalon_s0(7 downto 0) <= x"25";
					end if;
					
		--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
				when dataReady =>
					if read_avalon_s0 = '1' then
						readdata_avalon_s0(7 downto 0) <= x"AA";
						
					end if;
					signal_outputState <= x"A";
			--------------------------------------------------------------------------------
		------------------------------------------------------------------------------
				when readMagnitude=>
					if read_avalon_s0 = '1' then
						readdata_avalon_s0(7 downto 0) <=  std_logic_vector(signal_magnitude);
						
						outputMagnitudeA <= signal_magnitude;
					end if;
					signal_outputState <= x"B";

			end case;
	end process;
outputState <= signal_outputState;
end architecture;

