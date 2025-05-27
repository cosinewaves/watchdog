--!strict

--[[

    @class watchdog

    Take control of changes with watchdog.

]]

local watcher = require("./watchdog./watcher")

return {
    watcher = watcher
}