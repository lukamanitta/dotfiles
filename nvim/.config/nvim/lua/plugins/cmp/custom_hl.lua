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

local get_hi_group_bg = require("utils.color.hl_groups").get_hi_group_bg
local get_hi_group_fg = require("utils.color.hl_groups").get_hi_group_fg
-- For each of the above highlight groups, swap the foreground and background
for _, highlight in ipairs(cmp_item_kind_highlights) do
    local fg = get_hi_group_fg(highlight)
    local bg = get_hi_group_bg(highlight)
    vim.cmd("highlight " .. highlight .. " guifg=" .. bg .. " guibg=" .. fg)
end

