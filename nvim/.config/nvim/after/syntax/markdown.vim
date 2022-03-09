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

set conceallevel=2
