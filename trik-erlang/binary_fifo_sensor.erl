-module(binary_fifo_sensor).
-export([run/3, subscribe/2]).
-include("model.hrl").
-include("model_config.hrl").

run(Path, Opts, State) -> 
    Flag = process_flag(trap_exit, true),   
    Port = open_port({spawn, string:concat("cat ", Path)}, [binary]),
    main_loop(Port, [], <<>>, Opts, State),
    process_flag(trap_exit, Flag).

%    case file:open("/dev/input/event0", [read, binary]) of
%        {ok, File}  -> main_loop(File, Callback);
%        {error, Reason} -> io:format("main_loop/1:error: ~p~n", [Reason])
%    end.

handle_data(Data, {PacketSize, _}, Events, State) when bit_size(Data) < (PacketSize bsl 3) -> { Data, Events, State };
handle_data(Data, {PacketSize, ParseFunc}, Events, State) ->
    %io:format("getsize: ~p~n", [bit_size(Data)]),
    <<Packet:PacketSize/binary, Tail/binary>> = Data,
    { NewState, OptEvent } = ParseFunc(State, Packet),
    NewEvents = case OptEvent of none -> Events; Event -> [ Event | Events ] end,
    handle_data(Tail, {PacketSize, ParseFunc}, NewEvents,  NewState).

main_loop(Port, Subs, Tail, Opts, State) ->
    receive
        { subscribe, Callback } -> main_loop(Port, [Callback | Subs], Tail, Opts, State);
        { Port, {data, Data} } -> 
            { NewTail, Events, NewState } = handle_data(<<Tail/binary, Data/binary>>, Opts, [], State),
            io:format("packet parsed ~n", []),
            lists:foreach(fun (Cb) -> lists:foreach(Cb, Events) end, Subs),
            %lists:foreach(fun (Ev) -> lists:foreach(fun (Cb) -> Cb(Ev), Subs) end, Events),
            main_loop(Port, Subs, NewTail, Opts, NewState);
        { 'EXIT', Port, _Reason } -> io:format("EXIT: ~p~n", [_Reason])
    end.

subscribe(Pid, Callback) -> Pid ! { subscribe, Callback }.
    
%main_loop(File, Callback) -> 
%    case file:read(File, 16) of
%        {ok, Data} -> Callback(Data);
%        {error, Reason} -> io:format("main_loop/2:error: ~p~n", [Reason])
%    end,
%    main_loop(File, Callback).