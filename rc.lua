-- vim: tabstop=4 shiftwidth=4 expandtab

-- | Requires | --------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")

-- | Variable definitions | --------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- Standard applications
terminal = os.getenv("TERMINAL") or "urxvt" or "xterm"

-- Theming
beautiful.init("~/.config/awesome/theme.lua")

-- | Key bindings | ----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- Default modkey
modkey = "Mod4"

-- Global keys
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

-- Tags manipulation keys
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- MOD + [1-9]
        -- View tag only
        awful.key({ modkey }, "#" .. i + 9, function()
            local tag = awful.screen.focused().tags[i]
            if tag then
                tag:view_only()
            end
        end),
        -- MOD + SHIFT + [1-9]
        -- Move focused client to tag
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end)
    )
end

-- Client keys
clientkeys = gears.table.join(
    -- CTRL + W
    -- Close the current window
    awful.key({ modkey }, "w", function(c)
        awful.client.focus.history.previous()
        c:kill()
    end))

-- Client buttons
clientbuttons = gears.table.join(
    awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Launcher
launcherbuttons = gears.table.join(
    -- LMB
    -- Toggle launcher menu
    awful.button({ }, 1, function() launchermenu:toggle({ coords = { x=0, y=0 } }) end)
)

-- Taglist
taglistbuttons = gears.table.join(
    -- LMB
    -- Switch to tag
    awful.button({ }, 1, function(t) t:view_only() end))

-- Tasklist
tasklistbuttons = gears.table.join(
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

-- | Widgets | ---------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
launchermenu = awful.menu({
    items = {
        { "TERMINAL", function() awful.util.spawn(terminal) end },
        { "AWESOME", {
            { "RESTART", awesome.restart },
            { "QUIT", awesome.quit }, }
        } }
})
launcher = awful.widget.button({ image = beautiful.launcher_icon })
launcher:buttons(launcherbuttons)

-- | Desktop environment setup | ---------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
awful.screen.connect_for_each_screen(function(s)
    -- Set wallpaper
    if awful.util.file_readable(beautiful.wallpaper) then
        gears.wallpaper.maximized(beautiful.wallpaper, s, false)
    end
    -- Add taglist
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.suit.floating)

    -- Widgets
    awful.wibar({ position = "top", screen = s, ontop = true }):setup {
    -- Add widgets
    awful.wibar({ position = "top", screen = s }):setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.align.horizontal,
            launcher,
            awful.widget.taglist(s, awful.widget.taglist.filter.all, taglistbuttons)
        },
        awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklistbuttons) }
end)

-- Bind global hotkeys
root.keys(globalkeys)

-- | Window rules |-----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
awful.rules.rules = {
    -- Default rule
    { rule = { },
      properties = {
          border_width = beautiful.border_width,
          border_color = beautiful.border_normal,
          placement = awful.placement.no_overlap + awful.placement.no_offscreen,
          focus = awful.client.focus.filter,
          keys = clientkeys,
          buttons = clientbuttons } }
}

-- | Signal handlers | -------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- Make focus follow mouse
client.connect_signal("mouse::enter", function(c) client.focus = c end)

-- Change border color on focus/unfocus
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
