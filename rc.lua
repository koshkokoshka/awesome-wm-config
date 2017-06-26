-- vim: tabstop=4 shiftwidth=4 expandtab

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")

-- Theming
beautiful.init("~/.config/awesome/theme.lua")

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
    -- Wallpaper
    if awful.util.file_readable(beautiful.wallpaper) then
        gears.wallpaper.maximized(beautiful.wallpaper, s, false)
    end

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
    awful.key({ "Mod4", "Control" }, "q", awesome.quit),
    -- MOD + CTRL + R
    -- Restart awesome
    awful.key({ "Mod4", "Control" }, "r", awesome.restart),
    -- MOD + RETURN
    -- Open a terminal
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
    awful.key({ "Ctrl" }, "w", function(c)
        awful.client.focus.history.previous()
        c:kill()
    end))

clientbuttons = gears.table.join(
    awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
    awful.button({ "Mod4" }, 1, awful.mouse.client.move),
    awful.button({ "Mod4" }, 3, awful.mouse.client.resize))

-- Setup rules for appearing windows
awful.rules.rules = {
    { rule = { },
      properties = {
        placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        focus = awful.client.focus.filter,
        keys = clientkeys,
        buttons = clientbuttons } }
}

-- Make focus follow mouse
client.connect_signal("mouse::enter", function(c) client.focus = c end)

-- Change border color on focus/unfocus
client.connect_signal("focus", function(c) c.border_color = beautiful.bg_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.bg_normal end)
