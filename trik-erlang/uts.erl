-module(uts).
-export([random_binary/1]).

random_binary(Size) ->
    Flag = process_flag(trap_exit, true),
    Cmd = lists:flatten(io_lib:format("head -c ~p /dev/urandom~n", [Size])),
    Port = open_port({spawn, Cmd}, [binary]),
    Data = random_binary(Port, []),
    process_flag(trap_exit, Flag),
    Data.
 
random_binary(Port, Sofar) ->
    receive
        {Port, {data, Data}} ->
                random_binary(Port, [Data|Sofar]);
        {'EXIT', Port, _Reason} ->
                list_to_binary(lists:reverse(Sofar))
    end.