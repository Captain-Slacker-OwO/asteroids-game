local love = require("love")

-- 可调参数：集中管理，便于平衡与扩展
local DEFAULTS = {
	speed = 1000,
	pointSize = 3,
	color = { 1, 1, 1 },
}

-- 创建一发激光
-- @param number x 出生 x
-- @param number y 出生 y
-- @param number angle 朝向（弧度，与玩家 angle 一致）
-- @param number|table opts 可选：数字表示速度，或表 { speed=?, pointSize=?, color=? }
-- @return table 激光对象，支持 :move(dt) 与 :draw(faded)
function Lazer(x, y, angle, opts)
	opts = opts or {}
	if type(opts) == "number" then
		opts = { speed = opts }
	end
	local speed = opts.speed or DEFAULTS.speed
	local pointSize = opts.pointSize or DEFAULTS.pointSize
	local color = opts.color or DEFAULTS.color

	return {
		x = x,
		y = y,
		angle = angle,
		distance = 0,

		move = function(self, dt)
			local dx = speed * math.cos(self.angle) * dt
			local dy = -speed * math.sin(self.angle) * dt
			self.x = self.x + dx
			self.y = self.y + dy
			self.distance = self.distance + math.sqrt(dx * dx + dy * dy)
		end,

		draw = function(self, faded)
			local r, g, b = color[1], color[2], color[3]
			local a = faded and 0.2 or 1
			love.graphics.setColor(r, g, b, a)
			love.graphics.setPointSize(pointSize)
			love.graphics.points(self.x, self.y)
		end,
	}
end

return Lazer
