-- https://www.cnblogs.com/xdao/p/lua_file.html
local json = require("json")
local args = {...}
local version = "0.0.1"

if args[1] == "c" then
    io.input(args[2] .. ".json")
    local info_text = io.read("a")
    local info = json.decode(info_text)
    io.close()

    local single = function(file, file_info)
        file:write("#show: subreport.with(\n")
        file:write("  title: [" .. file_info["title"] .. "],\n")
        file:write("  date: \"" .. info["date"] .. "\",\n")
        file:write(")\n\n")
        file:write("#include \"../" .. file_info["id"] .. "/" .. file_info["id"] .. ".typ\"\n\n")
    end

    local file = io.open("./dist/" .. args[2] .. ".typ", "w")
    if file == nil then
        os.exit()
    end

    file:write("#import \"/template.typ\": *\n\n")
    file:write("#let date = [" .. info["date"] .. "]\n\n")
    file:write("#show: report_config.with(title: [" .. args[2].. "])\n\n")
    for _, v in ipairs(info["files"]) do
        single(file, v)
    end

    file:close()

    -- os.execute("typst compile --font-path ./fonts/ --root ./ ./dist/" .. info["source"] .. ".typ")
    os.execute("typst compile --font-path ./fonts/ --root ./ ./dist/" .. args[2] .. ".typ")
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

