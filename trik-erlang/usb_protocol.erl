-module(usb_protocol).
-export([write_reg/3]).
-include("model_config.hrl").

-define(HEX_FF, 16#FF).

write_reg(Devaddr, Regaddr, Regval) ->
    Funcnum = 16#03,
    Crc = 
        (
            ?HEX_FF - 
            (
                Devaddr + Funcnum + Regaddr + (Regval band ?HEX_FF) + ((Regval bsr 8) band ?HEX_FF) 
                + ((Regval bsr 16) band ?HEX_FF) + ((Regval bsr 24) band ?HEX_FF)
            ) + 1
        ) band ?HEX_FF,
    FmtStr = "echo \":~2.16.0B~2.16.0B~2.16.0B~8.16.0B~2.16.0B\" > " ?USB_DEVFILE1,
    Stmp = lists:flatten(io_lib:fwrite(FmtStr, [Devaddr, Funcnum, Regaddr, Regval, Crc])),
    %Stmp = ":%02X%02X%02X%08X%02X\n" % (devaddr, funcnum, regaddr, regval, crc)
    %file:write_file(?USB_DEVFILE1, Stmp). 
    %io:format(Stmp ++ "~n", []),
    os:cmd(Stmp).


%read_reg() -> 
    