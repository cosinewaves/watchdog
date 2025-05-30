local CollectionService = game:GetService("CollectionService")

local types = require("../watchdog./types")

local watcher = {} :: types.Watcher
watcher.__index = watcher

-- Utility to safely disconnect a connection
local function safeDisconnect(conn: RBXScriptConnection?)
	if conn and typeof(conn) == "RBXScriptConnection" and conn.Connected then
		pcall(function()
			conn:Disconnect()
		end)
	end
end

--[=[
    Watch a given property in an instance.

    @param propertyName string
    @param object Instance
    @return disconnect: () -> (), error: () -> string?
]=]
function watcher.watchProperty(propertyName: string, object: Instance): (types.DisconnectFunction, types.ErrorFunction)
	local success, err = pcall(function()
		if not object or typeof(object) ~= "Instance" then
			error("Expected a valid Instance.")
		end
		if typeof(propertyName) ~= "string" then
			error("Expected propertyName to be a string.")
		end
	end)
	if not success then
		return function() end, function() return err end
	end

	local conn: RBXScriptConnection?
	local watchErr: string? = nil

	local _ok = pcall(function()
		conn = object:GetPropertyChangedSignal(propertyName):Connect(function()
			print(`[watchProperty] {propertyName} on {object:GetFullName()} changed to {object[propertyName]}`)
		end)
	end)

	return function()
		safeDisconnect(conn)
	end, function()
		return watchErr
	end
end

--[=[
    Watch a given attribute in an instance.

    @param attributeName string
    @param object Instance
    @return disconnect: () -> (), error: () -> string?
]=]
function watcher.watchAttribute(attributeName: string, object: Instance): (types.DisconnectFunction, types.ErrorFunction)
	local success, err = pcall(function()
		if not object or typeof(object) ~= "Instance" then
			error("Expected a valid Instance.")
		end
		if typeof(attributeName) ~= "string" then
			error("Expected attributeName to be a string.")
		end
	end)
	if not success then
		return function() end, function() return err end
	end

	local conn: RBXScriptConnection?
	local watchErr: string? = nil

	local _ok = pcall(function()
		conn = object:GetAttributeChangedSignal(attributeName):Connect(function()
			print(`[watchAttribute] {attributeName} on {object:GetFullName()} changed to {object:GetAttribute(attributeName)}`)
		end)
	end)

	return function()
		safeDisconnect(conn)
	end, function()
		return watchErr
	end
end

--[=[
    Watch when an instance gets a specific tag.

    @param tagName string
    @param callback (Instance) -> ()
    @return disconnect: () -> (), error: () -> string?
]=]
function watcher.watchTag(tagName: string, callback: (Instance) -> ()): (types.DisconnectFunction, types.ErrorFunction)
	local success, err = pcall(function()
		if typeof(tagName) ~= "string" then
			error("Expected tagName to be a string.")
		end
		if typeof(callback) ~= "function" then
			error("Expected callback to be a function.")
		end
	end)
	if not success then
		return function() end, function() return err end
	end

	local conns: { RBXScriptConnection } = {}

	local function onTagged(instance: Instance)
		local ok, tagErr = pcall(callback, instance)
		if not ok then
			warn(`[watchTag] Error calling callback for {instance:GetFullName()}: {tagErr}`)
		end
	end

	table.insert(conns, CollectionService:GetInstanceAddedSignal(tagName):Connect(onTagged))

	-- Handle already tagged instances
	for _, instance in ipairs(CollectionService:GetTagged(tagName)) do
		task.spawn(onTagged, instance)
	end

	return function()
		for _, conn in conns do
			safeDisconnect(conn)
		end
	end, function()
		return nil
	end
end

return watcher
