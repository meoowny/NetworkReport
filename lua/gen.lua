-- https://www.cnblogs.com/xdao/p/lua_file.html
-- UTF-8 的编码问题: https://zhuanlan.zhihu.com/p/157815053
-- TypedLua: https://github.com/teal-language/tl https://zhuanlan.zhihu.com/p/40300705
local json = require("json")
local etlua = require("etlua")
local args = _G.arg
local version = "0.0.1"

local info_template_path = "./template/info.json"
local report_template_path = "./template/single.typ"

-- 单个实验报告的引入函数
local single = function(file, file_info, date)
    local template = etlua.compile [[
#show: subreport.with(
    title: [lab<%= id %>-<%= title %>],
    date: "<%= date %>",
)
#include "../<%= id %>/<%= id %>.typ"

]]
    file:write(template({
        id = file_info["id"],
        title = file_info["title"],
        date = date,
    }))
end

local existFile = function (filename, mode)
    if mode == nil then mode = "r" end
    local file = io.open(filename, mode)
    if file == nil then
        return false
    else
        file:close()
        return true
    end
end

local copyFile = function(source, destination)
    -- 读取源文件内容
    local src, error_info = io.open(source, "r")
    assert(src ~= nil, error_info)
    local content = src:read("a")
    src:close()
    -- 写入目标文件
    local dst, error_info_ = io.open(destination, "a")
    assert(dst ~= nil, error_info_)
    dst:write(content)
    dst:close()
    return true
end

-- 检查 json 文件完整性
local checkhealth = function(info)
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

if args[1] == "c" then
    -- 编译
    assert(args[2] ~= nil, "Json filename missed.")
    local target_name = args[2]

    -- 获取实验报告信息
    local target_file = io.open("info/" .. target_name .. ".json", "r")
    assert(target_file ~= nil, "Target file missed.")
    local info_text = target_file:read("a")
    local info = json.decode(info_text)
    target_file:close()
    assert(checkhealth(info), "Broken info file.")

    -- 打开目标报告
    local file = io.open("./dist/" .. target_name .. ".typ", "w")
    assert(file ~= nil, "Cannot open target file.")

    -- 生成目标报告
    local outFile = "2254198_段子涛"
    local infoTemplate = etlua.compile [[
#import "/template/template.typ": *

#let date = ["<%= date %>"]

#show: report_config.with(title: ["<%= name %>"])

]]
    file:write(infoTemplate({
        date = info["date"],
        name = target_name,
    }))
    for _, v in ipairs(info["files"]) do
        single(file, v, info["date"])
        outFile = outFile .. "_" .. v["title"]
    end
    outFile = outFile .. ".pdf"

    file:close()

    -- 目标报告生成结束，调用系统指令进行编译
    os.execute("typst compile --font-path ./fonts/ --root ./ ./dist/" .. target_name .. ".typ")
    print("Compile completed")
elseif args[1] == "g" then
    -- 生成 json 或单报告文件
    assert(args[2] ~= nil, "Mode missed.")
    assert(args[3] ~= nil, "Info filename missed.")
    local target_path = "info/" .. args[3] .. ".json"
    if args[2] == 'j' then
        -- 检查模版 json 是否还在
        assert(existFile(info_template_path), "Info template file missed.")
        copyFile(info_template_path, target_path)
        print(os.date("%Y %m %d %H:%M:%S"))
    elseif args[2] == 'r' then
        assert(existFile(report_template_path), "Report template file missed.")
        local target_file = io.open(target_path, "r")
        assert(target_file ~= nil, "Target file missed.")

        local info_text = target_file:read("a")
        local info = json.decode(info_text)
        target_file:close()
        assert(checkhealth(info), "Broken info file.")

        for _, v in ipairs(info["files"]) do
            local temp_name = "./" .. v["id"] .. "/" .. v["id"] .. ".typ"
            if not existFile(temp_name) then
                os.execute("mkdir " .. v["id"])
                copyFile(report_template_path, temp_name)
            end
        end
    end

    print("Generate completed.")
elseif args[1] == "h" then
    -- help
    print("c <meta file(json)> -> compile")
    print("g <experienment id> -> generate")
    print("   j <json name> -> json file")
    print("   r <json name> -> typst file")
    print("h -> Display this help info.")
else
    print("v" .. version)
end

