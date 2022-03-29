local colourscheme = require("settings.globals").colourscheme

local require_path = colourscheme:gsub("_", ".")

require("plugins.colourschemes." .. require_path)

require("plugins.lualine")
require("plugins.cokeline")
