local g = vim.g
local api, cmd = vim.api, vim.cmd
local U = {}

-- Key mapping
function U.map(mode, key, result, opts)
  opts =
    vim.tbl_extend(
    "keep",
    opts or {},
    {
      noremap = true,
      silent = true,
      expr = false
    }
  )
  api.nvim_set_keymap(mode, key, result, opts)
end

function U.apply_options(opts)
  for k, v in pairs(opts) do
    if v == true then
      cmd("set " .. k)
    elseif v == false then
      cmd(string.format("set no%s", k))
    else
      cmd(string.format("set %s=%s", k, v))
    end
  end
end

function U.apply_globals(opts)
  for k, v in pairs(opts) do
    g[k] = v
  end
end

function _G.check_backspace()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

return U
