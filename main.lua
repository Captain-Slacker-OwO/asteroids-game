local love = require("love")
local Player = require("objects.player")
local Game = require("states.game")
-- local Asteroids = require("objects.asteroids")
require("globals")
math.randomseed(os.time())
function love.load()
	love.mouse.setVisible(false)
	mouse_x, mouse_y = 0, 0
	player = Player(SHOW_DEBUGGING)
	game = Game()
	game:startNewGame(player)
end

function love.update(dt)
	if game.states.running then
		player:move(dt)

		for ast_index, asteroid in pairs(asteroids) do
			if not player.exploding then
				if calculateDistance(player.x, player.y, asteroid.x, asteroid.y) < asteroid.radius + player.radius then
					player:explode()
					DESTROY_AST = true
				end
			else
				player.explode_time = player.explode_time - 1
				if player.explode_time == 0 then
					if player.lives - 1 <= 0 then
						game:changeGameStated("ended")
						return
					end
					player = Player(SHOW_DEBUGGING, player.lives - 1)
				end
			end

			for lazer_index, lazer in pairs(player.lazers) do
				if calculateDistance(lazer.x, lazer.y, asteroid.x, asteroid.y) < asteroid.radius then
					lazer:explode()
					asteroid:destroy(asteroids, ast_index, game)
				end
			end
			if DESTROY_AST then
				DESTROY_AST = false
				asteroid:destroy(asteroids, ast_index, game)
			end
			asteroid:move(dt)
		end
	end
	mouse_x, mouse_y = love.mouse.getPosition()
end


function love.draw()
	if game.states.running or game.states.paused then
		game:draw(game.states.paused)
		player:draw(game.states.paused)
		for ast_index, asteroid in pairs(asteroids) do
			asteroid:draw(game.states.paused)
		end
	end
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.print(love.timer.getFPS(), 10, 10)
end

function love.mousepressed(x, y, button, istouch, presses)
	if button == 1 then
		if game.states.running then
			player:draw_lazers()
		end
	end
end

function love.keypressed(key)
	if game.states.running then
		if key == "w" then
			-- 按下 W 时执行
			player.thrusting = true
		end
		if key == "escape" then
			game:changeGameStated("paused")
		end
		if key == "space" then
			player:draw_lazers()
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
