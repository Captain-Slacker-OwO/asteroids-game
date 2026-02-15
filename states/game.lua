local love = require("love")
local Text = require("components.text")
local Asteroids = require("objects.asteroids")

function Game()
	return {
		level = 1,
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

		startNewGame = function(self, player)
			self:changeGameStated("running")
			--行星列表
			asteroids = {}

			local ast_x = math.floor(math.random(love.graphics.getWidth()))
			local ast_y = math.floor(math.random(love.graphics.getHeight()))

			table.insert(asteroids, 1, Asteroids(ast_x, ast_y, 100, self.level, SHOW_DEBUGGING))
		end,
	}
end

return Game
