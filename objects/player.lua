local love = require("love")
local Lazer = require("objects.Lazer")

function Player(debugging)
	local SHIP_SIZE = 50
	local VIEW_ANGLE = math.rad(90) --船头角度
	local THRUST_ACCEL = 1 -- 每秒增加的速度（像素/秒）

	debugging = debugging or false

	return {
		x = love.graphics.getWidth() / 2,
		y = love.graphics.getHeight() / 2,
		radius = SHIP_SIZE / 2,
		angle = VIEW_ANGLE,
		rotation = 0,
		lazers = {},
		--加速状态
		thrusting = false,
		--加速方向，速度
		thrust = {
			x = 0,
			y = 0,
			speed = THRUST_ACCEL,
			big_flame = false,
			flame = 1.6, --火焰大小系数
		},

		move = function(self, dt)
			local FPS = love.timer.getFPS()
			--减速系数
			local friction = 1

			self.rotation = 360 / 180 * math.pi / FPS

			if love.keyboard.isDown("a") or love.keyboard.isDown("left") or love.keyboard.isDown("kp4") then
				self.angle = self.angle + self.rotation
			end

			if love.keyboard.isDown("d") or love.keyboard.isDown("right") or love.keyboard.isDown("kp6") then
				self.angle = self.angle - self.rotation
			end

			if self.thrusting then
				-- local dt = 1 / FPS
				self.thrust.x = self.thrust.x + self.thrust.speed * math.cos(self.angle) * dt
				self.thrust.y = self.thrust.y - self.thrust.speed * math.sin(self.angle) * dt -- 减号：屏幕y向下
			else
				if self.thrust.x ~= 0 or self.thrust.y ~= 0 then
					self.thrust.x = self.thrust.x - friction * self.thrust.x / FPS
					self.thrust.y = self.thrust.y - friction * self.thrust.y / FPS
				end
			end
			self.x = self.x + self.thrust.x
			self.y = self.y + self.thrust.y

			local w, h = love.graphics.getWidth(), love.graphics.getHeight()

			if self.x < -self.radius then
				self.x = w - self.radius -- 从左边界穿出 → 出现在右边界内侧
			elseif self.x > w - self.radius then
				self.x = self.radius -- 从右边界穿出 → 出现在左边界内侧
			end
			if self.y < self.radius then
				self.y = h - self.radius -- 从上边界穿出 → 出现在下边界内侧
			elseif self.y > h - self.radius then
				self.y = self.radius -- 从下边界穿出 → 出现在上边界内侧
			end
			
			for lazer_index,lazer in pairs(self.lazers) do
				lazer:move(dt)
				if lazer.distance>love.graphics.getWidth() then
					self:destroy_lazers(lazer_index)
				end
			end

		end,
		--加速时火焰绘制函数
		draw_flame_thrust = function(self, fillType, color)
			fillType = fillType or "fill" -- 默认实心
			color = color or { 1, 0.6, 0.1 } -- 默认橙色火焰
			love.graphics.setColor(color)

			--焰头距离
			local flameLength = self.radius * (self.thrust.flame + math.random() * 0.4)
			--两个焰尾距离中心点的距离
			local baseRadius = self.radius
			--船尾角度（船头+180度）
			local backAngle = self.angle + math.pi
			--两个底角张开的角度
			local baseOffset = math.rad(20)

			--焰头坐标
			local x1 = self.x - flameLength * math.cos(self.angle)
			local y1 = self.y + flameLength * math.sin(self.angle)

			-- 基底左点
			local x2 = self.x + baseRadius * math.cos(backAngle + baseOffset)
			local y2 = self.y - baseRadius * math.sin(backAngle + baseOffset)

			-- 基底右点
			local x3 = self.x + baseRadius * math.cos(backAngle - baseOffset)
			local y3 = self.y - baseRadius * math.sin(backAngle - baseOffset)

			love.graphics.polygon(fillType, x1, y1, x2, y2, x3, y3)
		end,
		--绘制激光函数
		draw_lazers = function(self) 
			table.insert(self.lazers,Lazer(self.x,self.y,self.angle))
		end,
		destroy_lazers=function (self,index)
			table.remove(self.lazers,index)
		end,
			
		draw = function(self, faded)
			local opacity = 1
			if faded then
				opacity = 0.2
			end
			if self.thrusting then
				-- if not self.thrust.big_flame then
				-- 	self.thrust.flame = self.thrust.flame - 1 / love.timer.getFPS()
				-- 	if self.thrust.flame<1.0 then
				-- 		self.thrust.big_flame=true
				-- 	end
				-- else
				-- 	self.thrust.flame = self.thrust.flame + 1 / love.timer.getFPS()
				-- 	if self.thrust.flame>2.5 then
				-- 		self.thrust.big_flame=false
				-- 	end
				-- end
				self:draw_flame_thrust("fill")
			end

			if debugging then
				love.graphics.setColor(0, 1, 1)
				love.graphics.rectangle("fill", self.x - 1, self.y - 1, 2, 2)
				love.graphics.circle("line", self.x, self.y, self.radius)
			end

			love.graphics.setColor(1, 1, 1, opacity)
			-- 经典三角飞船：机头 + 左后、右后两个顶点
			--机头距离
			local nose = 4 / 3 * self.radius
			--两个机尾距离
			local rear = 4 / 3 * self.radius

			local leftAngle = self.angle + math.rad(120)
			local rightAngle = self.angle + math.rad(240)

			local x1 = self.x + nose * math.cos(self.angle)
			local y1 = self.y - nose * math.sin(self.angle)

			local x2 = self.x + rear * math.cos(leftAngle)
			local y2 = self.y - rear * math.sin(leftAngle)

			local x3 = self.x + rear * math.cos(rightAngle)
			local y3 = self.y - rear * math.sin(rightAngle)

			love.graphics.polygon("line", x1, y1, x2, y2, x3, y3)

			for _,lazer in pairs(self.lazers) do
				lazer:draw(faded)
			end
		end,
	}
end

return Player
