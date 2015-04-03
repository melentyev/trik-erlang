-module(simple_test).
-export([run/0, from_shell1/0, from_shell_stop/0, gyr_tst/0, test_echo_motor/1]).

on_btn_press(Ev) -> io:format("Button: ~p~n", [Ev]).
on_accel(Ev) -> io:format("Accel: ~p~n", [Ev]).

run() -> 
    Model = model:init(),
    button_pad:subscribe(Model, fun on_btn_press/1),
    accelerometer:subscribe(Model, fun on_accel/1),
    io:get_line("get_line:"),
    io:format("Finished.").

from_shell1() ->
    power_motor:enable_power(),
    power_motor:set_period(1, 16#1000),
    power_motor:start_motor(1),
    power_motor:set_duty(1, 16#800).

from_shell_stop() ->
    power_motor:start_motor(0),
    power_motor:disable_power().

on_gyro({X,Y,_}) -> io:format("G: ~p ~p ~n", [X, Y]).

gyro_test_loop() -> 
    io:get_line("Waiting for keypress:~n").

gyr_tst() -> 
    Model = model:init(),
    gyroscope:subscribe(Model, fun on_gyro/1),
    gyro_test_loop().

test_echo_motor(Cnt) when Cnt =< 0 -> ok;
test_echo_motor(Cnt) -> power_motor:set_duty(1, 16#500 + Cnt), test_echo_motor(Cnt - 1).


