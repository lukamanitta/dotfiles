lua << EOF

local notify = require('notify')

vim.notify = notify

notify.setup({
  -- Animation style (see below for details)
  stages = "fade_in_slide_out",

  -- Default timeout for notifications
  timeout = 5000,

  -- For stages that change opacity this is treated as the highlight behind the window
  background_colour = "Normal",

  -- Icons for the different levels
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "✎",
  },
})

notify.print_history = function()
  local color = {
    DEBUG = 'NotifyDEBUGTitle',
    TRACE = 'NotifyTRACETitle',
    INFO = 'NotifyINFOTitle',
    WARN = 'NotifyWARNTitle',
    ERROR = 'NotifyERRORTitle',
  }
  for _, m in ipairs(notify.history()) do
    vim.api.nvim_echo({
      {vim.fn.strftime('%FT%T', m.time), 'Identifier'},
      {' ', 'Normal'},
      {m.level, color[m.level] or 'Title'},
      {' ', 'Normal'},
      {table.concat(m.message, ' '), 'Normal'},
    }, false, {})
  end
end
vim.cmd([[command! NotifyHistory :lua require'notify'.print_history()<CR>]])

EOF
