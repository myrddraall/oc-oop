local EventEmitterMixin = {};

function EventEmitterMixin:addEventListener(event, callback)
    if not self:_isSubscribedToEvent(event, callback) then
        self._listenerCount = self._listenerCount or {};
        self._listenerCount[event] = self._listenerCount[event] or 0;
        self._listenerCount[event] = self._listenerCount[event] + 1;


        self._listenersOrdered = self._listenersOrdered or {};
        self._listenersOrdered[event] = self._listenersOrdered[event] or {};
        table.insert(self._listenersOrdered[event], callback);

        self._listeners = self._listeners or {};
        self._listeners[event] = self._listeners[event] or {};

        local this = self;
        self._listeners[event][tostring(callback)] = function()
            this:removeEventListener(event, callback);
        end
    end
    return self._listeners[event][tostring(callback)];
end

function EventEmitterMixin:removeEventListener(event, callback) 
    if self:_isSubscribedToEvent(event, callback) then
        self._listeners[event][tostring(callback)] = nil;
        for i, cb in ipairs(self._listenersOrdered[event]) do
            if cb == callback then
                table.remove(self._listenersOrdered[event], i);
                break;
            end
        end
        self._listenerCount[event] = self._listenerCount[event] - 1;
        if self._listenerCount[event] < 1 then
            self._listeners[event] = nil;
            self._listenerCount[event] = nil;
            self._listenersOrdered[event] = nil;
        end
    end
end

function EventEmitterMixin:hasEventListener(event)
    if not self._listeners or not self._listeners[event] then
        return false;
    end
    return true;
end

function EventEmitterMixin:_isSubscribedToEvent(event, callback)
    if not self:hasEventListener(event) or not self._listeners[event][tostring(callback)] then
        return false;
    end
    return true;
end


function EventEmitterMixin:_setParentEventEmitter(parent)
    self._parentEventEmitter = parent;
end

function EventEmitterMixin:emit(event)
    if self:hasEventListener(event.type) then
        event:__setTarget(self);
        event:__setCurrentTarget(self);
        local listeners = {table.unpack(self._listenersOrdered[event.type])};
        for i, cb in ipairs(listeners) do
            if event._stopImmediatePropagation then break end
            if type(cb) == 'table' then
                cb[2](cb[1], event);
            else
                cb(event);
            end
        end

        if event.bubbles and (not event._stopPropagation) and self._parentEventEmitter and type(self._parentEventEmitter.emit) == 'function' then
            self._parentEventEmitter:emit(event);
        end
    end
    return event.isDefaultPrevented;
end

return EventEmitterMixin;