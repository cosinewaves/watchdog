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

return nil