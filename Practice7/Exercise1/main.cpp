#include <pacman_include.hpp>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include <assert.h>

lua_State* L;

const char* LUA_FILENAME = "./lua/pacman.lua";
bool InitLua(const char* pFilename);
bool ExecLuaFile(const char* pFilename);

///////////////////////////////////////////////////////////////////////////////
static int C_setPacmanSpeedMultiplier(lua_State* L)
{
	if (lua_isnumber(L,1))
	{
		setPacmanSpeedMultiplier(lua_tonumber(L, 1));
	}
	return 0;
}

static int C_setPacmanColor(lua_State* L)
{
	if (lua_istable(L, 1))
	{
		int color[3];

		lua_getfield(L, 1, "r");
		lua_getfield(L, 1, "g");
		lua_getfield(L, 1, "b");
		for (int i = 2; i >= 0; --i)
		{
			assert(lua_isnumber(L, -1));
			if (lua_isnumber(L, -1))
			{
				color[i] = lua_tointeger(L, -1);
				lua_pop(L, 1);
			}
		}
		setPacmanColor(color[0], color[1], color[2]);
	}
	return 0;
}

static int C_setPowerUpTime(lua_State* L)
{
	if (lua_isnumber(L, 1))
	{
		setPowerUpTime(lua_tonumber(L, 1));
	}
	return 0;
}

static const struct luaL_Reg pacman_config_lib[] =
{
	{"setPacmanSpeedMultiplier", C_setPacmanSpeedMultiplier},
	{"setPacmanColor", C_setPacmanColor},
	{"setPowerUpTime", C_setPowerUpTime},
	{NULL,NULL}
};

///////////////////////////////////////////////////////////////////////////////

bool pacmanEatenCallback(int& score, bool& muerto)
{ // Pacman ha sido comido por un fantasma

	lua_getglobal(L, "lua_pacmanEatenCallback");
	if (lua_isfunction(L, -1))
	{
		int error = lua_pcall(L, 0, 1, 0);
		if (error)
		{
			fprintf(stderr, "%s", lua_tostring(L, -1));
			lua_pop(L, 1);
			return false;
		}

		if (lua_isnumber(L, -1))
		{
			muerto = lua_tonumber(L, -1) < 0.0f;
			lua_pop(L, 1);
		}
	}

	return true;
}

bool coinEatenCallback(int& score)
{ // Pacman se ha comido una moneda

	lua_getglobal(L, "lua_coinEatenCallback");
	if (lua_isfunction(L, -1))
	{
		int error = lua_pcall(L, 0, 1, 0);
		if (error)
		{
			fprintf(stderr, "%s", lua_tostring(L, -1));
			lua_pop(L, 1);
			return false;
		}

		if (lua_isnumber(L, -1))
		{
			score = lua_tonumber(L, -1);
			lua_pop(L, 1);
		}
	}

	return true;
}

bool frameCallback(float time)
{ // Se llama periodicamente cada frame
	return false;
}

bool ghostEatenCallback(int& score)
{ // Pacman se ha comido un fantasma
	return false;
}

bool powerUpEatenCallback(int& score)
{ // Pacman se ha comido un powerUp

	lua_getglobal(L, "lua_powerUpEatenCallback");
	if (lua_isfunction(L, -1))
	{
		int error = lua_pcall(L, 0, 1, 0);
		if (error)
		{
			fprintf(stderr, "%s", lua_tostring(L, -1));
			lua_pop(L, 1);
			return false;
		}

	    if (lua_isnumber(L, -1))
	    {
			score = lua_tointeger(L, -1);
			lua_pop(L, 1);
	    }
	}

	return true;
}

bool powerUpGone()
{ // El powerUp se ha acabado

	lua_getglobal(L, "lua_powerUpGone");
	if (lua_isfunction(L, -1))
	{
		int error = lua_pcall(L, 0, 0, 0);
		if (error)
		{
			fprintf(stderr, "%s", lua_tostring(L, -1));
			lua_pop(L, 1);
			return false;
		}
	}

	return true;
}

bool pacmanRestarted(int& score)
{
	lua_getglobal(L, "lua_pacmanRestarted");
	if (lua_isfunction(L, -1))
	{
		int error = lua_pcall(L, 0, 1, 0);
		if (error)
		{
			fprintf(stderr, "%s", lua_tostring(L, -1));
			lua_pop(L, 1);
			return false;
		}

		if (lua_isnumber(L, -1))
		{
			score = lua_tonumber(L, -1);
			lua_pop(L, 1);
		}
	}

	return true;
}

bool computeMedals(int& oro, int& plata, int& bronce, int score)
{
	lua_getglobal(L, "lua_computeMedals");
	if (lua_isfunction(L, -1))
	{
		int error = lua_pcall(L, 0, 1, 0);
		if (error)
		{
			fprintf(stderr, "%s", lua_tostring(L, -1));
			lua_pop(L, 1);
			return false;
		}

		if (lua_istable(L, -1))
		{
			lua_getfield(L, -1, "bronze");
			lua_getfield(L, -2, "silver");
			lua_getfield(L, -3, "gold");

			if (lua_isnumber(L, -1))
			{
				oro = lua_tointeger(L, -1);
				lua_pop(L, 1);
			}

			if (lua_isnumber(L, -1))
			{
				plata = lua_tointeger(L, -1);
				lua_pop(L, 1);
			}

			if (lua_isnumber(L, -1))
			{
				bronce = lua_tointeger(L, -1);
				lua_pop(L, 1);
			}
			lua_pop(L, 1);
		}
	}

	return true;
}

bool getLives(float& vidas)
{
	lua_getglobal(L, "current_life");
	assert(lua_isnumber(L, -1) != 0);
	if (lua_isnumber(L, -1))
	{
		vidas = lua_tonumber(L, -1);
		lua_pop(L, 1);
	}

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
	// Link Lua file
	InitLua(LUA_FILENAME);
    return true;
}

bool EndGame()
{
	lua_close(L);
    return true;
}

/////////////////////////////////////////////////////////////////////
bool InitLua(const char* pFilename)
{
	L = luaL_newstate();
	luaL_openlibs(L);

	// register callback_lib
	luaL_register(L, "pacman_config_lib", pacman_config_lib);
	return ExecLuaFile(pFilename);
}

bool ExecLuaFile(const char* pFilename)
{
	int error = luaL_loadfile(L, pFilename);
	error = lua_pcall(L, 0, 0, 0);
	if (error)
	{
		fprintf(stderr, "%s", lua_tostring(L, -1));
		lua_pop(L, 1);
		return false;
	}

	return true;
}
/////////////////////////////////////////////////////////////////////