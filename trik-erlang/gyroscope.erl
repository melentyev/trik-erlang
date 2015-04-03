-module(gyroscope).
-export([subscribe/2]).

-include("model.hrl").

subscribe(Model, Callback) -> sensor_3d:subscribe(Model#model.gyroscope_pid, Callback).