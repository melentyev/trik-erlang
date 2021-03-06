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
    %FmtStr = "echo \":~2.16.0B~2.16.0B~2.16.0B~8.16.0B~2.16.0B\" > " ?USB_DEVFILE1,
    FmtStr = ":~2.16.0B~2.16.0B~2.16.0B~8.16.0B~2.16.0B~n",
    Stmt = lists:flatten(io_lib:fwrite(FmtStr, [Devaddr, Funcnum, Regaddr, Regval, Crc])),

    %Stmt = ":%02X%02X%02X%08X%02X\n" % (devaddr, funcnum, regaddr, regval, crc)    
    
    %io:format(Stmt ++ "~n", []),

    %os:cmd(Stmt).
    native:fwrite_string(?USB_DEVFILE1, Stmt).


%read_reg() -> 
    