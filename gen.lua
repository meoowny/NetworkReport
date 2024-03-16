-- https://www.cnblogs.com/xdao/p/lua_file.html
local json = require("json")

local file = io.input("meta.json")
local str = io.read("a")
local meta = json.decode(str)
io.close()
print(meta["test"])
print(meta["content"][1]["a"])
print(json.encode({1, 2, 3}))
os.execute("typst --version")

