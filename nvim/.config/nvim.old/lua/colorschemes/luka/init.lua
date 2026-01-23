-- Based on mini.base16

local p = require("colourschemes.Luka/palette")

local hi = function(group, args)
  -- NOTE: using `string.format` instead of gradually growing string with `..`
  -- is faster. Crude estimate for this particular case: whole colorscheme
  -- loading decreased from ~3.6ms to ~3.0ms, i.e. by about 20%.
  local command
  if args.link ~= nil then
    command = string.format('highlight! link %s %s', group, args.link)
  else
    command = string.format(
      'highlight %s guifg=%s guibg=%s gui=%s guisp=%s',
      group,
      args.fg or 'NONE',
      args.bg or 'NONE',
      args.attr or 'NONE',
      args.sp or 'NONE'
    )
  end
  vim.cmd(command)
end

-- stylua: ignore start
-- Builtin highlighting groups. Some groups which are missing in 'base16-vim'
-- are added based on groups to which they are linked.
hi('ColorColumn',    {fg=nil,      bg=p.base01, attr=nil,         sp=nil})
hi('Conceal',        {fg=p.base0D, bg=nil,      attr=nil,         sp=nil})
hi('CurSearch',      {fg=p.base01, bg=p.base09, attr=nil,         sp=nil})
hi('Cursor',         {fg=p.base00, bg=p.base05, attr=nil,         sp=nil})
hi('CursorColumn',   {fg=nil,      bg=p.base01, attr=nil,         sp=nil})
hi('CursorIM',       {fg=p.base00, bg=p.base05, attr=nil,         sp=nil})
hi('CursorLine',     {fg=nil,      bg=p.base01, attr=nil,         sp=nil})
hi('CursorLineFold', {fg=p.base0C, bg=p.base01, attr=nil,         sp=nil})
hi('CursorLineNr',   {fg=p.base04, bg=p.base01, attr=nil,         sp=nil})
hi('CursorLineSign', {fg=p.base03, bg=p.base01, attr=nil,         sp=nil})
hi('DiffAdd',        {fg=p.base0B, bg=p.base01, attr=nil,         sp=nil})
-- Differs from base16-vim, but according to general style guide
hi('DiffChange',     {fg=p.base0E, bg=p.base01, attr=nil,         sp=nil})
hi('DiffDelete',     {fg=p.base08, bg=p.base01, attr=nil,         sp=nil})
hi('DiffText',       {fg=p.base0D, bg=p.base01, attr=nil,         sp=nil})
hi('Directory',      {fg=p.base0D, bg=nil,      attr=nil,         sp=nil})
hi('EndOfBuffer',    {fg=p.base03, bg=nil,      attr=nil,         sp=nil})
hi('ErrorMsg',       {fg=p.base08, bg=p.base00, attr=nil,         sp=nil})
hi('FoldColumn',     {fg=p.base0C, bg=p.base01, attr=nil,         sp=nil})
hi('Folded',         {fg=p.base03, bg=p.base01, attr=nil,         sp=nil})
hi('IncSearch',      {fg=p.base01, bg=p.base09, attr=nil,         sp=nil})
hi('lCursor',        {fg=p.base00, bg=p.base05, attr=nil,         sp=nil})
hi('LineNr',         {fg=p.base03, bg=p.base01, attr=nil,         sp=nil})
hi('LineNrAbove',    {fg=p.base03, bg=p.base01, attr=nil,         sp=nil})
hi('LineNrBelow',    {fg=p.base03, bg=p.base01, attr=nil,         sp=nil})
-- Slight difference from base16, where `bg=base03` is used. This makes
-- it possible to comfortably see this highlighting in comments.
hi('MatchParen',     {fg=nil,      bg=p.base02, attr=nil,         sp=nil})
hi('ModeMsg',        {fg=p.base0B, bg=nil,      attr=nil,         sp=nil})
hi('MoreMsg',        {fg=p.base0B, bg=nil,      attr=nil,         sp=nil})
hi('MsgArea',        {fg=p.base05, bg=p.base00, attr=nil,         sp=nil})
hi('MsgSeparator',   {fg=p.base04, bg=p.base02, attr=nil,         sp=nil})
hi('NonText',        {fg=p.base03, bg=nil,      attr=nil,         sp=nil})
hi('Normal',         {fg=p.base05, bg=p.base00, attr=nil,         sp=nil})
hi('NormalFloat',    {fg=p.base05, bg=p.base01, attr=nil,         sp=nil})
hi('NormalNC',       {fg=p.base05, bg=p.base00, attr=nil,         sp=nil})
hi('PMenu',          {fg=p.base05, bg=p.base01, attr=nil,         sp=nil})
hi('PMenuSbar',      {fg=nil,      bg=p.base02, attr=nil,         sp=nil})
hi('PMenuSel',       {fg=p.base01, bg=p.base05, attr=nil,         sp=nil})
hi('PMenuThumb',     {fg=nil,      bg=p.base07, attr=nil,         sp=nil})
hi('Question',       {fg=p.base0D, bg=nil,      attr=nil,         sp=nil})
hi('QuickFixLine',   {fg=nil,      bg=p.base01, attr=nil,         sp=nil})
hi('Search',         {fg=p.base01, bg=p.base0A, attr=nil,         sp=nil})
hi('SignColumn',     {fg=p.base03, bg=p.base01, attr=nil,         sp=nil})
hi('SpecialKey',     {fg=p.base03, bg=nil,      attr=nil,         sp=nil})
hi('SpellBad',       {fg=nil,      bg=nil,      attr='undercurl', sp=p.base08})
hi('SpellCap',       {fg=nil,      bg=nil,      attr='undercurl', sp=p.base0D})
hi('SpellLocal',     {fg=nil,      bg=nil,      attr='undercurl', sp=p.base0C})
hi('SpellRare',      {fg=nil,      bg=nil,      attr='undercurl', sp=p.base0E})
hi('StatusLine',     {fg=p.base04, bg=p.base02, attr=nil,         sp=nil})
hi('StatusLineNC',   {fg=p.base03, bg=p.base01, attr=nil,         sp=nil})
hi('Substitute',     {fg=p.base01, bg=p.base0A, attr=nil,         sp=nil})
hi('TabLine',        {fg=p.base03, bg=p.base01, attr=nil,         sp=nil})
hi('TabLineFill',    {fg=p.base03, bg=p.base01, attr=nil,         sp=nil})
hi('TabLineSel',     {fg=p.base0B, bg=p.base01, attr=nil,         sp=nil})
hi('TermCursor',     {fg=nil,      bg=nil,      attr='reverse',   sp=nil})
hi('TermCursorNC',   {fg=nil,      bg=nil,      attr='reverse',   sp=nil})
hi('Title',          {fg=p.base0D, bg=nil,      attr=nil,         sp=nil})
hi('VertSplit',      {fg=p.base02, bg=p.base02, attr=nil,         sp=nil})
hi('Visual',         {fg=nil,      bg=p.base02, attr=nil,         sp=nil})
hi('VisualNOS',      {fg=p.base08, bg=nil,      attr=nil,         sp=nil})
hi('WarningMsg',     {fg=p.base08, bg=nil,      attr=nil,         sp=nil})
hi('Whitespace',     {fg=p.base03, bg=nil,      attr=nil,         sp=nil})
hi('WildMenu',       {fg=p.base08, bg=p.base0A, attr=nil,         sp=nil})
hi('WinBar',         {fg=p.base04, bg=p.base02, attr=nil,         sp=nil})
hi('WinBarNC',       {fg=p.base03, bg=p.base01, attr=nil,         sp=nil})
hi('WinSeparator',   {fg=p.base02, bg=p.base02, attr=nil,         sp=nil})

-- Standard syntax (affects treesitter)
hi('Boolean',        {fg=p.base09, bg=nil,      attr=nil, sp=nil})
hi('Character',      {fg=p.base08, bg=nil,      attr=nil, sp=nil})
hi('Comment',        {fg=p.base03, bg=nil,      attr=nil, sp=nil})
hi('Conditional',    {fg=p.base0E, bg=nil,      attr=nil, sp=nil})
hi('Constant',       {fg=p.base09, bg=nil,      attr=nil, sp=nil})
hi('Debug',          {fg=p.base08, bg=nil,      attr=nil, sp=nil})
hi('Define',         {fg=p.base0E, bg=nil,      attr=nil, sp=nil})
hi('Delimiter',      {fg=p.base0F, bg=nil,      attr=nil, sp=nil})
hi('Error',          {fg=p.base00, bg=p.base08, attr=nil, sp=nil})
hi('Exception',      {fg=p.base08, bg=nil,      attr=nil, sp=nil})
hi('Float',          {fg=p.base09, bg=nil,      attr=nil, sp=nil})
hi('Function',       {fg=p.base0D, bg=nil,      attr=nil, sp=nil})
hi('Identifier',     {fg=p.base08, bg=nil,      attr=nil, sp=nil})
hi('Ignore',         {fg=p.base0C, bg=nil,      attr=nil, sp=nil})
hi('Include',        {fg=p.base0D, bg=nil,      attr=nil, sp=nil})
hi('Keyword',        {fg=p.base0E, bg=nil,      attr=nil, sp=nil})
hi('Label',          {fg=p.base0A, bg=nil,      attr=nil, sp=nil})
hi('Macro',          {fg=p.base08, bg=nil,      attr=nil, sp=nil})
hi('Number',         {fg=p.base09, bg=nil,      attr=nil, sp=nil})
hi('Operator',       {fg=p.base05, bg=nil,      attr=nil, sp=nil})
hi('PreCondit',      {fg=p.base0A, bg=nil,      attr=nil, sp=nil})
hi('PreProc',        {fg=p.base0A, bg=nil,      attr=nil, sp=nil})
hi('Repeat',         {fg=p.base0A, bg=nil,      attr=nil, sp=nil})
hi('Special',        {fg=p.base0C, bg=nil,      attr=nil, sp=nil})
hi('SpecialChar',    {fg=p.base0F, bg=nil,      attr=nil, sp=nil})
hi('SpecialComment', {fg=p.base0C, bg=nil,      attr=nil, sp=nil})
hi('Statement',      {fg=p.base08, bg=nil,      attr=nil, sp=nil})
hi('StorageClass',   {fg=p.base0A, bg=nil,      attr=nil, sp=nil})
hi('String',         {fg=p.base0B, bg=nil,      attr=nil, sp=nil})
hi('Structure',      {fg=p.base0E, bg=nil,      attr=nil, sp=nil})
hi('Tag',            {fg=p.base0A, bg=nil,      attr=nil, sp=nil})
hi('Todo',           {fg=p.base0A, bg=p.base01, attr=nil, sp=nil})
hi('Type',           {fg=p.base0A, bg=nil,      attr=nil, sp=nil})
hi('Typedef',        {fg=p.base0A, bg=nil,      attr=nil, sp=nil})

-- Other from 'base16-vim'
hi('Bold',       {fg=nil,      bg=nil, attr='bold',      sp=nil})
hi('Italic',     {fg=nil,      bg=nil, attr='italic',    sp=nil})
hi('TooLong',    {fg=p.base08, bg=nil, attr=nil,         sp=nil})
hi('Underlined', {fg=nil,      bg=nil, attr='underline', sp=nil})

-- Patch diff
hi('diffAdded',   {fg=p.base0B, bg=nil, attr=nil, sp=nil})
hi('diffChanged', {fg=p.base0E, bg=nil, attr=nil, sp=nil})
hi('diffFile',    {fg=p.base09, bg=nil, attr=nil, sp=nil})
hi('diffLine',    {fg=p.base0C, bg=nil, attr=nil, sp=nil})
hi('diffRemoved', {fg=p.base08, bg=nil, attr=nil, sp=nil})
hi('Added',       {fg=p.base0B, bg=nil, attr=nil, sp=nil})
hi('Changed',     {fg=p.base0E, bg=nil, attr=nil, sp=nil})
hi('Removed',     {fg=p.base08, bg=nil, attr=nil, sp=nil})

-- Git commit
hi('gitcommitBranch',        {fg=p.base09, bg=nil, attr='bold', sp=nil})
hi('gitcommitComment',       {link='Comment'})
hi('gitcommitDiscarded',     {link='Comment'})
hi('gitcommitDiscardedFile', {fg=p.base08, bg=nil, attr='bold', sp=nil})
hi('gitcommitDiscardedType', {fg=p.base0D, bg=nil, attr=nil,    sp=nil})
hi('gitcommitHeader',        {fg=p.base0E, bg=nil, attr=nil,    sp=nil})
hi('gitcommitOverflow',      {fg=p.base08, bg=nil, attr=nil,    sp=nil})
hi('gitcommitSelected',      {link='Comment'})
hi('gitcommitSelectedFile',  {fg=p.base0B, bg=nil, attr='bold', sp=nil})
hi('gitcommitSelectedType',  {link='gitcommitDiscardedType'})
hi('gitcommitSummary',       {fg=p.base0B, bg=nil, attr=nil,    sp=nil})
hi('gitcommitUnmergedFile',  {link='gitcommitDiscardedFile'})
hi('gitcommitUnmergedType',  {link='gitcommitDiscardedType'})
hi('gitcommitUntracked',     {link='Comment'})
hi('gitcommitUntrackedFile', {fg=p.base0A, bg=nil, attr=nil,    sp=nil})

-- Built-in diagnostic
hi('DiagnosticError', {fg=p.base08, bg=nil, attr=nil, sp=nil})
hi('DiagnosticHint',  {fg=p.base0D, bg=nil, attr=nil, sp=nil})
hi('DiagnosticInfo',  {fg=p.base0C, bg=nil, attr=nil, sp=nil})
hi('DiagnosticOk',    {fg=p.base0B, bg=nil, attr=nil, sp=nil})
hi('DiagnosticWarn',  {fg=p.base0E, bg=nil, attr=nil, sp=nil})

hi('DiagnosticFloatingError', {fg=p.base08, bg=p.base01, attr=nil, sp=nil})
hi('DiagnosticFloatingHint',  {fg=p.base0D, bg=p.base01, attr=nil, sp=nil})
hi('DiagnosticFloatingInfo',  {fg=p.base0C, bg=p.base01, attr=nil, sp=nil})
hi('DiagnosticFloatingOk',    {fg=p.base0B, bg=p.base01, attr=nil, sp=nil})
hi('DiagnosticFloatingWarn',  {fg=p.base0E, bg=p.base01, attr=nil, sp=nil})

hi('DiagnosticSignError', {link='DiagnosticFloatingError'})
hi('DiagnosticSignHint',  {link='DiagnosticFloatingHint'})
hi('DiagnosticSignInfo',  {link='DiagnosticFloatingInfo'})
hi('DiagnosticSignOk',    {link='DiagnosticFloatingOk'})
hi('DiagnosticSignWarn',  {link='DiagnosticFloatingWarn'})

hi('DiagnosticUnderlineError', {fg=nil, bg=nil, attr='underline', sp=p.base08})
hi('DiagnosticUnderlineHint',  {fg=nil, bg=nil, attr='underline', sp=p.base0D})
hi('DiagnosticUnderlineInfo',  {fg=nil, bg=nil, attr='underline', sp=p.base0C})
hi('DiagnosticUnderlineOk',    {fg=nil, bg=nil, attr='underline', sp=p.base0B})
hi('DiagnosticUnderlineWarn',  {fg=nil, bg=nil, attr='underline', sp=p.base0E})

-- Built-in LSP
hi('LspReferenceText',  {fg=nil, bg=p.base02, attr=nil, sp=nil})
hi('LspReferenceRead',  {link='LspReferenceText'})
hi('LspReferenceWrite', {link='LspReferenceText'})

hi('LspSignatureActiveParameter', {link='LspReferenceText'})

hi('LspCodeLens',          {link='Comment'})
hi('LspCodeLensSeparator', {link='Comment'})

-- Tree-sitter
if vim.fn.has('nvim-0.8') == 1 then
-- Sources:
-- - `:h treesitter-highlight-groups`
-- - https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md#highlights
-- Included only those differing from default links
hi('@keyword.return', {fg=p.base08, bg=nil, attr=nil, sp=nil})
hi('@symbol',         {fg=p.base0E, bg=nil, attr=nil, sp=nil})
hi('@variable',       {fg=p.base05, bg=nil, attr=nil, sp=nil})

hi('@text.strong',   {fg=nil, bg=nil, attr='bold',          sp=nil})
hi('@text.emphasis', {fg=nil, bg=nil, attr='italic',        sp=nil})
hi('@text.strike',   {fg=nil, bg=nil, attr='strikethrough', sp=nil})
end

-- Semantic tokens
if vim.fn.has('nvim-0.9') == 1 then
-- Source: `:h lsp-semantic-highlight`
-- Included only those differing from default links
hi('@lsp.type.variable',      {fg=p.base05, bg=nil, attr=nil, sp=nil})

hi('@lsp.mod.defaultLibrary', {link='Special'})
hi('@lsp.mod.deprecated',     {fg=p.base08, bg=nil, attr=nil, sp=nil})
end

-- New tree-sitter groups
if vim.fn.has('nvim-0.10') == 1 then
-- Source: `:h treesitter-highlight-groups`
-- Included only those differing from default links
hi('@markup.strong',        {link='@text.strong'})
hi('@markup.italic',        {link='@text.emphasis'})
hi('@markup.strikethrough', {link='@text.strikethrough'})
hi('@markup.underline',     {link='@text.underline'})
end

-- Plugins
-- echasnovski/mini.nvim
hi('MiniAnimateCursor',      {fg=nil, bg=nil, attr='reverse,nocombine', sp=nil})
hi('MiniAnimateNormalFloat', {link='NormalFloat'})

hi('MiniClueBorder',              {link='NormalFloat'})
hi('MiniClueDescGroup',           {link='DiagnosticFloatingWarn'})
hi('MiniClueDescSingle',          {link='NormalFloat'})
hi('MiniClueNextKey',             {link='DiagnosticFloatingHint'})
hi('MiniClueNextKeyWithPostkeys', {link='DiagnosticFloatingError'})
hi('MiniClueSeparator',           {link='DiagnosticFloatingInfo'})
hi('MiniClueTitle',               {fg=p.base0D, bg=p.base01, attr='bold', sp=nil})

hi('MiniCompletionActiveParameter', {fg=nil, bg=p.base02, attr=nil, sp=nil})

hi('MiniCursorword',        {fg=nil, bg=nil, attr='underline', sp=nil})
hi('MiniCursorwordCurrent', {fg=nil, bg=nil, attr='underline', sp=nil})

hi('MiniDepsChangeAdded',   {link='diffAdded'})
hi('MiniDepsChangeRemoved', {link='diffRemoved'})
hi('MiniDepsHint',          {link='DiagnosticHint'})
hi('MiniDepsInfo',          {link='DiagnosticInfo'})
hi('MiniDepsPlaceholder',   {link='Comment'})
hi('MiniDepsTitle',         {link='Title'})
hi('MiniDepsTitleError',    {link='DiffDelete'})
hi('MiniDepsTitleSame',     {link='DiffText'})
hi('MiniDepsTitleUpdate',   {link='DiffAdd'})

hi('MiniDiffSignAdd',     {fg=p.base0B, bg=p.base01, attr=nil, sp=nil})
hi('MiniDiffSignChange',  {fg=p.base0E, bg=p.base01, attr=nil, sp=nil})
hi('MiniDiffSignDelete',  {fg=p.base08, bg=p.base01, attr=nil, sp=nil})
hi('MiniDiffOverAdd',     {link='DiffAdd'})
hi('MiniDiffOverChange',  {link='DiffText'})
hi('MiniDiffOverContext', {link='DiffChange'})
hi('MiniDiffOverDelete',  {link='DiffDelete'})

hi('MiniFilesBorder',         {link='NormalFloat'})
hi('MiniFilesBorderModified', {link='DiagnosticFloatingWarn'})
hi('MiniFilesCursorLine',     {fg=nil,      bg=p.base02, attr=nil,    sp=nil})
hi('MiniFilesDirectory',      {link='Directory'})
hi('MiniFilesFile',           {fg=p.base05, bg=nil,      attr=nil,    sp=nil})
hi('MiniFilesNormal',         {link='NormalFloat'})
hi('MiniFilesTitle',          {fg=p.base0D, bg=p.base01, attr=nil,    sp=nil})
hi('MiniFilesTitleFocused',   {fg=p.base0D, bg=p.base01, attr='bold', sp=nil})

hi('MiniHipatternsFixme', {fg=p.base00, bg=p.base08, attr='bold', sp=nil})
hi('MiniHipatternsHack',  {fg=p.base00, bg=p.base0E, attr='bold', sp=nil})
hi('MiniHipatternsNote',  {fg=p.base00, bg=p.base0D, attr='bold', sp=nil})
hi('MiniHipatternsTodo',  {fg=p.base00, bg=p.base0C, attr='bold', sp=nil})

hi('MiniIndentscopeSymbol',    {fg=p.base0F, bg=nil, attr=nil, sp=nil})
hi('MiniIndentscopeSymbolOff', {fg=p.base08, bg=nil, attr=nil, sp=nil})

hi('MiniJump', {link='SpellRare'})

hi('MiniJump2dDim',        {link='Comment'})
hi('MiniJump2dSpot',       {fg=p.base07, bg=p.base01, attr='bold,nocombine', sp=nil})
hi('MiniJump2dSpotAhead',  {fg=p.base06, bg=p.base00, attr='nocombine',      sp=nil})
hi('MiniJump2dSpotUnique', {link='MiniJump2dSpot'})

hi('MiniMapNormal',      {fg=p.base05, bg=p.base01, attr=nil, sp=nil})
hi('MiniMapSymbolCount', {fg=p.base0C, bg=nil,      attr=nil, sp=nil})
hi('MiniMapSymbolLine',  {fg=p.base0D, bg=nil,      attr=nil, sp=nil})
hi('MiniMapSymbolView',  {fg=p.base0F, bg=nil,      attr=nil, sp=nil})

hi('MiniNotifyBorder', {link='NormalFloat'})
hi('MiniNotifyNormal', {link='NormalFloat'})
hi('MiniNotifyTitle',  {link='FloatTitle'})

hi('MiniOperatorsExchangeFrom', {link='IncSearch'})

hi('MiniPickBorder',        {link='NormalFloat'})
hi('MiniPickBorderBusy',    {fg=p.base0E, bg=p.base01, attr=nil,    sp=nil})
hi('MiniPickBorderText',    {fg=p.base0D, bg=p.base01, attr='bold', sp=nil})
hi('MiniPickIconDirectory', {link='Directory'})
hi('MiniPickIconFile',      {fg=p.base05, bg=nil,      attr=nil,    sp=nil})
hi('MiniPickHeader',        {link='DiagnosticFloatingHint'})
hi('MiniPickMatchCurrent',  {fg=nil,      bg=p.base02, attr=nil,    sp=nil})
hi('MiniPickMatchMarked',   {fg=nil,      bg=p.base03, attr=nil,    sp=nil})
hi('MiniPickMatchRanges',   {link='DiagnosticFloatingHint'})
hi('MiniPickNormal',        {link='NormalFloat'})
hi('MiniPickPreviewLine',   {fg=nil,      bg=p.base02, attr=nil,    sp=nil})
hi('MiniPickPreviewRegion', {link='IncSearch'})
hi('MiniPickPrompt',        {fg=p.base0B, bg=p.base01, attr=nil,    sp=nil})

hi('MiniStarterCurrent',    {fg=nil,      bg=nil, attr=nil,    sp=nil})
hi('MiniStarterFooter',     {fg=p.base0D, bg=nil, attr=nil,    sp=nil})
hi('MiniStarterHeader',     {fg=p.base0D, bg=nil, attr=nil,    sp=nil})
hi('MiniStarterInactive',   {link='Comment'})
hi('MiniStarterItem',       {fg=p.base05, bg=nil, attr=nil,    sp=nil})
hi('MiniStarterItemBullet', {fg=p.base0F, bg=nil, attr=nil,    sp=nil})
hi('MiniStarterItemPrefix', {fg=p.base08, bg=nil, attr='bold', sp=nil})
hi('MiniStarterSection',    {fg=p.base0F, bg=nil, attr=nil,    sp=nil})
hi('MiniStarterQuery',      {fg=p.base0B, bg=nil, attr='bold', sp=nil})

hi('MiniStatuslineDevinfo',     {fg=p.base04, bg=p.base02, attr=nil,    sp=nil})
hi('MiniStatuslineFileinfo',    {link='MiniStatuslineDevinfo'})
hi('MiniStatuslineFilename',    {fg=p.base03, bg=p.base01, attr=nil,    sp=nil})
hi('MiniStatuslineInactive',    {link='MiniStatuslineFilename'})
hi('MiniStatuslineModeCommand', {fg=p.base00, bg=p.base08, attr='bold', sp=nil})
hi('MiniStatuslineModeInsert',  {fg=p.base00, bg=p.base0D, attr='bold', sp=nil})
hi('MiniStatuslineModeNormal',  {fg=p.base00, bg=p.base05, attr='bold', sp=nil})
hi('MiniStatuslineModeOther',   {fg=p.base00, bg=p.base03, attr='bold', sp=nil})
hi('MiniStatuslineModeReplace', {fg=p.base00, bg=p.base0E, attr='bold', sp=nil})
hi('MiniStatuslineModeVisual',  {fg=p.base00, bg=p.base0B, attr='bold', sp=nil})

hi('MiniSurround', {link='IncSearch'})

hi('MiniTablineCurrent',         {fg=p.base05, bg=p.base02, attr='bold', sp=nil})
hi('MiniTablineFill',            {fg=nil,      bg=nil,      attr=nil,    sp=nil})
hi('MiniTablineHidden',          {fg=p.base04, bg=p.base01, attr=nil,    sp=nil})
hi('MiniTablineModifiedCurrent', {fg=p.base02, bg=p.base05, attr='bold', sp=nil})
hi('MiniTablineModifiedHidden',  {fg=p.base01, bg=p.base04, attr=nil,    sp=nil})
hi('MiniTablineModifiedVisible', {fg=p.base02, bg=p.base04, attr='bold', sp=nil})
hi('MiniTablineTabpagesection',  {fg=p.base01, bg=p.base0A, attr='bold', sp=nil})
hi('MiniTablineVisible',         {fg=p.base05, bg=p.base01, attr='bold', sp=nil})

hi('MiniTestEmphasis', {fg=nil,      bg=nil, attr='bold', sp=nil})
hi('MiniTestFail',     {fg=p.base08, bg=nil, attr='bold', sp=nil})
hi('MiniTestPass',     {fg=p.base0B, bg=nil, attr='bold', sp=nil})

hi('MiniTrailspace', {link='Error'})

-- akinsho/bufferline.nvim
hi('BufferLineBuffer',              {fg=p.base04, bg=nil,      attr=nil,    sp=nil})
hi('BufferLineBufferSelected',      {fg=p.base05, bg=nil,      attr='bold', sp=nil})
hi('BufferLineBufferVisible',       {fg=p.base05, bg=nil,      attr=nil,    sp=nil})
hi('BufferLineCloseButton',         {link='BufferLineBackground'})
hi('BufferLineCloseButtonSelected', {link='BufferLineBufferSelected'})
hi('BufferLineCloseButtonVisible',  {link='BufferLineBufferVisible'})
hi('BufferLineFill',                {link='Normal'})
hi('BufferLineTab',                 {fg=p.base00, bg=p.base0A, attr=nil,    sp=nil})
hi('BufferLineTabSelected',         {fg=p.base00, bg=p.base0A, attr='bold', sp=nil})

-- anuvyklack/hydra.nvim
hi('HydraRed',      {fg=p.base08, bg=nil, attr=nil, sp=nil})
hi('HydraBlue',     {fg=p.base0D, bg=nil, attr=nil, sp=nil})
hi('HydraAmaranth', {fg=p.base0E, bg=nil, attr=nil, sp=nil})
hi('HydraTeal',     {fg=p.base0B, bg=nil, attr=nil, sp=nil})
hi('HydraPink',     {fg=p.base09, bg=nil, attr=nil, sp=nil})
hi('HydraHint',     {link='NormalFloat'})

-- DanilaMihailov/beacon.nvim
hi('Beacon', {fg=nil, bg=p.base07, attr=nil, sp=nil})

-- folke/lazy.nvim
hi('LazyButton',       {fg=nil, bg=p.base01, attr=nil,    sp=nil})
hi('LazyButtonActive', {fg=nil, bg=p.base02, attr=nil,    sp=nil})
hi('LazyDimmed',       {link='Comment'})
hi('LazyH1',           {fg=nil, bg=p.base02, attr='bold', sp=nil})

-- folke/noice.nvim
hi('NoiceCmdlinePopupBorder', {fg=p.base0D, bg=nil, attr=nil, sp=nil})
hi('NoiceConfirmBorder',      {fg=p.base0E, bg=nil, attr=nil, sp=nil})

-- folke/trouble.nvim
hi('TroubleCount',           {fg=p.base0B, bg=nil, attr='bold', sp=nil})
hi('TroubleFoldIcon',        {fg=p.base05, bg=nil, attr=nil,    sp=nil})
hi('TroubleIndent',          {fg=p.base02, bg=nil, attr=nil,    sp=nil})
hi('TroubleLocation',        {fg=p.base04, bg=nil, attr=nil,    sp=nil})
hi('TroubleSignError',       {link='DiagnosticError'})
hi('TroubleSignHint',        {link='DiagnosticHint'})
hi('TroubleSignInformation', {link='DiagnosticInfo'})
hi('TroubleSignOther',       {link='DiagnosticInfo'})
hi('TroubleSignWarning',     {link='DiagnosticWarn'})
hi('TroubleText',            {fg=p.base05, bg=nil, attr=nil,    sp=nil})
hi('TroubleTextError',       {link='TroubleText'})
hi('TroubleTextHint',        {link='TroubleText'})
hi('TroubleTextInformation', {link='TroubleText'})
hi('TroubleTextWarning',     {link='TroubleText'})

-- folke/todo-comments.nvim
-- Everything works correctly out of the box

-- folke/which-key.nvim
hi('WhichKey',          {fg=p.base0D, bg=nil,      attr=nil, sp=nil})
hi('WhichKeyDesc',      {fg=p.base05, bg=nil,      attr=nil, sp=nil})
hi('WhichKeyFloat',     {fg=p.base05, bg=p.base01, attr=nil, sp=nil})
hi('WhichKeyGroup',     {fg=p.base0E, bg=nil,      attr=nil, sp=nil})
hi('WhichKeySeparator', {fg=p.base0B, bg=p.base01, attr=nil, sp=nil})
hi('WhichKeyValue',     {fg=p.base03, bg=nil,      attr=nil, sp=nil})

-- ggandor/leap.nvim
hi('LeapMatch',          {fg=p.base0E, bg=nil, attr='bold,nocombine,underline', sp=nil})
hi('LeapLabelPrimary',   {fg=p.base08, bg=nil, attr='bold,nocombine',           sp=nil})
hi('LeapLabelSecondary', {fg=p.base05, bg=nil, attr='bold,nocombine',           sp=nil})
hi('LeapLabelSelected',  {fg=p.base09, bg=nil, attr='bold,nocombine',           sp=nil})
hi('LeapBackdrop',       {link='Comment'})

-- ggandor/lightspeed.nvim
hi('LightspeedLabel',          {fg=p.base0E, bg=nil, attr='bold,underline', sp=nil})
hi('LightspeedLabelDistant',   {fg=p.base0D, bg=nil, attr='bold,underline', sp=nil})
hi('LightspeedShortcut',       {fg=p.base07, bg=nil, attr='bold', sp=nil})
hi('LightspeedMaskedChar',     {fg=p.base04, bg=nil, attr=nil, sp=nil})
hi('LightspeedUnlabeledMatch', {fg=p.base05, bg=nil, attr='bold', sp=nil})
hi('LightspeedGreyWash',       {link='Comment'})
hi('LightspeedUniqueChar',     {link='LightspeedUnlabeledMatch'})
hi('LightspeedOneCharMatch',   {link='LightspeedShortcut'})
hi('LightspeedPendingOpArea',  {link='IncSearch'})
hi('LightspeedCursor',         {link='Cursor'})

-- glepnir/dashboard-nvim
hi('DashboardCenter',   {link='Delimiter'})
hi('DashboardFooter',   {link='Title'})
hi('DashboardHeader',   {link='Title'})
hi('DashboardShortCut', {link='WarningMsg'})

-- glepnir/lspsaga.nvim
hi('LspSagaCodeActionBorder',  {fg=p.base0F, bg=nil, attr=nil,    sp=nil})
hi('LspSagaCodeActionContent', {fg=p.base05, bg=nil, attr=nil,    sp=nil})
hi('LspSagaCodeActionTitle',   {fg=p.base0D, bg=nil, attr='bold', sp=nil})

hi('Definitions',            {fg=p.base0B, bg=nil, attr=nil, sp=nil})
hi('DefinitionsIcon',        {fg=p.base0D, bg=nil, attr=nil, sp=nil})
hi('FinderParam',            {fg=p.base08, bg=nil, attr=nil, sp=nil})
hi('FinderVirtText',         {fg=p.base09, bg=nil, attr=nil, sp=nil})
hi('LspSagaAutoPreview',     {fg=p.base0F, bg=nil, attr=nil, sp=nil})
hi('LspSagaFinderSelection', {fg=p.base0A, bg=nil, attr=nil, sp=nil})
hi('LspSagaLspFinderBorder', {fg=p.base0F, bg=nil, attr=nil, sp=nil})
hi('References',             {fg=p.base0B, bg=nil, attr=nil, sp=nil})
hi('ReferencesIcon',         {fg=p.base0D, bg=nil, attr=nil, sp=nil})
hi('TargetFileName',         {fg=p.base05, bg=nil, attr=nil, sp=nil})

hi('FinderSpinner',       {fg=p.base0B, bg=nil, attr=nil, sp=nil})
hi('FinderSpinnerBorder', {fg=p.base0F, bg=nil, attr=nil, sp=nil})
hi('FinderSpinnerTitle',  {link='Title'})

hi('LspSagaDefPreviewBorder', {fg=p.base0F, bg=nil, attr=nil, sp=nil})

hi('LspSagaHoverBorder', {fg=p.base0F, bg=nil, attr=nil, sp=nil})

hi('LspSagaRenameBorder', {fg=p.base0F, bg=nil, attr=nil, sp=nil})

hi('LspSagaDiagnosticBorder', {fg=p.base0F, bg=nil, attr=nil, sp=nil})
hi('LspSagaDiagnosticHeader', {link='Title'})
hi('LspSagaDiagnosticSource', {fg=p.base0E, bg=nil, attr=nil, sp=nil})

hi('LspSagaBorderTitle', {link='Title'})

hi('LspSagaSignatureHelpBorder', {fg=p.base0F, bg=nil, attr=nil, sp=nil})

hi('LSOutlinePreviewBorder', {fg=p.base0F, bg=nil, attr=nil, sp=nil})
hi('OutlineDetail',          {fg=p.base03, bg=nil, attr=nil, sp=nil})
hi('OutlineFoldPrefix',      {fg=p.base08, bg=nil, attr=nil, sp=nil})
hi('OutlineIndentEvn',       {fg=p.base04, bg=nil, attr=nil, sp=nil})
hi('OutlineIndentOdd',       {fg=p.base05, bg=nil, attr=nil, sp=nil})

-- HiPhish/rainbow-delimiters.nvim
hi('RainbowDelimiterBlue',   {fg=p.base0D, bg=nil, attr=nil, sp=nil})
hi('RainbowDelimiterCyan',   {fg=p.base0C, bg=nil, attr=nil, sp=nil})
hi('RainbowDelimiterGreen',  {fg=p.base0B, bg=nil, attr=nil, sp=nil})
hi('RainbowDelimiterOrange', {fg=p.base09, bg=nil, attr=nil, sp=nil})
hi('RainbowDelimiterRed',    {fg=p.base08, bg=nil, attr=nil, sp=nil})
hi('RainbowDelimiterViolet', {fg=p.base0E, bg=nil, attr=nil, sp=nil})
hi('RainbowDelimiterYellow', {fg=p.base0A, bg=nil, attr=nil, sp=nil})

-- hrsh7th/nvim-cmp
hi('CmpItemAbbr',           {fg=p.base05, bg=nil,      attr=nil,    sp=nil})
hi('CmpItemAbbrDeprecated', {fg=p.base03, bg=nil,      attr=nil,    sp=nil})
hi('CmpItemAbbrMatch',      {fg=p.base0A, bg=nil,      attr='bold', sp=nil})
hi('CmpItemAbbrMatchFuzzy', {fg=p.base0A, bg=nil,      attr='bold', sp=nil})
hi('CmpItemKind',           {fg=p.base0F, bg=p.base01, attr=nil,    sp=nil})
hi('CmpItemMenu',           {fg=p.base05, bg=p.base01, attr=nil,    sp=nil})

hi('CmpItemKindClass',         {link='Type'})
hi('CmpItemKindColor',         {link='Special'})
hi('CmpItemKindConstant',      {link='Constant'})
hi('CmpItemKindConstructor',   {link='Type'})
hi('CmpItemKindEnum',          {link='Structure'})
hi('CmpItemKindEnumMember',    {link='Structure'})
hi('CmpItemKindEvent',         {link='Exception'})
hi('CmpItemKindField',         {link='Structure'})
hi('CmpItemKindFile',          {link='Tag'})
hi('CmpItemKindFolder',        {link='Directory'})
hi('CmpItemKindFunction',      {link='Function'})
hi('CmpItemKindInterface',     {link='Structure'})
hi('CmpItemKindKeyword',       {link='Keyword'})
hi('CmpItemKindMethod',        {link='Function'})
hi('CmpItemKindModule',        {link='Structure'})
hi('CmpItemKindOperator',      {link='Operator'})
hi('CmpItemKindProperty',      {link='Structure'})
hi('CmpItemKindReference',     {link='Tag'})
hi('CmpItemKindSnippet',       {link='Special'})
hi('CmpItemKindStruct',        {link='Structure'})
hi('CmpItemKindText',          {link='Statement'})
hi('CmpItemKindTypeParameter', {link='Type'})
hi('CmpItemKindUnit',          {link='Special'})
hi('CmpItemKindValue',         {link='Identifier'})
hi('CmpItemKindVariable',      {link='Delimiter'})

-- justinmk/vim-sneak
hi('Sneak',      {fg=p.base00, bg=p.base0E, attr=nil,    sp=nil})
hi('SneakScope', {fg=p.base00, bg=p.base07, attr=nil,    sp=nil})
hi('SneakLabel', {fg=p.base00, bg=p.base0E, attr='bold', sp=nil})

-- 'kevinhwang91/nvim-ufo'
-- Everything works correctly out of the box

-- lewis6991/gitsigns.nvim
hi('GitSignsAdd',             {fg=p.base0B, bg=p.base01, attr=nil, sp=nil})
hi('GitSignsAddLn',           {link='GitSignsAdd'})
hi('GitSignsAddInline',       {link='GitSignsAdd'})

hi('GitSignsChange',          {fg=p.base0E, bg=p.base01, attr=nil, sp=nil})
hi('GitSignsChangeLn',        {link='GitSignsChange'})
hi('GitSignsChangeInline',    {link='GitSignsChange'})

hi('GitSignsDelete',          {fg=p.base08, bg=p.base01, attr=nil, sp=nil})
hi('GitSignsDeleteLn',        {link='GitSignsDelete'})
hi('GitSignsDeleteInline',    {link='GitSignsDelete'})

hi('GitSignsUntracked',       {fg=p.base0D, bg=p.base01, attr=nil, sp=nil})
hi('GitSignsUntrackedLn',     {link='GitSignsUntracked'})
hi('GitSignsUntrackedInline', {link='GitSignsUntracked'})

-- lukas-reineke/indent-blankline.nvim
hi('IndentBlanklineChar',         {fg=p.base02, bg=nil, attr='nocombine',           sp=nil})
hi('IndentBlanklineContextChar',  {fg=p.base0F, bg=nil, attr='nocombine',           sp=nil})
hi('IndentBlanklineContextStart', {fg=nil,      bg=nil, attr='underline,nocombine', sp=p.base0F})
hi('IndentBlanklineIndent1',      {fg=p.base08, bg=nil, attr='nocombine',           sp=nil})
hi('IndentBlanklineIndent2',      {fg=p.base09, bg=nil, attr='nocombine',           sp=nil})
hi('IndentBlanklineIndent3',      {fg=p.base0A, bg=nil, attr='nocombine',           sp=nil})
hi('IndentBlanklineIndent4',      {fg=p.base0B, bg=nil, attr='nocombine',           sp=nil})
hi('IndentBlanklineIndent5',      {fg=p.base0C, bg=nil, attr='nocombine',           sp=nil})
hi('IndentBlanklineIndent6',      {fg=p.base0D, bg=nil, attr='nocombine',           sp=nil})
hi('IndentBlanklineIndent7',      {fg=p.base0E, bg=nil, attr='nocombine',           sp=nil})
hi('IndentBlanklineIndent8',      {fg=p.base0F, bg=nil, attr='nocombine',           sp=nil})

-- neoclide/coc.nvim
hi('CocCodeLens',             {link='LspCodeLens'})
hi('CocDisabled',             {link='Comment'})
hi('CocFadeOut',              {link='Comment'})
hi('CocMarkdownLink',         {fg=p.base0F, bg=nil,      attr=nil, sp=nil})
hi('CocMenuSel',              {fg=nil,      bg=p.base02, attr=nil, sp=nil})
hi('CocNotificationProgress', {link='CocMarkdownLink'})
hi('CocPumVirtualText',       {link='CocMarkdownLink'})
hi('CocSearch',               {fg=p.base0A, bg=nil,      attr=nil, sp=nil})
hi('CocSelectedText',         {fg=p.base08, bg=nil,      attr=nil, sp=nil})

-- NeogitOrg/neogit
hi('NeogitCommitViewHeader',    {link='Special'})
hi('NeogitDiffAddHighlight',    {link='DiffAdd'})
hi('NeogitDiffAdd',             {link='DiffAdd'})
hi('NeogitDiffDeleteHighlight', {link='DiffDelete'})
hi('NeogitDiffDelete',          {link='DiffDelete'})
hi('NeogitFold',                {link='FoldColumn'})
hi('NeogitHunkHeader',          {fg=p.base0D, bg=nil, attr=nil,    sp=nil})
hi('NeogitHunkHeaderHighlight', {fg=p.base0D, bg=nil, attr='bold', sp=nil})
hi('NeogitNotificationError',   {link='DiagnosticError'})
hi('NeogitNotificationInfo',    {link='DiagnosticInfo'})
hi('NeogitNotificationWarning', {link='DiagnosticWarn'})

-- nvim-lualine/lualine.nvim
-- Everything works correctly out of the box

-- nvim-neo-tree/neo-tree.nvim
hi('NeoTreeDimText',              {fg=p.base03, bg=nil,      attr=nil,    sp=nil})
hi('NeoTreeDotfile',              {fg=p.base04, bg=nil,      attr=nil,    sp=nil})
hi('NeoTreeFadeText1',            {link='NeoTreeDimText'})
hi('NeoTreeFadeText2',            {fg=p.base02, bg=nil,      attr=nil,    sp=nil})
hi('NeoTreeGitAdded',             {fg=p.base0B, bg=nil,      attr=nil,    sp=nil})
hi('NeoTreeGitConflict',          {fg=p.base08, bg=nil,      attr='bold', sp=nil})
hi('NeoTreeGitDeleted',           {fg=p.base08, bg=nil,      attr=nil,    sp=nil})
hi('NeoTreeGitModified',          {fg=p.base0E, bg=nil,      attr=nil,    sp=nil})
hi('NeoTreeGitUnstaged',          {fg=p.base08, bg=nil,      attr=nil,    sp=nil})
hi('NeoTreeGitUntracked',         {fg=p.base0A, bg=nil,      attr=nil,    sp=nil})
hi('NeoTreeMessage',              {fg=p.base05, bg=p.base01, attr=nil,    sp=nil})
hi('NeoTreeModified',             {fg=p.base07, bg=nil,      attr=nil,    sp=nil})
hi('NeoTreeRootName',             {fg=p.base0D, bg=nil,      attr='bold', sp=nil})
hi('NeoTreeTabInactive',          {fg=p.base04, bg=nil,      attr=nil,    sp=nil})
hi('NeoTreeTabSeparatorActive',   {fg=p.base03, bg=p.base02, attr=nil,    sp=nil})
hi('NeoTreeTabSeparatorInactive', {fg=p.base01, bg=p.base01, attr=nil,    sp=nil})

-- nvim-telescope/telescope.nvim
hi('TelescopeBorder',         {fg=p.base0F, bg=nil,      attr=nil,    sp=nil})
hi('TelescopeMatching',       {fg=p.base0A, bg=nil,      attr=nil,    sp=nil})
hi('TelescopeMultiSelection', {fg=nil,      bg=p.base01, attr='bold', sp=nil})
hi('TelescopeSelection',      {fg=nil,      bg=p.base01, attr='bold', sp=nil})

-- nvim-tree/nvim-tree.lua
hi('NvimTreeExecFile',     {fg=p.base0B, bg=nil,      attr='bold',           sp=nil})
hi('NvimTreeFolderIcon',   {fg=p.base03, bg=nil,      attr=nil,              sp=nil})
hi('NvimTreeGitDeleted',   {fg=p.base08, bg=nil,      attr=nil,              sp=nil})
hi('NvimTreeGitDirty',     {fg=p.base08, bg=nil,      attr=nil,              sp=nil})
hi('NvimTreeGitMerge',     {fg=p.base0C, bg=nil,      attr=nil,              sp=nil})
hi('NvimTreeGitNew',       {fg=p.base0A, bg=nil,      attr=nil,              sp=nil})
hi('NvimTreeGitRenamed',   {fg=p.base0E, bg=nil,      attr=nil,              sp=nil})
hi('NvimTreeGitStaged',    {fg=p.base0B, bg=nil,      attr=nil,              sp=nil})
hi('NvimTreeImageFile',    {fg=p.base0E, bg=nil,      attr='bold',           sp=nil})
hi('NvimTreeIndentMarker', {link='NvimTreeFolderIcon'})
hi('NvimTreeOpenedFile',   {link='NvimTreeExecFile'})
hi('NvimTreeRootFolder',   {link='NvimTreeGitRenamed'})
hi('NvimTreeSpecialFile',  {fg=p.base0D, bg=nil,      attr='bold,underline', sp=nil})
hi('NvimTreeSymlink',      {fg=p.base0F, bg=nil,      attr='bold',           sp=nil})
hi('NvimTreeWindowPicker', {fg=p.base05, bg=p.base01, attr="bold",           sp=nil})

-- phaaazon/hop.nvim
hi('HopNextKey',   {fg=p.base0E, bg=nil, attr='bold,nocombine', sp=nil})
hi('HopNextKey1',  {fg=p.base08, bg=nil, attr='bold,nocombine', sp=nil})
hi('HopNextKey2',  {fg=p.base04, bg=nil, attr='bold,nocombine', sp=nil})
hi('HopPreview',   {fg=p.base09, bg=nil, attr='bold,nocombine', sp=nil})
hi('HopUnmatched', {link='Comment'})

-- rcarriere/nvim-dap-ui
hi('DapUIScope',                   {link='Title'})
hi('DapUIType',                    {link='Type'})
hi('DapUIModifiedValue',           {fg=p.base0E, bg=nil, attr='bold', sp=nil})
hi('DapUIDecoration',              {link='Title'})
hi('DapUIThread',                  {link='String'})
hi('DapUIStoppedThread',           {link='Title'})
hi('DapUISource',                  {link='Directory'})
hi('DapUILineNumber',              {link='Title'})
hi('DapUIFloatBorder',             {link='SpecialChar'})
hi('DapUIWatchesEmpty',            {link='ErrorMsg'})
hi('DapUIWatchesValue',            {link='String'})
hi('DapUIWatchesError',            {link='DiagnosticError'})
hi('DapUIBreakpointsPath',         {link='Directory'})
hi('DapUIBreakpointsInfo',         {link='DiagnosticInfo'})
hi('DapUIBreakpointsCurrentLine',  {fg=p.base0B, bg=nil, attr='bold', sp=nil})
hi('DapUIBreakpointsDisabledLine', {link='Comment'})

-- rcarriga/nvim-notify
hi('NotifyDEBUGBorder', {fg=p.base03, bg=nil, attr=nil, sp=nil})
hi('NotifyDEBUGIcon',   {link='NotifyDEBUGBorder'})
hi('NotifyDEBUGTitle',  {link='NotifyDEBUGBorder'})
hi('NotifyERRORBorder', {fg=p.base08, bg=nil, attr=nil, sp=nil})
hi('NotifyERRORIcon',   {link='NotifyERRORBorder'})
hi('NotifyERRORTitle',  {link='NotifyERRORBorder'})
hi('NotifyINFOBorder',  {fg=p.base0C, bg=nil, attr=nil, sp=nil})
hi('NotifyINFOIcon',    {link='NotifyINFOBorder'})
hi('NotifyINFOTitle',   {link='NotifyINFOBorder'})
hi('NotifyTRACEBorder', {fg=p.base0D, bg=nil, attr=nil, sp=nil})
hi('NotifyTRACEIcon',   {link='NotifyTRACEBorder'})
hi('NotifyTRACETitle',  {link='NotifyTRACEBorder'})
hi('NotifyWARNBorder',  {fg=p.base0E, bg=nil, attr=nil, sp=nil})
hi('NotifyWARNIcon',    {link='NotifyWARNBorder'})
hi('NotifyWARNTitle',   {link='NotifyWARNBorder'})

-- rlane/pounce.nvim
hi('PounceMatch',      {fg=p.base00, bg=p.base05, attr='bold,nocombine', sp=nil})
hi('PounceGap',        {fg=p.base00, bg=p.base03, attr='bold,nocombine', sp=nil})
hi('PounceAccept',     {fg=p.base00, bg=p.base08, attr='bold,nocombine', sp=nil})
hi('PounceAcceptBest', {fg=p.base00, bg=p.base0B, attr='bold,nocombine', sp=nil})

-- romgrk/barbar.nvim
hi('BufferCurrent',       {fg=p.base05, bg=p.base02, attr='bold', sp=nil})
hi('BufferCurrentIcon',   {fg=nil,      bg=p.base02, attr=nil,    sp=nil})
hi('BufferCurrentIndex',  {link='BufferCurrentIcon'})
hi('BufferCurrentMod',    {fg=p.base08, bg=p.base02, attr='bold', sp=nil})
hi('BufferCurrentSign',   {link='BufferCurrent'})
hi('BufferCurrentTarget', {fg=p.base0E, bg=p.base02, attr='bold', sp=nil})

hi('BufferInactive',       {fg=p.base04, bg=p.base01, attr=nil,    sp=nil})
hi('BufferInactiveIcon',   {fg=nil,      bg=p.base01, attr=nil,    sp=nil})
hi('BufferInactiveIndex',  {link='BufferInactiveIcon'})
hi('BufferInactiveMod',    {fg=p.base08, bg=p.base01, attr=nil,    sp=nil})
hi('BufferInactiveSign',   {link='BufferInactive'})
hi('BufferInactiveTarget', {fg=p.base0E, bg=p.base01, attr='bold', sp=nil})

hi('BufferOffset',      {link='Normal'})
hi('BufferTabpages',    {fg=p.base01, bg=p.base0A, attr='bold', sp=nil})
hi('BufferTabpageFill', {link='Normal'})

hi('BufferVisible',       {fg=p.base05, bg=p.base01, attr='bold', sp=nil})
hi('BufferVisibleIcon',   {fg=nil,      bg=p.base01, attr=nil,    sp=nil})
hi('BufferVisibleIndex',  {link='BufferVisibleIcon'})
hi('BufferVisibleMod',    {fg=p.base08, bg=p.base01, attr='bold', sp=nil})
hi('BufferVisibleSign',   {link='BufferVisible'})
hi('BufferVisibleTarget', {fg=p.base0E, bg=p.base01, attr='bold', sp=nil})

-- stevearc/aerial.nvim
-- Everything works correctly out of the box

-- williamboman/mason.nvim
hi('MasonError',                       {fg=p.base08, bg=nil,      attr=nil,    sp=nil})
hi('MasonHeader',                      {fg=p.base00, bg=p.base0D, attr='bold', sp=nil})
hi('MasonHeaderSecondary',             {fg=p.base00, bg=p.base0F, attr='bold', sp=nil})
hi('MasonHeading',                     {link='Bold'})
hi('MasonHighlight',                   {fg=p.base0F, bg=nil,      attr=nil,    sp=nil})
hi('MasonHighlightBlock',              {fg=p.base00, bg=p.base0F, attr=nil,    sp=nil})
hi('MasonHighlightBlockBold',          {link='MasonHeaderSecondary'})
hi('MasonHighlightBlockBoldSecondary', {link='MasonHeader'})
hi('MasonHighlightBlockSecondary',     {fg=p.base00, bg=p.base0D, attr=nil,    sp=nil})
hi('MasonHighlightSecondary',          {fg=p.base0D, bg=nil,      attr=nil,    sp=nil})
hi('MasonLink',                        {link='MasonHighlight'})
hi('MasonMuted',                       {link='Comment'})
hi('MasonMutedBlock',                  {fg=p.base00, bg=p.base03, attr=nil,    sp=nil})
hi('MasonMutedBlockBold',              {fg=p.base00, bg=p.base03, attr='bold', sp=nil})
-- stylua: ignore end
