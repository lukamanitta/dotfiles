" Conceal markdown link text

syn region markdownLink matchgroup=markdownLinkDelimiter
    \ start="(" end=")"
    \ contains=markdownUrl
    \ keepend contained conceal

syn region markdownLinkText matchgroup=markdownLinkTextDelimiter
    \ start="!\=\[\%(\%(\_[^][]\|\[\_[^][]*\]\)*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@="
    \ nextgroup=markdownLink,markdownId skipwhite
    \ contains=@markdownInline,markdownLineStart
    \ concealends

" hi! link markdownLineBreak Comment
hi! link mkdLineBreak Comment

syn match mkdLineBreak '  $' conceal cchar=

hi mkdStrikethrough gui=strikethrough cterm=strikethrough

call matchadd('mkdStrikethrough', '\~\~\zs.\+\ze\~\~')
call matchadd('Conceal',  '\~\~\ze.\+\~\~', 10, -1, {'conceal':'~'})
call matchadd('Conceal',  '\~\~.\+\zs\~\~\ze', 10, -1, {'conceal':'~'})

set conceallevel=2

lua << EOF

local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg

for i = 1, 6 do
    vim.cmd("hi! htmlH" .. i .. " guifg=" .. get_hi_group_fg("rainbowcol" .. i) .. " gui=bold")
end

EOF
