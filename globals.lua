ASTEROID_SIZE = 100
SHOW_DEBUGGING = true
SHIP_SIZE = 50
DESTROY_AST=false

function calculateDistance(x1, y1, x2, y2)
	local dis_x = x1 - x2
	local dis_y = y1 - y2
	return math.sqrt(dis_x ^ 2 + dis_y ^ 2)
end
