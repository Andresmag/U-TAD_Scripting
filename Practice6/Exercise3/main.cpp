#include <pacman_include.hpp>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include <assert.h>

int num_coins = 0;
const int platas_para_oro = 5;
const int bronces_para_plata = 100;

const float max_vida = 1.5f;
float vida = max_vida;

// Practica variables 1
int powerUp_score;
float powerUp_duration;
int powerUp_speed_multiplier;
int powerUp_pacman_color[3];
int puntos_para_bronce;
int puntos_por_moneda;
lua_State* L;


bool pacmanEatenCallback(int& score, bool& muerto)
{ // Pacman ha sido comido por un fantasma
	vida -= 0.5f;
	muerto = vida < 0.0f;

	return true;
}

bool coinEatenCallback(int& score)
{ // Pacman se ha comido una moneda
	++num_coins;
	score += puntos_por_moneda;

	return true;
}

bool frameCallback(float time)
{ // Se llama periodicamente cada frame

	// Read the script every frame and update global variables -- PRACTICA 3
	int error = luaL_loadfile(L, "./lua/pacman.lua");
	error = lua_pcall(L, 0, 0, 0);
	if (error)
	{
		fprintf(stderr, "%s", lua_tostring(L, -1));
		lua_pop(L, 1);
	}

	// Get powerUp table
	lua_getglobal(L, "powerUp");
	lua_getfield(L, -1, "score");
	lua_getfield(L, -2, "duration");
	lua_getfield(L, -3, "speed_multiplier");
	assert(lua_isnumber(L, -1) != 0);
	if (lua_isnumber(L, -1))
	{
		powerUp_speed_multiplier = lua_tointeger(L, -1);
		lua_pop(L, 1);
	}
	assert(lua_isnumber(L, -1) != 0);
	if (lua_isnumber(L, -1))
	{
		powerUp_duration = lua_tonumber(L, -1);
		lua_pop(L, 1);
	}
	assert(lua_isnumber(L, -1) != 0);
	if (lua_isnumber(L, -1))
	{
		powerUp_score = lua_tointeger(L, -1);
		lua_pop(L, 1);
	}

	lua_getfield(L, -1, "pacman_color");
	assert(lua_istable(L, -1) != 0);
	if (lua_istable(L, -1))
	{
		lua_getfield(L, -1, "r");
		lua_getfield(L, -2, "g");
		lua_getfield(L, -3, "b");
		for (int i = 2; i >= 0; --i)
		{
			assert(lua_isnumber(L, -1));
			if (lua_isnumber(L, -1))
			{
				powerUp_pacman_color[i] = lua_tointeger(L, -1);
				lua_pop(L, 1);
			}
		}
	}
	lua_pop(L, 1); // pop pacman_color table
	lua_pop(L, 1); // pop powerUp table

	// Get global points info
	lua_getglobal(L, "num_points_broze_medal");
	assert(lua_isnumber(L, -1) != 0);
	if (lua_isnumber(L, -1))
	{
		puntos_para_bronce = lua_tointeger(L, -1);
		lua_pop(L, 1);
	}

	lua_getglobal(L, "num_points_coin");
	assert(lua_isnumber(L, -1) != 0);
	if (lua_isnumber(L, -1))
	{
		puntos_por_moneda = lua_tointeger(L, -1);
		lua_pop(L, 1);
	}

	return false;
}

bool ghostEatenCallback(int& score)
{ // Pacman se ha comido un fantasma
	return false;
}

bool powerUpEatenCallback(int& score)
{ // Pacman se ha comido un powerUp

	// Get pacman color from Lua -- PRACTICA 2
	lua_getglobal(L, "getColor");
	if (lua_isfunction(L, -1))
	{
	    lua_pushnumber(L, vida);
	    if (lua_pcall(L, 1, 1, 0) == 0)
	    {
		    if (lua_istable(L, -1))
		    {
				lua_getfield(L, -1, "r");
				lua_getfield(L, -2, "g");
				lua_getfield(L, -3, "b");
		        for (int i = 2; i >= 0; --i)
		        {
	                assert(lua_isnumber(L, -1));
	                if (lua_isnumber(L, -1))
	                {
		                powerUp_pacman_color[i] = lua_tointeger(L, -1);
		                lua_pop(L, 1);
	                }
		        }
				lua_pop(L, -1); // pop returned table
		    }
	    }
		else
		{
			fprintf(stderr, "%s", lua_tostring(L, -1));
			lua_pop(L, 1);
		}
	}

	setPacmanSpeedMultiplier(powerUp_speed_multiplier);
	setPacmanColor(powerUp_pacman_color[0], powerUp_pacman_color[1], powerUp_pacman_color[2]);
	setPowerUpTime(powerUp_duration);

	score += powerUp_score;

	return true;
}

bool powerUpGone()
{ // El powerUp se ha acabado
	setPacmanColor(255, 0, 0);
	setPacmanSpeedMultiplier(1.0f);
	return true;
}

bool pacmanRestarted(int& score)
{
	score = 0;
	num_coins = 0;
	vida = max_vida;

	return true;
}

bool computeMedals(int& oro, int& plata, int& bronce, int score)
{
	bronce = score / puntos_para_bronce;

	plata = bronce / bronces_para_plata;
	bronce = bronce % bronces_para_plata;
	
	oro = plata / platas_para_oro;
	plata = plata % platas_para_oro;

	return true;
}

bool getLives(float& vidas)
{
	vidas = vida;
	return true;
}

bool setImmuneCallback()
{
    return true;
}

bool removeImmuneCallback()
{
    return true;
}

bool InitGame()
{
	L = luaL_newstate();
	luaL_openlibs(L);
	int error = luaL_loadfile(L, "./lua/pacman.lua");
	error = lua_pcall(L, 0, 0, 0);
	if (error)
	{
		fprintf(stderr, "%s", lua_tostring(L, -1));
		lua_pop(L, 1);
	}

	// Get powerUp table
	lua_getglobal(L, "powerUp");
	lua_getfield(L, -1,  "score");
	lua_getfield(L, -2, "duration");
	lua_getfield(L, -3, "speed_multiplier");
	assert(lua_isnumber(L, -1) != 0);
	if (lua_isnumber(L, -1))
	{
	    powerUp_speed_multiplier = lua_tointeger(L, -1);
		lua_pop(L, 1);
	}
    assert(lua_isnumber(L, -1) != 0);
	if (lua_isnumber(L, -1))
	{
	    powerUp_duration = lua_tonumber(L, -1);
		lua_pop(L, 1);
	}
    assert(lua_isnumber(L, -1) != 0);
	if (lua_isnumber(L, -1))
	{
	    powerUp_score = lua_tointeger(L, -1);
		lua_pop(L, 1);
	}

	lua_getfield(L, -1, "pacman_color");
	assert(lua_istable(L, -1) != 0);
	if (lua_istable(L, -1))
	{
		lua_getfield(L, -1, "r");
		lua_getfield(L, -2, "g");
		lua_getfield(L, -3, "b");
		for (int i = 2; i >= 0; --i)
		{
			assert(lua_isnumber(L, -1));
			if (lua_isnumber(L, -1))
			{
				powerUp_pacman_color[i] = lua_tointeger(L, -1);
				lua_pop(L, 1);
			}
		}
	}
	lua_pop(L, 1); // pop pacman_color table
	lua_pop(L, 1); // pop powerUp table

	// Get global points info
	lua_getglobal(L, "num_points_broze_medal");
	assert(lua_isnumber(L, -1) != 0);
	if (lua_isnumber(L, -1))
	{
		puntos_para_bronce = lua_tointeger(L, -1);
		lua_pop(L, 1);
	}

	lua_getglobal(L, "num_points_coin");
	assert(lua_isnumber(L, -1) != 0);
	if (lua_isnumber(L, -1))
	{
		puntos_por_moneda = lua_tointeger(L, -1);
		lua_pop(L, 1);
	}

    return true;
}

bool EndGame()
{
	lua_close(L);
    return true;
}