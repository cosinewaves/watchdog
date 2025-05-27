local types = require("../watchdog./types")

local watcher = {}
watcher.__index = watcher

--[=[
    Watch a given property in an instance, with the ability to stop watching it.

    @param propertyName string
    @param object Instance
    @return (() -> (), () -> ())
]=]
function watcher.watchProperty(propertyName: string, object: Instance): (() -> (), () -> ())
    -- TODO here
    return 
end

return watcher