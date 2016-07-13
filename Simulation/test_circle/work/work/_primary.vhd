library verilog;
use verilog.vl_types.all;
entity work is
    generic(
        LO              : vl_logic := Hi0;
        HI              : vl_logic := Hi1;
        X               : vl_logic := HiX;
        r_IDLE          : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        r_INIT          : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        r_WORK          : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        r_JUDGE         : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        r_0VER          : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1)
    );
    port(
        pulse_clk       : in     vl_logic;
        sys_rst_l       : in     vl_logic;
        direct          : in     vl_logic;
        Xs              : in     vl_logic_vector(15 downto 0);
        Ys              : in     vl_logic_vector(15 downto 0);
        Xe              : in     vl_logic_vector(15 downto 0);
        Ye              : in     vl_logic_vector(15 downto 0);
        change_readyH   : in     vl_logic;
        X_acc           : out    vl_logic;
        Y_acc           : out    vl_logic;
        X_dec           : out    vl_logic;
        Y_dec           : out    vl_logic;
        draw_overH      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of LO : constant is 1;
    attribute mti_svvh_generic_type of HI : constant is 1;
    attribute mti_svvh_generic_type of X : constant is 1;
    attribute mti_svvh_generic_type of r_IDLE : constant is 1;
    attribute mti_svvh_generic_type of r_INIT : constant is 1;
    attribute mti_svvh_generic_type of r_WORK : constant is 1;
    attribute mti_svvh_generic_type of r_JUDGE : constant is 1;
    attribute mti_svvh_generic_type of r_0VER : constant is 1;
end work;
