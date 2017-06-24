-- vim: tabstop=4 shiftwidth=4 expandtab

local gears = require("gears")
local awful = require("awful")

awful.screen.connect_for_each_screen(function(s)
    awful.tag({ "1" }, s, awful.layout.suit.spiral)
end)

root.keys(gears.table.join(
    awful.key({ "Mod4", "Control" }, "q", awesome.quit),
    awful.key({ "Mod4", "Control" }, "r", awesome.restart),
    awful.key({ "Mod4" }, "Return", function() awful.spawn("xterm") end)))

client.connect_signal("mouse::enter", function(c) client.focus = c end)
