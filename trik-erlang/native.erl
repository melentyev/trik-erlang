-module(native).

-export([hello/0, world/1, fwrite_string/2, echo_string/1, usb_protocol_write_reg/3]).
-on_load(init/0).

init() ->
    ok = erlang:load_nif("./native", 0).

hello() ->
    exit(nif_library_not_loaded).

world(_Y) ->
    exit(nif_library_not_loaded).

fwrite_string(_Path, _Data) ->
    exit(nif_library_not_loaded).

echo_string(_Str) -> 
    exit(nif_library_not_loaded).

usb_protocol_write_reg(_Devaddr, _Regaddr, _Regval) ->
    exit(nif_library_not_loaded).