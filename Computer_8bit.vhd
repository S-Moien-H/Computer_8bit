library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Computer18 is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        data_out : out STD_LOGIC_VECTOR(2 downto 0)
    );
end Computer18;

architecture Behavioral of Computer18 is
    -- Input Memory
    type memory_array is array (0 to 7) of STD_LOGIC_VECTOR(2 downto 0);
    signal memory : memory_array := (
        0 => "000",
        1 => "001",
        2 => "010",
        3 => "011",
        4 => "100",
        5 => "101",
        6 => "110",
        7 => "111"
    );

    -- Program Memory
    type Program_memory_array is array (0 to 7) of STD_LOGIC_VECTOR(7 downto 0);
    signal Program_memory : Program_memory_array := (
        0 => "00001000",
        1 => "00100010",
        2 => "01110100",
        3 => "01111011",
        4 => "10111110",
        5 => "10100111",
        6 => "11111000",
        7 => "11010001"
    );

    -- Signals
    signal select1, select2 : STD_LOGIC_VECTOR(2 downto 0);
    signal decoder_in : STD_LOGIC_VECTOR(1 downto 0);
    signal mux1_out, mux2_out : STD_LOGIC_VECTOR(2 downto 0);
    signal alu_out : STD_LOGIC_VECTOR(2 downto 0);
    signal decoded_control : STD_LOGIC_VECTOR(3 downto 0);
    signal input_mem : STD_LOGIC_VECTOR(7 downto 0); 
    signal mem_index : INTEGER range 0 to 7 := 0; 

begin
    -- Memory line selection
    process(clk, reset)
    begin
        if reset = '1' then
            mem_index <= 0;
        elsif rising_edge(clk) then
            input_mem <= Program_memory(mem_index);
            if mem_index < 7 then
                mem_index <= mem_index + 1;
            else
                mem_index <= 0;
            end if;
        end if;
    end process;

    -- Reading the program
    process(input_mem)
    begin
        decoder_in <= input_mem(7 downto 6);
        select1 <= input_mem(5 downto 3); 
        select2 <= input_mem(2 downto 0); 
    end process;

    -- Mux 8 to 1 -1
    process(select1)
    begin
        mux1_out <= memory(to_integer(unsigned(select1)));
    end process;

    -- Mux 8 to 1 -2
    process(select2)
    begin
        mux2_out <= memory(to_integer(unsigned(select2)));
    end process;

    -- Decoder 2 to 4
    process(decoder_in)
    begin
        case decoder_in is
            when "00" => decoded_control <= "0001";
            when "01" => decoded_control <= "0010";
            when "10" => decoded_control <= "0100";
            when "11" => decoded_control <= "1000";
            when others => decoded_control <= "0000";
        end case;
    end process;

    -- ALU
    process(mux1_out, mux2_out, decoded_control)
    begin
        case decoded_control is
            when "0001" =>
                alu_out <= std_logic_vector(unsigned(mux1_out) + unsigned(mux2_out));
            when "0010" =>
                alu_out <= std_logic_vector(unsigned(mux1_out) - unsigned(mux2_out));
            when "0100" =>
                alu_out <= mux1_out AND mux2_out;
            when "1000" =>
                alu_out <= mux1_out OR mux2_out;
            when others =>
                alu_out <= (others => '0');
        end case;
    end process;

    -- Write ALU Output to Input Memory based on select1
    process(clk, reset)
    begin
        if reset = '1' then
            memory <= (
                0 => "000",
                1 => "001",
                2 => "010",
                3 => "011",
                4 => "100",
                5 => "101",
                6 => "110",
                7 => "111"
            );
        elsif rising_edge(clk) then
            memory(to_integer(unsigned(select1))) <= alu_out;
        end if;
    end process;

    data_out <= alu_out;

end Behavioral;
