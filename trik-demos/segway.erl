-module(segway)
-export(run/0)



run() -> 
    Model = model:init(),
    Btn = model:get_buttonModel