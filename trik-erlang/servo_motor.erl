-module(servo_motor).
-export([init/2]).
-include("servo_motor.hrl")

set_option(Target, V) = file:write_file(ServoPath + "/" + Target, V)

init(ServoPath, Opts) -> 
    SetOptions = [ 
        { "request", "0" }, 
        { "request", "1" }
        { "run", "1" }, 
        { "period_ns", Opts.period} ],
    lists:foreach(fun ({F, V}) -> set_option(F, V) end, SetOptions).
    #servo_motor{path=ServoPath, opts=Opts}

write_duty(#servo_motor{path=Path}, Duty) = file:write_file(Path + "/duty_ns", Duty)

set_power(Servo, Value) = 
    V = utils:limit({-100, 100}, Value),
    Range = if V < 0 -> kind.zero - kind.min; true -> kind.max - kind.zero end,
    Duty = (Opts.zero + range * V / 100),
    write_duty(Duty).
            
zero(Servo) -> write_duty(Servo, Servo#servo_motor.opts#servo_opts.zero) 