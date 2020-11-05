#pragma once

struct Pacman
{
    float m_fCurrentLife;
	float m_fSpeed;
    int m_vCurrentColor[3];
    float m_fScore;
	int m_iCoins;
};

static int newPacman(lua_State* L)
{
	float life = luaL_checknumber(L, 1);
	float speed = luaL_checknumber(L, 2);
	int color[3];
	if (lua_istable(L, 3))
	{
		lua_getfield(L, 3, "r");
		lua_getfield(L, 3, "g");
		lua_getfield(L, 3, "b");
		for (int i = 2; i >= 0; --i)
		{
			if (lua_isnumber(L, -1))
			{
				color[i] = lua_tointeger(L, -1);
				lua_pop(L, 1);
			}
		}
	}

	Pacman* pacman = (Pacman*)lua_newuserdata(L, sizeof(Pacman));

	pacman->m_fCurrentLife = life;
	pacman->m_fSpeed = speed;
	pacman->m_fScore = 0;
	pacman->m_iCoins = 0;
	for (unsigned int idx = 0; idx < 3; ++idx)
	{
		pacman->m_vCurrentColor[idx] = color[idx];
	}

	luaL_getmetatable(L, "pacman.Metatable");
	lua_setmetatable(L, -2);

	return 1;
}

// Life getter and setter
static int getCurrentLife(lua_State* L)
{
    if (lua_isuserdata(L, 1))
    {
	    Pacman* pm = (Pacman*)lua_touserdata(L, 1);
		if (pm)
		{
			lua_pushnumber(L, pm->m_fCurrentLife);
			return 1;
		}
    }

	return 0;
}

static int setCurrentLife(lua_State* L)
{
	if (lua_isuserdata(L, 1))
	{
		Pacman* pm = (Pacman*)lua_touserdata(L, 1);
		if (pm)
		{
			if (lua_isnumber(L, 2))
			{
				pm->m_fCurrentLife = lua_tonumber(L, 2);
			}
		}
	}

	return 0;
}

static int decreaseCurrentLife(lua_State* L)
{
	if (lua_isuserdata(L, 1))
	{
		Pacman* pm = (Pacman*)lua_touserdata(L, 1);
		if (pm)
		{
			if (lua_isnumber(L, 2))
			{
				pm->m_fCurrentLife -= lua_tonumber(L, 2);
			}
		}
	}

	return 0;
}

// Check dead
static int isDead(lua_State* L)
{
	if (lua_isuserdata(L, 1))
	{
		Pacman* pm = (Pacman*)lua_touserdata(L, 1);
		if (pm)
		{
			lua_pushboolean(L, pm->m_fCurrentLife < 0.0f);
			return 1;
		}
	}

	return 0;
}

// Speed getter and setter
static int getSpeed(lua_State* L)
{
	if (lua_isuserdata(L, 1))
	{
		Pacman* pm = (Pacman*)lua_touserdata(L, 1);
		if (pm)
		{
			lua_pushnumber(L, pm->m_fSpeed);
			return 1;
		}
	}

	return 0;
}

static int setSpeed(lua_State* L)
{
	if (lua_isuserdata(L, 1))
	{
		Pacman* pm = (Pacman*)lua_touserdata(L, 1);
		if (pm)
		{
			if (lua_isnumber(L, 2))
			{
				pm->m_fSpeed = lua_tonumber(L, 2);
				setPacmanSpeedMultiplier(pm->m_fSpeed);
			}
		}
	}

	return 0;
}

// Color getter and setter
static int getColor(lua_State* L)
{
	if (lua_isuserdata(L, 1))
	{
		Pacman* pm = (Pacman*)lua_touserdata(L, 1);
		if (pm)
		{
			lua_pushinteger(L, pm->m_vCurrentColor[0]);
			lua_pushinteger(L, pm->m_vCurrentColor[1]);
			lua_pushinteger(L, pm->m_vCurrentColor[2]);
			return 3;
		}
	}

	return 0;
}

static int setColor(lua_State* L)
{
	if (lua_isuserdata(L, 1))
	{
		Pacman* pm = (Pacman*)lua_touserdata(L, 1);
		if (pm)
		{
			if (lua_istable(L, 2))
			{
				lua_getfield(L, 2, "r");
				lua_getfield(L, 2, "g");
				lua_getfield(L, 2, "b");
				for (int i = 2; i >= 0; --i)
				{
					assert(lua_isnumber(L, -1));
					if (lua_isnumber(L, -1))
					{
						pm->m_vCurrentColor[i] = lua_tointeger(L, -1);
						lua_pop(L, 1);
					}
				}
				setPacmanColor(pm->m_vCurrentColor[0], pm->m_vCurrentColor[1], pm->m_vCurrentColor[2]);
			}
		}
	}

	return 0;
}

// Score getter and setter
static int getScore (lua_State* L)
{
	if (lua_isuserdata(L, 1))
	{
		Pacman* pm = (Pacman*)lua_touserdata(L, 1);
		if (pm)
		{
			lua_pushnumber(L, pm->m_fScore);
			return 1;
		}
	}

	return 0;
}

static int setScore(lua_State* L)
{
	if (lua_isuserdata(L, 1))
	{
		Pacman* pm = (Pacman*)lua_touserdata(L, 1);
		if (pm)
		{
			if (lua_isnumber(L, 2))
			{
				pm->m_fScore = lua_tonumber(L, 2);
			}
		}
	}

	return 0;
}

static int increaseScore(lua_State* L)
{
	if (lua_isuserdata(L, 1))
	{
		Pacman* pm = (Pacman*)lua_touserdata(L, 1);
		if (pm)
		{
			if (lua_isnumber(L, 2))
			{
				pm->m_fScore += lua_tonumber(L, 2);
			}
		}
	}

	return 0;
}

// Coins getter and setter
static int getCoins(lua_State* L)
{
	if (lua_isuserdata(L, 1))
	{
		Pacman* pm = (Pacman*)lua_touserdata(L, 1);
		if (pm)
		{
			lua_pushinteger(L, pm->m_iCoins);
			return 1;
		}
	}

	return 0;
}

static int setCoins(lua_State* L)
{
	if (lua_isuserdata(L, 1))
	{
		Pacman* pm = (Pacman*)lua_touserdata(L, 1);
		if (pm)
		{
			if (lua_isnumber(L, 2))
			{
				pm->m_iCoins = lua_tointeger(L, 2);
			}
		}
	}

	return 0;
}

static int increaseCoins(lua_State* L)
{
	if (lua_isuserdata(L, 1))
	{
		Pacman* pm = (Pacman*)lua_touserdata(L, 1);
		if (pm)
		{
			if (lua_isnumber(L, 2))
			{
				pm->m_iCoins += lua_tointeger(L, 2);
			}
		}
	}

	return 0;
}

// Set powerUp duration
static int setPowerUpTime(lua_State* L)
{
	if (lua_isuserdata(L, 1))
	{
		if (lua_isnumber(L, 2))
		{
			setPowerUpTime(lua_tonumber(L, 2));
		}
	}
	return 0;
}

// Compute medals
static int computeMedals(lua_State* L)
{
	if (lua_isuserdata(L, 1))
	{
		Pacman* pm = (Pacman*)lua_touserdata(L, 1);
		if (pm)
		{
			int pointsForBronze;
			if (lua_isnumber(L, 2))
			{
				pointsForBronze = lua_tointeger(L, 2);
			}

			int bronzesForSilver;
			if (lua_isnumber(L, 3))
			{
				bronzesForSilver = lua_tointeger(L, 3);
			}

			int silversForGold;
			if (lua_isnumber(L, 4))
			{
				silversForGold = lua_tointeger(L, 4);
			}


			int bronze, silver, gold;

			bronze = pm->m_fScore / pointsForBronze;

			silver = bronze / bronzesForSilver;
			bronze = bronze % bronzesForSilver;

			gold = silver / silversForGold;
			silver = silver % silversForGold;

			lua_pushinteger(L, bronze);
			lua_pushinteger(L, silver);
			lua_pushinteger(L, gold);
			return 3;
		}
	}

	return 0;
}

// Create register structs
static const struct luaL_Reg pacman_funcs[] =
{
	{"new", newPacman},
	{NULL, NULL}
};

static const struct luaL_Reg pacman_mtds[] =
{
	{"getCurrentLife", getCurrentLife},
	{"setCurrentLife", setCurrentLife},
	{"decreaseCurrentLife", decreaseCurrentLife},
	{"isDead", isDead},
	{"getSpeed", getSpeed},
	{"setSpeed", setSpeed},
	{"getColor", getColor},
	{"setColor", setColor},
	{"getScore", getScore},
	{"increaseScore", increaseScore},
	{"setScore", setScore},
	{"getCoins", getCoins},
	{"setCoins", setCoins},
	{"increaseCoins", increaseCoins},
	{"setPowerUpTime", setPowerUpTime},
	{"computeMedals", computeMedals},
	{NULL,NULL},
};