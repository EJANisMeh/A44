local owActionEventHandlers = require(script:WaitForChild("owActionEventHandlers"))
local inCombatEventHandlers = require(script:WaitForChild("inCombatEventHandlers"))


function regCombatEventHandlers()
	owActionEventHandlers.regOwActionEventHandlers()
	inCombatEventHandlers.regInCombatEventHandlers()
end

return {
	regCombatEventHandlers = regCombatEventHandlers
}