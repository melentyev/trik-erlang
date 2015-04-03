-module(accelerometer).
-export([subscribe/2]).

-include("model.hrl").

subscribe(Model, Callback) -> sensor_3d:subscribe(Model#model.accelerometer_pid, Callback).