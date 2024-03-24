-- https://www.cnblogs.com/xdao/p/lua_file.html
-- UTF-8 的编码问题：https://zhuanlan.zhihu.com/p/157815053
local json = require("json")
local args = {...}
local version = "0.0.1"

-- 单个实验报告的引入函数
local single = function(file, file_info, date)
    file:write("#show: subreport.with(\n")
    file:write("  title: [lab" .. file_info["id"] .. "-" .. file_info["title"] .. "],\n") -- 报告标题命名格式：lab<ID>-<TITLE>
    file:write("  date: \"" .. date .. "\",\n")
    file:write(")\n\n")
    file:write("#include \"../" .. file_info["id"] .. "/" .. file_info["id"] .. ".typ\"\n\n")
end

local chackhealth = function(info)
    if info["date"] == nil or info["files"] == nil then
        return false
    else
        for _, v in ipairs(info["files"]) do
            if v["id"] == nil then
                return false
            elseif v["title"] == nil then
                v["title"] = ""
            end
        end
    end
    return true
end

local copyFile = function(source, destination)
    return true
end

if args[1] == "c" then
    -- 编译
    if args[2] == nil then
        print("Json filename missed.")
        os.exit()
    end
    local target_name = args[2]

    -- 获取实验报告信息
    io.input("info/" .. target_name .. ".json")
    local info_text = io.read("a")
    local info = json.decode(info_text)
    io.close()
    if not chackhealth(info) then
        print("Broken info file.")
        os.exit()
    end

    -- 打开目标报告
    local file = io.open("./dist/" .. target_name .. ".typ", "w")
    if file == nil then
        print("Cannot open target file.")
        os.exit()
    end

    -- 生成目标报告
    local outFile = "2254198_段子涛"
    file:write("#import \"/template/template.typ\": *\n\n")
    file:write("#let date = [" .. info["date"] .. "]\n\n")
    file:write("#show: report_config.with(title: [" .. target_name.. "])\n\n")
    for _, v in ipairs(info["files"]) do
        single(file, v, info["date"])
        outFile = outFile .. "_" .. v["title"]
    end
    outFile = outFile .. ".pdf"

    file:close()

    -- 目标报告生成结束，调用系统指令进行编译
    os.execute("typst compile --font-path ./fonts/ --root ./ ./dist/" .. target_name .. ".typ")
    print("Complete")
elseif args[1] == "g" then
    -- 生成 json 或单报告文件
    if args[2] == nil then
        print("Mode missed.")
        os.exit()
    elseif args[3] == nil then
        print("Info filename missed.")
        os.exit()
    elseif args[2] == 'j' then
        -- 需要检查模版 json 是否还在
    elseif args[2] == 'r' then
    end
elseif args[1] == "h" then
    -- help
    print("c <meta file(json)> -> compile")
    print("g <experienment id> -> generate")
    print("h -> Display this help info.")
else
    print("v" .. version)
end

