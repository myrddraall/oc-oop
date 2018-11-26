local Class = import("./Class");


local Event = Class("Event");

function Event:initialize(type, cancelable, bubbles)
    self._type = type;
    self._cancelable = cancelable;
    self._bubbles = bubbles;
end

function Event:get_type()
    return self._type;
end

function Event:get_cancelable()
    return self._cancelable;
end

function Event:preventDefault()
    if self._cancelable then
        self._defaultPrevented = true;
    end
end

function Event:get_isDefaultPrevented()
    return self._defaultPrevented;
end

function Event:get_bubbles()
    return self._bubbles;
end

function Event:stopPropagation()
    self._stopPropagation = true;
end

function Event:stopImmediatePropagation()
    self:stopPropagation();
    self._stopImmediatePropagation = true;
end

function Event:get_target()
    return self._target;
end

function Event:__setTarget(value)
    if not self._target then
        self._target = value;
    end
end

function Event:get_currentTarget()
    return self._currentTarget;
end

function Event:__setCurrentTarget(value)
    self._currentTarget = value;
end

return Event;