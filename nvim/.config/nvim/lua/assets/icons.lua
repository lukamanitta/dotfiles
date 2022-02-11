local I = {}

I.general = {
    CaretRight = '',
    CaretRightThinDouble = '»',
    PlayArrowRight = '',
    ArrowRight = '➜',
    Circle = '',
    CircleSmall = '●',
    Bar = '▎',
    BarThick = '▊',
    Square = '■',
    Check = '',
    Cross = '',
    CrossThin = '',
    Plus = '',
    PlusThin = '+',
    Exclamation = '',
    Bug = '',
    Trace = '',
    CircleArrowRight = '',
    CircleArrowLeft = '',
}

I.filesystem = {
    File = '',
    FileSymlink = '',
    Folder = '',
    FolderOpen = '',
    FolderEmpty = '',
    FolderEmptyOpen = '',
    FolderSymlink = '',
}

I.comp_types = {
    Color = '',
    Constant = '',
    EnumMember = '',
    Field = '',
    Folder = I.filesystem.FolderOpen .. '',
    Function = '',
    Keyword = '',
    Method = '',
    Module = '',
    Property = '',
    Struct = '',
    Text = '',
    Value = '',
    Variable = '',
    Constructor = '',
    Class = 'ﴯ',
    Interface = '',
    Unit = '',
    Enum = '',
    Snippet = '',
    File = I.filesystem.File,
    Reference = I.filesystem.FileSymlink,
    Event = '',
    Operator = '',
    TypeParameter = '',
    Tag = '',
    Tabnine = '',
}

I.lsp = {
    Error = '',
    Warn = '',
    Hint = '',
    Info = '',
    CodeAction = '',

    ErrorEmpty = '',
    WarnEmpty = '',
    HintEmpty = '',
    InfoEmpty = '',
    CodeActionEmpty = '',
}

I.git = {
    Branch = '',
    Merge = '',
    Unstaged = I.general.Exclamation,
    Ignored = I.lsp.ErrorEmpty,
    Untracked = I.general.Cross,
    Added = '',
    Modified = '柳',
    Removed = '',
}

return I
