#include "LuaBindings/ShadowMeshComponent_Lua.h"
#include "LuaBindings/StaticMeshComponent_Lua.h"
#include "LuaBindings/Vector_Lua.h"
#include "LuaBindings/Asset_Lua.h"
#include "LuaBindings/LuaUtils.h"

#if LUA_ENABLED

void ShadowMeshComponent_Lua::Bind()
{
    lua_State* L = GetLua();
    int mtIndex = CreateClassMetatable(
        SHADOW_MESH_COMPONENT_LUA_NAME,
        SHADOW_MESH_COMPONENT_LUA_FLAG,
        STATIC_MESH_COMPONENT_LUA_NAME);

    lua_pushcfunction(L, Component_Lua::Destroy);
    lua_setfield(L, mtIndex, "__gc");

    lua_pop(L, 1);
    OCT_ASSERT(lua_gettop(L) == 0);
}

#endif
