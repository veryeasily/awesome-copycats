local awful = require("awful")
local naughty = require("naughty")

local naughtyvolumeid = nil
function change_volume(how)
    os.execute("amixer -q sset Master " .. how)
    awful.spawn.with_line_callback("amixer get Master | tail -n 1", {
        stdout = function (line) 
            naughtybrightid = naughty.notify({
                text = line,
                title = "Volume",
                replaces_id = naughtybrightid
            }).id
        end
    })
end

function make_global_keys(modkey)
    local globalkeys = awful.util.table.join(
        -- Audio keys
        awful.key({ }, "XF86AudioRaiseVolume",
            function () change_volume("3%+") end
        ),
        awful.key({ }, "XF86AudioLowerVolume",
            function () change_volume("3%-") end
        ),
        awful.key({"Shift"}, "XF86AudioRaiseVolume",
            function () change_volume("1%+") end
        ),
        awful.key({"Shift"}, "XF86AudioLowerVolume",
            function () change_volume("1%-") end
        ),
        awful.key({ }, "XF86AudioMute",
            function () change_volume("toggle") end
        ),
        awful.key({ }, "XF86AudioMicMute",
            function () awful.util.spawn("amixer -D pulse set Capture 1+ toggle", false) end
        ),
    
        -- Brightness
        awful.key({ }, "XF86MonBrightnessUp",
            function() change_brightness("-A 5") end
        ),
        awful.key({ }, "XF86MonBrightnessDown",
            function() change_brightness("-U 5") end
        ),
        awful.key({ "Shift"}, "XF86MonBrightnessUp",
            function() change_brightness("-A 1") end
        ),
        awful.key({ "Shift"}, "XF86MonBrightnessDown",
            function() change_brightness("-U 1") end
        ),
    
        -- Lock
    	awful.key({ }, "XF86Search",
              function ()
                  awful.util.spawn("sync")
                  awful.util.spawn("xautolock -enable")
                  awful.util.spawn("xautolock -locknow")
              end
    	),
    	awful.key({"Shift"}, "XF86Search",
              function () awful.util.spawn("xautolock -toggle") end
    	),

        -- Media Keys
        awful.key({}, "XF86AudioNext",
            function () awful.util.spawn("mediacontrol Next") end
        ),
        awful.key({}, "XF86AudioPrev",
            function () awful.util.spawn("mediacontrol Previous") end
        ),
        awful.key({}, "XF86AudioPlay",
            function () awful.util.spawn("mediacontrol PlayPause") end
        ),
        awful.key({}, "Print",
            function () awful.util.spawn("shutter --disable_systray") end
        ),
        awful.key({ "Shift" }, "Print",
            function () awful.util.spawn("/home/mors/bin/sharenix-window") end
        ),
        awful.key({ modkey, "Shift" }, "Print",
            function () awful.util.spawn("shutter -s --disable_systray") end
        ),

        -- Toggle wibox.
        awful.key({ modkey}, "b",
                  function ()
                      local screen = awful.screen.focused()
                      screen.mywibox.visible = not screen.mywibox.visible
                  end,
                  {description = "toggle wibox on current screen"}
        ),

        -- Open file manager
        awful.key({ modkey}, "o",
            function () awful.util.spawn("nautilus --no-desktop") end
        )
    )
    
    return globalkeys
end

return make_global_keys
