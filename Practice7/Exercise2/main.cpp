#include <pacman_include.hpp>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include <assert.h>
#include "pacman.h"

lua_State* L;

const char* LUA_FILENAME = "./lua/pacman.lua";
bool InitLua(const char* pFilename);
bool ExecLuaFile(const char* pFilename);


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
	lua_getglobal(L, "player");
	assert(lua_isuserdata(L, -1) != 0);
	if (lua_isuserdata(L, -1))
	{
		vidas = ((Pacman*)lua_touserdata(L, -1))->m_fCurrentLife;
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
	luaL_newmetatable(L, "pacman.Metatable");

	// assign metatable to __index
	lua_pushvalue(L, -1); // duplicate metatable
	lua_setfield(L, -2, "__index");

	// use top of the pile as table
	luaL_register(L, NULL, pacman_mtds);
	luaL_register(L, "pacman", pacman_funcs);

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