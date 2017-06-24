-- vim: tabstop=4 shiftwidth=4 expandtab

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Create tag table for each screen
awful.screen.connect_for_each_screen(function(s)
    awful.tag({ "1" }, s, awful.layout.suit.spiral)
end)

-- Global key bindings
root.keys(gears.table.join(
    -- MOD + CTRL + Q
    -- Quit awesome
    awful.key({ "Mod4", "Control" }, "q", awesome.quit),
    -- MOD + CTRL + R
    -- Restart awesome
    awful.key({ "Mod4", "Control" }, "r", awesome.restart),
    -- MOD + RETURN
    -- Open a terminal
    awful.key({ "Mod4" }, "Return", function() awful.spawn("xterm") end)))

-- Make focus follow mouse
client.connect_signal("mouse::enter", function(c) client.focus = c end)
