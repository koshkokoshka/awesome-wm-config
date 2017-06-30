-- vim: tabstop=4 shiftwidth=4 expandtab

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- Widget and layout library
local wibox = require("wibox")

-- Variable definitions
terminal = os.getenv("TERMINAL") or "xterm"
modkey = "Mod4"

-- Wibar setup
local taglistbuttons = gears.table.join(
    -- LMB
    -- Switch to tag
    awful.button({ }, 1, function(t) t:view_only() end))

local tasklistbuttons = gears.table.join(
    -- LMB
    -- Focus on a client
    awful.button({ }, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c.minimized = false
            client.focus = c;
            c:raise()
        end
    end),
    -- MMB
    -- Close a client
    awful.button({ }, 2, function(c) c:kill() end))

awful.screen.connect_for_each_screen(function(s)
    -- Tag list
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.suit.floating)

    -- Widgets
    awful.wibar({ position = "top", screen = s }):setup {
        layout = wibox.layout.align.horizontal,
        awful.widget.taglist(s, awful.widget.taglist.filter.all, taglistbuttons),
        awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklistbuttons) }
end)

-- Global key bindings
globalkeys = gears.table.join(
    -- MOD + CTRL + Q
    -- Quit awesome
    awful.key({ modkey, "Control" }, "q", awesome.quit),
    -- MOD + CTRL + R
    -- Restart awesome
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    -- MOD + RETURN
    -- Open a terminal
    awful.key({ modkey }, "Return", function() awful.spawn(terminal) end),
    -- MOD + TAB
    -- Focus on the previous window
    awful.key({ modkey }, "Tab", function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end))

root.keys(globalkeys)

-- Client key bindings
clientkeys = gears.table.join(
    -- CTRL + W
    -- Close the current window
    awful.key({ "Ctrl" }, "w", function(c)
        awful.client.focus.history.previous()
        c:kill()
    end))

-- Client button bindings
clientbuttons = gears.table.join(
    awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Window rules
awful.rules.rules = {
    -- Default rule
    { rule = { },
      properties = {
        placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        border_width = 1,
        focus = awful.client.focus.filter,
        keys = clientkeys,
        buttons = clientbuttons } }
}

-- Make focus follow mouse
client.connect_signal("mouse::enter", function(c) client.focus = c end)
