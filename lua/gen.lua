-- https://www.cnblogs.com/xdao/p/lua_file.html
-- UTF-8 的编码问题: https://zhuanlan.zhihu.com/p/157815053
-- TypedLua: https://github.com/teal-language/tl https://zhuanlan.zhihu.com/p/40300705
--local json = require("lua/json")
local json = vim.json
local etlua = require("lua/etlua")
local args = _G.arg
local version = "0.0.1"

-- local info_template_path = "./template/info.json"
-- local report_template_path = "./template/single.typ"
local info_template = etlua.compile [[
{
    "date": "<%= year %> 年 <%= month %> 月 <%= day %> 日",
    "files": [
        {
            "title": "",
            "id": ""
        },
        {
            "title": "",
            "id": ""
        }
    ]
}
]]
local report_template = etlua.compile [[
// <%= title %>

= 实验目的

= 实验原理

= 实验设备

- 实验硬件：济事楼 330 机房电脑
- 实验软件：

= 实验步骤

= 实验现象

= 分析讨论

]]

-- 单个实验报告的引入函数
local single = function(file, file_info, date)
  local template = etlua.compile [[
#show: subreport.with(
    title: [lab<%= id %>-<%= title %>],
    date: "<%= date %>",
)
#include "../src/<%= id %>.typ"

]]
  file:write(template({
    id = file_info.id,
    title = file_info.title,
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

local writeFile = function(destination, content)
  local dst, error_info = io.open(destination, "a")
  assert(dst ~= nil, error_info)
  dst:write(content)
  dst:close()
end

-- local copyFile = function(source, destination)
--   -- 读取源文件内容
--   local src, error_info = io.open(source, "r")
--   assert(src ~= nil, error_info)
--   local content = src:read("a")
--   src:close()
--   -- 写入目标文件
--   writeFile(destination, content)
--   return true
-- end

-- 检查 json 文件完整性
local checkhealth = function(info)
  if info.date == nil or info.files == nil then
    return false
  else
    for _, v in ipairs(info.files) do
      if v.id == nil then
        return false
      elseif v.title == nil then
        v.title = ""
      end
    end
  end
  return true
end

if args[1] == "c" or args[1] == "w" then
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
    date = info.date,
    name = target_name,
  }))
  for _, v in ipairs(info.files) do
    single(file, v, info.date)
    outFile = outFile .. "_" .. v.title
  end
  outFile = outFile .. ".pdf"

  file:close()

  -- 目标报告生成结束，调用系统指令进行编译
  if args[1] == "c" then
    os.execute("typst compile --font-path ./fonts/ --root ./ ./dist/" .. target_name .. ".typ")
  elseif args[1] == "w" then
    os.execute("typst watch --font-path ./fonts/ --root ./ ./dist/" .. target_name .. ".typ --open okular")
  end
  print("Compile completed")
elseif args[1] == "g" then
  -- 生成 json 或单报告文件
  assert(args[2] ~= nil, "Mode missed.")
  assert(args[3] ~= nil, "Info filename missed.")
  local target_path = "info/" .. args[3] .. ".json"
  if args[2] == 'j' then
    -- 检查模版 json 是否还在
    -- assert(existFile(info_template_path), "Info template file missed.")
    -- copyFile(info_template_path, target_path)
    writeFile(target_path, info_template{
      year = os.date("*t").year,
      month = os.date("*t").month,
      day = os.date("*t").day,
    })
    print(os.date("%Y %m %d %H:%M:%S"))
  elseif args[2] == 'r' then
    -- assert(existFile(report_template_path), "Report template file missed.")
    local target_file = io.open(target_path, "r")
    assert(target_file ~= nil, "Target file missed.")

    local info_text = target_file:read("a")
    local info = json.decode(info_text)
    target_file:close()
    assert(checkhealth(info), "Broken info file.")

    for _, v in ipairs(info.files) do
      local temp_name = "./src/" .. v.id .. ".typ"
      if not existFile(temp_name) then
        -- os.execute("mkdir " .. v["id"])
        -- copyFile(report_template_path, temp_name)
        writeFile(temp_name, report_template{
          title = v.title,
        })
      end
    end
  end

  print("Generate completed.")
elseif args[1] == "h" then
  -- help
  print("c <meta file(json)> -> compile")
  print("w <meta file(json)> -> watch")
  print("g <experienment id> -> generate")
  print("   j <json name> -> json file")
  print("   r <json name> -> typst file")
  print("h -> Display this help info.")
else
  print("v" .. version)
end

