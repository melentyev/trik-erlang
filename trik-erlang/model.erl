-module(model).
-export([init/0]).

-include("model.hrl").
-include("model_config.hrl").

init() -> 
    #model{ 
        button_pad_pid = button_pad:start(),
        accelerometer_pid = sensor_3d:start(?ACCEL_LIMS, ?ACCEL_PATH),
        gyroscope_pid = sensor_3d:start(?GYRO_LIMS, ?GYRO_PATH)
    }.

