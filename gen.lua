-- https://www.cnblogs.com/xdao/p/lua_file.html
local json = require("json")
local args = {...}

if args[1] == "c" then

    local file = io.input(args[2] .. ".json")
    local info_text = io.read("a")
    local info = json.decode(info_text)
    io.close()

    -- TODO: 生成文件

    os.execute("typst compile --font-path ./fonts/ --root ./ ./dist/" .. info["source"] .. ".typ")
    os.execute("echo Complete")

end

