library ieee;
use ieee.std_logic_1164.all;

entity testbenchLcd is
end testbenchLcd;

architecture behavioural of testbenchLcd is
    component LcdDriver
        port
        (
            -- communication between CPU and LcdDriver
            Clk_CI:         	    in std_logic;
            Reset_NRI:      	    in std_logic;
            Address_DI:     	    in std_logic_vector (1 downto 0);
            Write_SI:       	    in std_logic;
            WriteData_DI:		    in std_logic_vector (15 downto 0);
            Read_SI:		        in std_logic;
            ByteEnable_DI:          in std_logic;
            BeginBurstTransfer_DI:  in std_logic;
            BurstCount_DI:          in std_logic_vector (7 downto 0);
            
            WaitReq_SO:             out std_logic;
            ReadData_DO:		    out std_logic_vector (15 downto 0);
            
          
            -- communication from LcdDriver to LCD
            DB_DIO:      		    inout std_logic_vector (15 downto 0);
            Rd_NSO:                 out std_logic;
            Wr_NSO:                 out std_logic;
            Cs_NSO:                 out std_logic;
            DC_NSO:                 out std_logic;
            LcdReset_NRO:           out std_logic;
            IM0_SO:                 out std_logic
        );
    end component;

   --declare inputs and initialize them
    -- communication between CPU and LcdDriver
    signal Clk_S:         	        std_logic;
    signal Reset_NR:                std_logic;
    signal Address_D:     	        std_logic_vector (1 downto 0);
    signal Write_S:       	        std_logic;
    signal WriteData_D:		        std_logic_vector (15 downto 0);
    signal Read_S:		            std_logic;
    signal ByteEnable_D:            std_logic;
    signal BeginBurstTransfer_D:    std_logic;
    signal BurstCount_D:            std_logic_vector (7 downto 0);

    signal WaitReq_S:               std_logic;
    signal ReadData_D:		        std_logic_vector (15 downto 0);
    
    signal DB_D:      		        std_logic_vector (15 downto 0);
    signal Rd_NS:                   std_logic;
    signal Wr_NS:                   std_logic;
    signal Cs_NS:                   std_logic;
    signal DC_NS:                   std_logic;
    signal LcdReset_NR:             std_logic;
    signal IM0_S:                   std_logic;    
    
    
    signal Time_S:               time := 0 ns;

    constant TimeMax_C:          time := 1000 ns;
    constant Clk_period_C :      time := 20 ns;
begin   
    LCD: LcdDriver port map(
                            Clk_CI => Clk_S,	    
                            Reset_NRI => Reset_NR,      	    
                            Address_DI => Address_D,  
                            Write_SI => Write_S,
                            WriteData_DI => WriteData_D,    
                            Read_SI => Read_S,
                            ByteEnable_DI => ByteEnable_D,      
                            BeginBurstTransfer_DI => BeginBurstTransfer_D,
                            BurstCount_DI => BurstCount_D,
                            WaitReq_SO => WaitReq_S,
                            ReadData_DO => ReadData_D,
                            DB_DIO => DB_D,
                            Rd_NSO => Rd_NS,                 
                            Wr_NSO => Wr_NS,        
                            Cs_NSO => Cs_NS,        
                            DC_NSO => DC_NS,        
                            LcdReset_NRO => LcdReset_NR,        
                            IM0_SO => IM0_S
                            );

   clk_process :process
   begin
        if(Time_S < TimeMax_C)then
            Clk_S <= '0';
            wait for Clk_period_C/2;
            Clk_S <= '1';
            wait for Clk_period_C/2;
            Time_S <= Time_S + Clk_period_C;
        else
            wait;
        end if;
   end process;
   
   -- Stimulus process
  stim_proc: process
   begin         
        wait for 7 ns;
            Reset_NR <='0';
        wait for Clk_period_C;
            Reset_NR <= '1';
        wait for Clk_period_C;
            Address_D <= "00";
            WriteData_D <= (others => '1');
            BeginBurstTransfer_D <= '0';
            BurstCount_D <= (others => '0');
            ByteEnable_D <= '1';
        
        wait for 4 * Clk_period_C;        
            Write_S <= '1';
        wait for 4 * Clk_period_C;      
            Write_S <= '0';
        wait for 4 * Clk_period_C;
            Address_D <= "01";
            WriteData_D <= "0101010101010101";
            BeginBurstTransfer_D <= '0';
            BurstCount_D <= (others => '0');
            ByteEnable_D <= '1';
            Write_S <= '1';
        wait for 4 * Clk_period_C; 
            Write_S <= '0';
            Address_D <= "00";
            WriteData_D <= (others => '0');
            BeginBurstTransfer_D <= '0';
            BurstCount_D <= (others => '0');
            ByteEnable_D <= '0';
        -- wait for 4 * Clk_period_C;        
            -- Write_S <= '1';
        -- wait for 4 * Clk_period_C;      
            -- Write_S <= '0';
        wait;
  end process;
end;
