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
	-- 爆炸动画持续时间（秒）
	local exploding_dur = 0.2

	return {
		x = x,
		y = y,
		angle = angle,
		distance = 0, -- 已飞行距离
		exploding = 0, -- 爆炸状态：0=未爆炸，1=爆炸中，2=已爆炸可销毁
		exploding_time = 0, -- 爆炸时间（秒，帧无关）

		-- 每帧移动激光
		move = function(self, dt)
			-- 爆炸中
			if self.exploding_time > 0 then
				self.exploding = 1
			end
			local dx = speed * math.cos(self.angle) * dt
			local dy = -speed * math.sin(self.angle) * dt
			self.x = self.x + dx
			self.y = self.y + dy
			self.distance = self.distance + math.sqrt(dx * dx + dy * dy)
		end,

		-- 绘制激光（单点）
		draw = function(self, faded)
			local r, g, b = color[1], color[2], color[3]
			local a = faded and 0.2 or 1 -- 淡出时降低透明度
			--未爆炸时绘制激光
			if self.exploding < 1 then
				love.graphics.setColor(r, g, b, a)
				love.graphics.setPointSize(pointSize)
				love.graphics.points(self.x, self.y)
			--爆炸中时绘制爆炸
			else
				love.graphics.setColor(r, g, 0, a)
				love.graphics.circle("fill", self.x, self.y, 7 * 1.5)
				love.graphics.setColor(r, 234/255, 0, a)
				love.graphics.circle("fill", self.x, self.y, 7)
			end
		end,

		-- 触发爆炸：exploding_dur 秒后标记为已爆炸（与帧率无关）
		explode = function(self)
			--爆炸计时器
			self.exploding_time = math.ceil(exploding_dur * (love.timer.getFPS() / 100))
			if self.exploding_time > exploding_dur then
				self.exploding = 2
			end
		end,
	}
end

return Lazer
