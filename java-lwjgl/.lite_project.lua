local core = require "core"
local config = require "core.config"


-- Ignore
table.insert(config.ignore_files, "lib")
table.insert(config.ignore_files, "bin")
table.insert(config.ignore_files, ".tools")

table.insert(config.ignore_files, ".lite_project.lua")

table.insert(config.ignore_files, ".git")


-- Disable
config.plugins.lsp_java = false


-- LSP Server
local lsp = require "plugins.lsp"

local function find_jars(rel_path, substring)
  local results = {}
  local base = system.absolute_path(rel_path)
  local function scan(dir)
    local entries = system.list_dir(dir)
    if not entries then return end
    for _, entry in ipairs(entries) do
      local abs = dir .. "/" .. entry
      local info = system.get_file_info(abs)
      if info and info.type == "dir" then
        scan(abs)
      elseif entry:match("%.jar$") then
        -- If a filter is provided, only include matching jars
        if not substring or entry:find(substring, 1, true) then
          table.insert(results, abs)
        end
      end
    end
  end
  scan(base)
  return results
end

local function append_to(target, source)
  for _, v in ipairs(source) do
    table.insert(target, v)
  end
end

local function find_folders(root_dir)
  local base = system.absolute_path(root_dir .. "/")
  local results = {}
  local entries = system.list_dir(base)
  if not entries then return results end
  for _, entry in ipairs(entries) do
    local abs = base .. "/" .. entry
    local info = system.get_file_info(abs)
    if info and info.type == "dir" then
      table.insert(results, abs)
    end
  end
  return results
end


local libs = {}
local sources = {}

-- This line needs to be wrapped inside a coroutine and launched in the background
-- append_to(libs, find_jars("/usr/lib/jvm/java-21-openjdk", ""))
-- append_to(libs, find_jars("./lib", ""))

---# Java - java-language-server
--- __Status__: Works
--- __Site__: https://github.com/georgewfraser/java-language-server
--- __Installation__: https://aur.archlinux.org/java-language-server.git
lsp.add_server {
  name = "java-language-server",
  language = "Java",
  file_patterns = { "%.java$" },
  command = { "java-language-server" },
  verbose = false,
  root_dir = system.absolute_path(".") .. "/",
  -- WIP: fix go-to-definition
  init_options = {
    extendedClientCapabilities = {
      classFileContentsSupport = true
    }
  },
  settings = {
    java = {
      sourcePath = find_folders("./src"),
      classPath = find_jars("./lib", ""),
      docPath = find_jars("./lib", "sources")
    }
  }
}
