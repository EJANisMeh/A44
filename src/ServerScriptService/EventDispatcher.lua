-- A custom event system that supports server to server communication
local EventDispatcher = {
	_listeners = {}
}

function EventDispatcher:Register(eventName, callback)
	if not self._listeners[eventName] then
		self._listeners[eventName] = {}
	end
	table.insert(self._listeners[eventName], callback)
end

function EventDispatcher:Dispatch(eventName, ...)
	local listeners = self._listeners[eventName]
	if listeners then
		for _, callback in ipairs(listeners) do
			coroutine.wrap(callback)(...)
		end
	end
end

return EventDispatcher