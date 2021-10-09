local previewers = require('telescope.previewers')
local Job = require('plenary.job')

local T = {}

function T.smart_file_finder()
    local opts = {}
    local git_dir = pcall(require'telescope.builtin'.git_files, opts)
    if not git_dir then require'telescope.builtin'.find_files(opts) end
end

function T.smart_buf_preview_maker(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  Job:new({
    command = 'file',
    args = { '--mime-type', '-b', filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], '/')[1]
      if mime_type == "text" then
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      else
        -- maybe we want to write something to the buffer here
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'BINARY' })
        end)
      end
    end
  }):sync()
end

return T
