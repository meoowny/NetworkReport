-- https://www.cnblogs.com/xdao/p/lua_file.html
local json = require("json")
local args = {...}
local version = "0.0.1"

if args[1] == "c" then
    io.input(args[2] .. ".json")
    local info_text = io.read("a")
    local info = json.decode(info_text)
    io.close()

    -- TODO: 生成文件

    os.execute("typst compile --font-path ./fonts/ --root ./ ./dist/" .. info["source"] .. ".typ")
    os.execute("echo Complete")
elseif args[1] == "g" then
    -- 生成 json
elseif args[1] == "h" then
    -- help
    print("c <meta file(json)> -> compile")
    print("g <experienment id> -> generate")
    print("h -> Display this help info.")
else
    print("v" .. version)
end

