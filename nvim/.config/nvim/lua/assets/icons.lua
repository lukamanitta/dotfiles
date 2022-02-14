local I = {}

I.general = {
    AngleUp = '',
    AngleDown = '',
    AngleLeft = '',
    AngleRight = '',

    AngleUpThick = '',
    AngleDownThick = '',
    AngleLeftThick = '',
    AngleRightThick = '',

    AngleUpDouble = '',
    AngleDownDouble = '',
    AngleLeftDouble = '',
    AngleRightDouble = '',

    AngleRightDoubleThin = '»',
    CaretUp = '',
    CaretDown = '',
    CaretLeft = '',
    CaretRight = '',

    ArrowRight = '➜',

    ArrowUpThick = '',
    ArrowDownThick = '',
    ArrowLeftThick = '',
    ArrowRightThick = '',

    CircleArrowRight = '',
    CircleArrowLeft = '',

    Circle = '',
    CircleSmall = '●',

    Bar = '▎',
    BarThick = '▊',

    CrossThick = '',
    CrossThin = '',

    PlusThick = '',
    PlusThin = '+',

    CheckThick = '',
    Square = '■',
    Exclamation = '',
    Bug = '',
    Trace = '',
    Heart = '',
}

I.filesystem = {
    File = '',
    FileSymlink = '',
    Folder = '',
    FolderOpen = '',
    FolderEmpty = '',
    FolderEmptyOpen = '',
    FolderSymlink = '',
}

I.companies = {
    Tabnine = '',
    GitHub = '',
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
    Tabnine = I.companies.Tabnine,
    Copilot = I.companies.Github,
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
    Ignored = '',
    Untracked = I.general.CrossThick,
    Added = '',
    Modified = '柳',
    Removed = '',
}

return I
