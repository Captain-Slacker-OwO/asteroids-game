local love = require("love")
local Text = require("components.text")
function Game()
	return {
		states = {
			menu = false,
			paused = false,
			running = true,
			ended = false,
		},
		changeGameStated = function(self, state)
			self.states.menu = "menu" == state
			self.states.paused = "paused" == state
			self.states.running = "running" == state
			self.states.ended = "ended" == state
		end,
		draw = function(self, faded)
			if faded then
				Text(
					"PAUSED",
					0,
					love.graphics.getHeight() * 0.4,
					"h1",
					false,
					false,
					love.graphics.getWidth(),
					"center"
				):draw()
			end
		end,
	}
end

return Game
