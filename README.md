# 👀 watcher

`watcher` is a lightweight observation utility for Roblox developers. It provides a simple and safe way to **listen to property changes**, **attribute updates**, and **tagged instances** in real time. It returns disconnectors and error functions to keep your observers clean, safe, and memory-leak-free.

## ✨ Features

* Watch property or attribute changes on any Instance
* Watch for tagged Instances using `CollectionService`
* Clean disconnect and runtime error handling
* Type-safe and minimal API
* Designed for use in reactive, modular systems

## 🚀 Usage

```lua
local watcher = require(game.ReplicatedStorage.watcher)

-- Watch a property change
local disconnectProp, propError = watcher.watchProperty("Transparency", somePart)

-- Watch an attribute change
local disconnectAttr, attrError = watcher.watchAttribute("Health", someNPC)

-- Watch when an instance is tagged
local disconnectTag, tagError = watcher.watchTag("Enemy", function(instance)
	print("Enemy tagged:", instance)
end)

-- Later, clean up
disconnectProp()
disconnectAttr()
disconnectTag()
```

## 🧯 Error Handling

Each `watch*` function returns an error function:

```lua
local _, getError = watcher.watchProperty("Name", nil)
print(getError()) --> "Expected a valid Instance."
```

## 📘 API

### `watcher.watchProperty(propertyName: string, object: Instance): (disconnect: () -> (), error: () -> string?)`

Observes a property on an instance. Uses `GetPropertyChangedSignal`.

### `watcher.watchAttribute(attributeName: string, object: Instance): (disconnect: () -> (), error: () -> string?)`

Observes an attribute on an instance. Uses `GetAttributeChangedSignal`.

### `watcher.watchTag(tagName: string, callback: (Instance) -> ()): (disconnect: () -> (), error: () -> string?)`

Fires the callback when any instance is tagged with `tagName`. Also fires for already-tagged instances.

## 🛠 Type Definitions

You can find all type definitions in [`types.lua`](watchdog/types.lua).

```ts
export type DisconnectFunction = () -> ()
export type ErrorFunction = () -> string?

export type WatchProperty = (propertyName: string, object: Instance) -> (DisconnectFunction, ErrorFunction)
export type WatchAttribute = (attributeName: string, object: Instance) -> (DisconnectFunction, ErrorFunction)
export type WatchTag = (tagName: string, callback: (Instance) -> ()) -> (DisconnectFunction, ErrorFunction)

export type Watcher = {
  watchProperty: WatchProperty,
  watchAttribute: WatchAttribute,
  watchTag: WatchTag,
}
```
