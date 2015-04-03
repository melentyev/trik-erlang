-module(sensor_3d).
-export([subscribe/2, start/2]).
-include("model.hrl").
-include("model_config.hrl").

-define(EV_ABS, 3).

%parse_packet( { Pt, Lims }, << _:64, EvType:16, EvCode:16, EvValue:32>>) when EvType == 1 andalso EvCode < 3 -> 
%    io:format("setelement (~p)~n", [EvCode + 1]),
%    { { setelement(EvCode + 1, Pt, utils:limit(Lims, EvValue) ), Lims }, none };
%parse_packet( { Pt, Lims }, _ ) -> { { Pt, Lims }, Pt }.


%parse_packet( { Pt, Lims }, Dat) ->  
%    io:format("parse_packet(~p)~n", [bit_size(Dat)]);
parse_packet( { Pt, Lims }, << _:8/binary, EvType:16, EvCode:16, EvValue:32>>) -> 
    io:format("parse_packet(~p ~p ~p)~n", [EvType, EvCode, EvValue]),
    { { setelement(EvCode + 1, Pt, utils:limit(Lims, EvValue) ), Lims }, none }.

start(Lims, DevPath) -> spawn(binary_fifo_sensor, run, [DevPath, { 16, fun parse_packet/2 }, { { 0, 0, 0 }, Lims } ] ).

subscribe(Pid, Callback) -> binary_fifo_sensor:subscribe(Pid, Callback).
    