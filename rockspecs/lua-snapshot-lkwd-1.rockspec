package = "lua-snapshot"
version = "lkwd-1"
source = {
  url = "https://github.com/lkwd/lua-snapshot",
}
description = {
  summary = "Lua memory snapshotter and diff",
  homepage = "https://github.com/lkwd/lua-snapshot",
  license = "see LICENSE"
}
dependencies = {
  "lua >= 5.1"
}
build = {
  type = "make",
  build_variables = {
    CFLAGS="$(CFLAGS)",
    LIBFLAG="$(LIBFLAG)",
    LUA_LIBDIR="$(LUA_LIBDIR)",
    LUA_BINDIR="$(LUA_BINDIR)",
    LUA_INCDIR="$(LUA_INCDIR)",
    LUA="$(LUA)",
  },
  install_variables = {
    INST_PREFIX="$(PREFIX)",
    INST_BINDIR="$(BINDIR)",
    INST_LIBDIR="$(LIBDIR)",
    INST_LUADIR="$(LUADIR)",
    INST_CONFDIR="$(CONFDIR)",
  },
  install_pass = false,
  install = {
    lua = {
      ["snapshotter.init"] = "init.lua",
      ["snapshotter.utils"] = "snapshot_utils.lua"
    },
    lib = { 
      ["snapshotter.lib"] = "libsnapshotter.so" 
    }
  }
}
