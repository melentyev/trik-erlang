-define(SYNC, 0).
-define(ESC, 1).
-define(ENTER, 28).
-define(UP, 103).
-define(LEFT, 105).
-define(RIGHT, 106).
-define(DOWN, 108).
-define(POWER, 116).

-record(button_event, {code, is_pressed}).