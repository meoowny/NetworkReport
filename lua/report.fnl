(local json vim.json)
(local etlua (require :lua/etlua))
(local args _G.arg)
(local version :0.0.1)

(local info_template "
       {
        \"date\": \"
       }")
