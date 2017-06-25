-- vim: tabstop=4 shiftwidth=4 expandtab

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Create tag table for each screen
awful.screen.connect_for_each_screen(function(s)
    awful.tag({ "1" }, s, awful.layout.suit.floating)
end)

-- Global key bindings
globalkeys = gears.table.join(
    -- Awesome
    awful.key({ "Mod4", "Control" }, "q", awesome.quit),
    awful.key({ "Mod4", "Control" }, "r", awesome.restart),
    -- Standard applications
    awful.key({ "Mod4" }, "Return", function() awful.spawn("xterm") end),
    -- Focus
    awful.key({ "Mod4" }, "Tab", function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end))

root.keys(globalkeys)

clientkeys = gears.table.join(
    awful.key({ "Ctrl" }, "w", function(c) c:kill() end))

clientbuttons = gears.table.join(
    awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
    awful.button({ "Mod4" }, 1, awful.mouse.client.move),
    awful.button({ "Mod4" }, 3, awful.mouse.client.resize))

-- Setup rules for appearing windows
awful.rules.rules = {
    { rule = { },
      properties = {
        focus = awful.client.focus.filter,
        keys = clientkeys,
        buttons = clientbuttons } }
}

-- Make focus follow mouse
client.connect_signal("mouse::enter", function(c) client.focus = c end)
