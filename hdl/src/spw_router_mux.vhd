-- TODO: handle ascending port direction
-- TODO: read gAllow_backoute from a file
-- TODO: expose gAllow_backroute to sw via apb regs
-- TODO: implement mux logic that doesnt support "backrouting"

library ieee;
use ieee.std_logic_1164.all;


entity spw_router_mux is
    generic (
        gAllow_backroute: boolean -- allow a pkg to be routed to source port
    );
    port (
        iValid: in std_logic_vector; -- len = port num(pn)
        iData: in std_logic_vector; -- len = pn*9
        oAck: out std_logic_vector; -- len = pn

        oValid: out std_logic_vector; -- len = pn*pn
        oData: out std_logic_vector; -- len = pn*pn*9
        iAck: in std_logic_vector -- len = pn*pn
    );
end entity;

architecture v1 of spw_router_mux is

    constant cW: natural := iValid'length;
    constant cDw: natural := iData'length/cW;
    constant cZero_v: std_logic_vector (cW-1 downto 0) := (others => '0');

begin

    assert gAllow_backroute = true
        report "feature not implemented. patches are welcome"
        severity failure;

    -- TODO: add port length traps here

    oports: for i in 0 to cW-1 generate
        signal sAck_slice: std_logic_vector (cW-1 downto 0);
    begin

        oValid ((i+1)*cW-1 downto i*cW) <= iValid;
        oData ((i+1)*cW*cDw-1 downto i*cW*cDw) <= iData;
        sAck_slice <= iAck ((i+1)*cW-1 downto i*cW);
        oAck (i) <= '0' when sAck_slice = cZero_v else '1';

    end generate;

end v1;
