local love = require("love")
local Player = require("objects.player")
local Game = require("states.game")
local Asteroids = require("objects.asteroids")

math.randomseed(os.time())
function love.load()
	love.mouse.setVisible(false)
	mouse_x, mouse_y = 0, 0
	local show_debugging = true
	player = Player(show_debugging) 
	game = Game()
    game:startNewGame(player)
end

function love.update(dt)
	if game.states.running then
		player:move(dt)
        for ast_index,asteroid in pairs(asteroids) do
            asteroid:move(dt)
        end
	end
	mouse_x, mouse_y = love.mouse.getPosition()
end

function love.draw()
	if game.states.running or game.states.paused then
		game:draw(game.states.paused)
		player:draw(game.states.paused)
        for ast_index,asteroid in pairs(asteroids) do
            asteroid:draw(game.states.paused)
        end
	end
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.print(love.timer.getFPS(), 10, 10)
end

function love.mousepressed() end

function love.keypressed(key)
	if game.states.running then
		if key == "w" then
			-- 按下 W 时执行
			player.thrusting = true
		end
		if key == "escape" then
			game:changeGameStated("paused")
		end
	elseif game.states.paused then
		if key == "escape" then
			game:changeGameStated("running")
		end
	end
end

function love.keyreleased(key)
	if key == "w" then
		player.thrusting = false
	end
end
