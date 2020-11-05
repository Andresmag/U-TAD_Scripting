width = 300
coin_score = 50
---------------------------------------

powerUp = {
	score = 200,
	duration = 5,
	speed_multiplier = 2,
	pacman_color = {r = 0, g = 0, b = 255}
}

points_per_coin = 1
points_for_bronze = 2
bronzes_for_silver = 100
silvers_for_gold = 5

pacman_init_config = {
	max_life = 1.5,
	speed_multiplier = 1.0,
	color = {r = 255, g = 0, b = 0}
}

player = pacman.new(pacman_init_config.max_life, pacman_init_config.speed_multiplier, pacman_init_config.color)

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
	player:setSpeed(powerUp.speed_multiplier)
	player:setColor(getColor(player:getCurrentLife()))
	player:setPowerUpTime(powerUp.duration)

	player:increaseScore(powerUp.score)

	return player:getScore()
end

function lua_powerUpGone()
	player:setSpeed(pacman_init_config.speed_multiplier)
	player:setColor(pacman_init_config.color)
end

function lua_pacmanEatenCallback()
	player:decreaseCurrentLife(0.5)

	return player:getCurrentLife()
end

function lua_coinEatenCallback()
	player:increaseCoins(1)
	player:increaseScore(points_per_coin)

	return player:getScore()
end

function lua_pacmanRestarted()
	player:setScore(0)
	player:setCoins(0)
	player:setCurrentLife(pacman_init_config.max_life)

	return player:getScore()
end

function lua_computeMedals()
	local medals = {bronze = 0, silver = 0, gold = 0}
	medals.bronze, medals.silver, medals.gold = player:computeMedals(points_for_bronze, bronzes_for_silver, silvers_for_gold)

	return medals
end