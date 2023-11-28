-- Trying to make it look like https://user-images.githubusercontent.com/71196912/206819620-af569a8f-87ad-4b27-b08c-01bb547fa570.png

local cmp_item_kind_highlights = {
    "CmpItemKindTypeParameterDefault",
    "CmpItemKindConstructorDefault",
    "CmpItemKindEnumMemberDefault",
    "CmpItemKindReferenceDefault",
    "CmpItemKindInterfaceDefault",
    "CmpItemKindVariableDefault",
    "CmpItemKindPropertyDefault",
    "CmpItemKindOperatorDefault",
    "CmpItemKindFunctionDefault",
    "CmpItemKindConstantDefault",
    "CmpItemKindSnippetDefault",
    "CmpItemKindKeywordDefault",
    "CmpItemKindTypeParameter",
    "CmpItemKindStructDefault",
    "CmpItemKindModuleDefault",
    "CmpItemKindMethodDefault",
    "CmpItemKindFolderDefault",
    "CmpItemKindValueDefault",
    "CmpItemKindFieldDefault",
    "CmpItemKindEventDefault",
    "CmpItemKindColorDefault",
    "CmpItemKindClassDefault",
    "CmpItemKindUnitDefault",
    "CmpItemKindTextDefault",
    "CmpItemKindFileDefault",
    "CmpItemKindEnumDefault",
    "CmpItemKindConstructor",
    "CmpItemKindEnumMember",
    "CmpItemKindReference",
    "CmpItemKindInterface",
    "CmpItemKindVariable",
    "CmpItemKindProperty",
    "CmpItemKindOperator",
    "CmpItemKindFunction",
    "CmpItemKindConstant",
    "CmpItemKindSnippet",
    "CmpItemKindKeyword",
    "CmpItemKindDefault",
    "CmpItemKindCopilot",
    "CmpItemKindStruct",
    "CmpItemKindModule",
    "CmpItemKindMethod",
    "CmpItemKindFolder",
    "CmpItemKindValue",
    "CmpItemKindField",
    "CmpItemKindEvent",
    "CmpItemKindColor",
    "CmpItemKindClass",
    "CmpItemKindUnit",
    "CmpItemKindText",
    "CmpItemKindFile",
    "CmpItemKindEnum",
}

local get_hl = require("helpers").get_hl

local new_fg = get_hl("Pmenu", "bg#")

-- For each of the above highlight groups, swap the foreground and background
-- TODO: not working because of links in Gruvbox colour scheme
for _, highlight in ipairs(cmp_item_kind_highlights) do
    local bg = get_hl(highlight, "fg#")
    if bg ~= "" then
        vim.cmd("hi " .. highlight .. " guifg=" .. new_fg .. " guibg=" .. bg)
    end
end
