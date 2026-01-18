local owActionEventHandlers = require(script:WaitForChild("owActionEventHandlers"))
local inCombatEventHandlers = require(script:WaitForChild("inCombatEventHandlers"))

local function regCombatEventHandlers()
	owActionEventHandlers.regOwActionEventHandlers()
	inCombatEventHandlers.regInCombatEventHandlers()
end

return {
	regCombatEventHandlers = regCombatEventHandlers,
}
