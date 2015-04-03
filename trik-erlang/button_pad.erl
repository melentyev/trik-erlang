-module(button_pad).
-export([subscribe/2, start/0]).
-include("model.hrl").
-include("model_config.hrl").
-include("button_pad.hrl").

%parse_packet(Data) ->
%    << _:64, EvType:16, EvCode:16, EvValue:16>> = Data,
%    if 
%        EvType == 1 -> 
%        true -> none 
%    end.

parse_packet(_, << _:64, EvType:16, _:16, _:16>>) when EvType /= 1 -> none;
parse_packet(_, << _:64, _:16, EvCode:16, EvValue:16>>) -> 
    #button_event{code=EvCode, is_pressed=(EvValue == 1)}. 

start() -> spawn(binary_fifo_sensor, run, [?BUTTON_PAD_PATH, {16 * 8, fun parse_packet/2}, []]).

subscribe(Model, Callback) -> binary_fifo_sensor:subscribe(Model#model.button_pad_pid, Callback).


 