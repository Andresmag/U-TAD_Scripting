width = 300
coin_score = 50
---------------------------------------

powerUp = {
	score = 200,
	duration = 5,
	speed_multiplier = 2,
	pacman_color = {r = 0, g = 0, b = 255}
}


max_life = 1.5
current_life = max_life
score = 0
num_coins = 0

points_per_coin = 1
points_for_bronze = 2
bronzes_for_silver = 100
silvers_for_gold = 5
medals = {bronze = 0, silver = 0, gold = 0}

pacman_config = {
	speed_multiplier = 1.0,
	color = {r = 255, g = 0, b = 0}
}

-------------------------------------
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
------------------------------------

-- PRACTICA 1 funciones
function lua_powerUpEatenCallback()
	pacman_config_lib.setPacmanSpeedMultiplier(powerUp.speed_multiplier)
	pacman_config_lib.setPacmanColor(getColor(current_life))
	pacman_config_lib.setPowerUpTime(powerUp.duration)

	score = score + powerUp.score

	return score
end

function lua_powerUpGone()
	pacman_config_lib.setPacmanSpeedMultiplier(pacman_config.speed_multiplier)
	pacman_config_lib.setPacmanColor(pacman_config.color)
end

function lua_pacmanEatenCallback()
	current_life = current_life - 0.5
	return current_life
end

function lua_coinEatenCallback()
	num_coins = num_coins + 1
	score = score + points_per_coin
	return score
end

function lua_pacmanRestarted()
	score = 0
	num_coins = 0
	current_life = max_life
	return score
end

function lua_computeMedals()
	medals.bronze = math.floor(score / points_for_bronze)

	medals.silver = math.floor(medals.bronze / bronzes_for_silver)
	medals.bronze = medals.bronze % bronzes_for_silver

	medals.gold = math.floor(medals.silver / silvers_for_gold)
	medals.silver = medals.silver % silvers_for_gold

	return medals
end