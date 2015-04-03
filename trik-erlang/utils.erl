-module(utils).
-export([limit/2]).

limit({Lo, Hi}, Value) -> if Value < Lo -> Lo; Value > Hi -> Hi; true -> Value end.