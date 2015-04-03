-module(native_interop).
-export(init/3, ).

-on_load(init_library/0).

init_library() -> ok = erlang:load_nif("./complex6_nif", 0).
init(Cmd, DeviceId, Forced) -> i2c_lock_call(i2c_init, (Cmd, DeviceId, Forced))
    let inline Send command data len = I2CLockCall wrap_I2c_SendData (command, data, len)  
    let inline Receive (command: int) = I2CLockCall wrap_I2c_ReceiveData command