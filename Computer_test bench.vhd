library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Computer18_tb is
end Computer18_tb;

architecture Behavioral of Computer18_tb is
    -- Component 
    component Computer18 is
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    -- Signals for testbench
    signal clk_tb : STD_LOGIC := '0';
    signal reset_tb : STD_LOGIC := '0';
    signal data_out_tb : STD_LOGIC_VECTOR(2 downto 0);

    -- Clock period 
    constant clk_period : time := 10 ns;

    -- Function to convert STD_LOGIC_VECTOR to string for reporting
    function to_string(slv : STD_LOGIC_VECTOR) return string is
        variable result : string(1 to slv'length);
    begin
        for i in slv'range loop
            result(i) := character'VALUE(STD_ULOGIC'IMAGE(slv(i)));
        end loop;
        return result;
    end function;

begin
    -- Device Under Test
    uut: Computer18
        Port map (
            clk => clk_tb,
            reset => reset_tb,
            data_out => data_out_tb
        );

    -- Clock process definition
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    --process
    stim_proc: process
    begin
        -- Reset the system
        reset_tb <= '0';

        -- Iterate over all program memory addresses (0 to 7)
        for i in 0 to 7 loop
            wait for clk_period * 8;

            -- Check the output (You can add specific checks here based on expected results)
            report "Program memory index: " & integer'image(i) & " -> Output: " & to_string(data_out_tb);
            wait for clk_period * 5;
        end loop;

        -- End of test
        wait;
    end process;

end Behavioral;
