-module(power_motor).
-export([enable_power/0, disable_power/0, start_motor/1, stop_motor/1, set_period/2, set_duty/2]).

-define(M1, 0).
-define(M2, 1).
-define(M3, 2).
-define(M4, 3).

-define(MCTL, 16#00).
-define(MDUT, 16#01).
-define(MPER, 16#02).
-define(MANG, 16#03).
-define(MTMR, 16#04).
-define(MVAL, 16#05).
-define(MERR, 16#06).

-define(MOT_ENABLE, 16#8000).
-define(MOT_AUTO,   16#4000).
%mot_angle = 0x2000
%mot_back = 0x0010
%mot_brake = 0x0008
-define(MOT_POWER,  16#0003).

enable_power() -> os:cmd("echo 1 > /sys/class/gpio/gpio62/value").

disable_power() -> os:cmd("echo 0 > /sys/class/gpio/gpio62/value").

%set_duty(Motor, Value) -> usb_protocol:write_reg(Motor, utils:limit({-100, 100}, Value), ?MDUT).

set_period(Motor, Value) -> usb_protocol:write_reg(Motor, ?MPER, Value).

set_duty(Motor, Value) -> usb_protocol:write_reg(Motor, ?MDUT, Value).

start_motor(Motor) -> usb_protocol:write_reg(Motor, ?MCTL, ?MOT_ENABLE + ?MOT_POWER).

stop_motor(Motor) -> usb_protocol:write_reg(Motor, ?MCTL, ?MOT_ENABLE).

