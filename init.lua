-- Issues: Keep-on-top windows are always first to focus; unstable with windows in Spaces or fullscreen.
local cachedWindows = {} -- Cache window list to ensure focus order.
local function windowListChanged(windows)
    if #windows ~= #cachedWindows then
        return true
    end
    for i = 1, #windows do -- Check if each in new list exists in cache.
        local found = false
        for j = 1, #cachedWindows do
            if windows[i]:id() == cachedWindows[j]:id() then
                found = true
            end
        end
        if found == false then
            return true
        end
    end
    return false
end
local function cycle(appNames) -- Focus the window after frontmost window. If none, focus the next one.
    local allWindows = hs.window.filter.new(appNames):getWindows() -- Default filter uses sortByFocusedLast.
    if windowListChanged(allWindows) then
        cachedWindows = allWindows
    end
    local frontmostWindow = hs.window.frontmostWindow()
    local found = false
    for _ = 1, 2 do -- Iterate again to find the next window if found at the end.
        for i = 1, #cachedWindows do
            if frontmostWindow == nil or found == true then
                cachedWindows[i]:focus()
                return
            end
            if frontmostWindow:id() == cachedWindows[i]:id() then -- Match, so focus next window.
                found = true
            end
        end
        found = true -- Nothing found, so focus first window.
    end
end

-- Ctrl + 1 and others might be reserved by MacOS. I recommend Ctrl + Shift + #.
hs.hotkey.bind({'ctrl', 'shift'}, '1', function() cycle({'Finder'}) end)
hs.hotkey.bind({'ctrl'}, '2', function() cycle({'Terminal'}) end)
hs.hotkey.bind({'ctrl'}, '3', function() cycle({'LibreWolf', 'Firefox', 'Safari', 'Chrome'}) end)
hs.hotkey.bind({'ctrl'}, '4', function() cycle({'VLC', 'mpv'}) end)
