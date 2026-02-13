local love = require("love")

function Asteroids(x, y, ast_size, level, debugging)
	debugging = debugging or false

	local ASTEROID_VERT = 10 --小行星顶点数量
	local ASTEROID_JAG = 0.4 --顶点的凹凸程度（值越大越不规则）
	local ASTEROID_SPEED = math.random(50) + (level * 2)

    local offset={}

    for i=1,ASTEROID_VERT do
        
    end
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
        radius=math.ceil(ast_size/2),
        offset=offset,

        draw=function (self,faded)
            local opacity=1
            if faded then
                opacity=0.2
            end
            if debugging then
                love.graphics.setColor(1,0,0)
                love.graphics.circle(self.x,self.y,self.radius) 
            end
            love.graphics.setColor(1,1,1,opacity)
            local ponits={
                self.x+self.radius*self.offset
            }
        end,

		move = function(self,dt) 
            self.x=self.x+self.x_vel*dt
            self.y=self.y+self.y_vel*dt
        end,
	}
end

return Asteroids
