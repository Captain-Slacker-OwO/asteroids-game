local love = require("love")

function Asteroids(x, y, ast_size, level, debugging)
	debugging = debugging or false

	local ASTEROID_VERT = 10 --小行星基础顶点数量
	local ASTEROID_JAG = 0.4 --顶点的凹凸程度（0=正多边形，值越大越不规则）
	local ASTEROID_SPEED = math.random(50) + (level * 2)

	--随机调整最终顶点数
	local vert = math.floor(math.random(ASTEROID_VERT + 1) + ASTEROID_VERT / 2)
	--小行星每个顶点的凹凸偏移值（核心：决定形状的不规则性）
	local offset = {}

	for i = 1, vert + 1 do
		--生成1-ASTEROID_JAG ~ 1+ASTEROID_JAG之间的随机数（0.6~1.4）
		table.insert(offset, math.random() * ASTEROID_JAG * 2 + 1 - ASTEROID_JAG)
	end
	--随机决定速度方向（-1=反向，1=正向）
	local vel = -1
	if math.random() < 0.5 then
		vel = 1
	end

	return {
		x = x,
		y = y,
		ast_size = ast_size,
		x_vel = math.random() * ASTEROID_SPEED * vel,
		y_vel = math.random() * ASTEROID_SPEED * vel,
		radius = math.ceil(ast_size / 2),
		angle = math.rad(math.random(math.pi)),
		offset = offset,
		vert = vert,

		draw = function(self, faded)
			local opacity = 1
			if faded then
				opacity = 0.2
			end
			-- 调试模式：绘制碰撞检测圆（红色）
			if debugging then
				love.graphics.setColor(1, 0, 0, 1)
				love.graphics.circle("line", self.x, self.y, self.radius)
			end
			love.graphics.setColor(1, 1, 1, opacity)
			--行星顶点坐标列表
			local points = {
				self.x + self.radius * self.offset[1] * math.cos(self.angle),
				self.y + self.radius * self.offset[1] * math.sin(self.angle),
			}
			for i = 1, self.vert - 1 do
				table.insert(
					points,
					self.x + self.radius * self.offset[i + 1] * math.cos(self.angle + i * math.pi * 2 / self.vert)
				)
				table.insert(
					points,
					self.y + self.radius * self.offset[i + 1] * math.sin(self.angle + i * math.pi * 2 / self.vert)
				)
			end
			--绘制线框多边形
			love.graphics.polygon("line", points)
		end,

		move = function(self, dt)
			self.x = self.x + self.x_vel * dt
			self.y = self.y + self.y_vel * dt
		end,
	}
end

return Asteroids
