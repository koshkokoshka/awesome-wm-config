-- vim: tabstop=4 shiftwidth=4 expandtab

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- Widget and layout library
local wibox = require("wibox")

-- Create tag table for each screen
local tasklistbuttons = gears.table.join(
    -- LMB
    -- Focus on a client
    awful.button({ }, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c.minimized = false
            c:raise()
            client.focus = c;
        end
    end),
    -- MMB
    -- Close a client
    awful.button({ }, 2, function(c) c:kill() end)
)

awful.screen.connect_for_each_screen(function(s)
    awful.tag({ "1" }, s, awful.layout.suit.spiral)

    s.tasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklistbuttons)
    s.wibar = awful.wibar({ position = "top", screen = s })
    s.wibar:setup {
        layout = wibox.layout.align.horizontal,
        s.tasklist
    }
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
