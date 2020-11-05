width = 300
coin_score = 50

-- Practica 1 variables
powerUp = {
	score = 100,
	duration = 5,
	speed_multiplier = 2,
	pacman_color = {
		r = 0,
		g = 0,
		b = 255
	}
}
num_points_broze_medal = 2
num_points_coin = 1

-- Practica 2 funcion de color
function getColor(lifeRemaining)
	if lifeRemaining >= 1.5 then
		return {r = 255, g = 0, b = 0}
	elseif lifeRemaining == 1 then
		return { r = 255, g = 164, b = 32}
	elseif lifeRemaining == 0.5 then
		return {r = 87, g = 166, b = 57}
	elseif lifeRemaining <= 0 then
		return {r = 0, g = 0, b = 255}
	else 
		return {r = 0, g = 0, b = 0}
	end
end

function getWidth()
	return 200
end