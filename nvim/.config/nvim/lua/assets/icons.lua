local I = {}

I.general = {
    AngleUp = "",
    AngleDown = "",
    AngleLeft = "",
    AngleRight = "",

    AngleUpThick = "",
    AngleDownThick = "",
    AngleLeftThick = "",
    AngleRightThick = "",

    AngleUpDouble = "",
    AngleDownDouble = "",
    AngleLeftDouble = "",
    AngleRightDouble = "",
    AngleRightDoubleThin = "»",

    CaretUp = "",
    CaretDown = "",
    CaretLeft = "",
    CaretRight = "",

    ArrowRight = "➜",

    ArrowUpThick = "",
    ArrowDownThick = "",
    ArrowLeftThick = "",
    ArrowRightThick = "",

    CircleArrowRight = "",
    CircleArrowLeft = "",

    Circle = "",
    CircleSmall = "●",
    CircleOutline = "",

    Bar = "▎",
    BarThick = "▊",

    CrossThick = "",
    CrossThin = "",

    PlusThick = "",
    PlusThin = "+",

    DotsHorizontal = "",

    CheckThick = "",
    CheckCircle = "﫟",
    CheckCircleOutline = "﫠",
    Square = "■",
    Exclamation = "",
    Bug = "",
    Pencil = "",
    Heart = "",
    Search = "",
    Shell = "",
}

I.debug = {
    Pause = "",
    Play = "",
    StepInto = "",
    StepOver = "",
    StepOut = "",
    StepBack = "",
    RunLast = "↻",
    Terminate = "",
}

I.filesystem = {
    File = "",
    FileSymlink = "",
    Folder = "",
    FolderOpen = "",
    FolderEmpty = "",
    FolderEmptyOpen = "",
    FolderSymlink = "",
}

I.companies = {
    Tabnine = "",
    GitHub = "",
}

I.types = { -- Arranged approximately in order of abstraction (lo - hi)
    Constant = "",
    Text = "",
    Value = "",
    Float = "",
    String = "",
    Boolean = " ",
    Null = I.general.CircleOutline,
    Operator = "",
    Color = "",

    Object = "",
    Array = "",
    Struct = "",

    Function = "",
    Keyword = "",
    Variable = "",

    Enum = "",
    EnumMember = "",

    Class = "ﴯ",
    Constructor = "",
    Property = "",
    Field = "",
    Method = "",
    TypeParameter = "",
    Tag = "",

    Interface = "",
    Module = "",

    Unit = "",
    Date = "",
    DateTime = "",
    Time = "",

    Folder = I.filesystem.FolderOpen .. "",
    File = I.filesystem.File,
    Reference = I.filesystem.FileSymlink,

    Event = "",

    Spell = I.general.Pencil,
    Tabnine = I.companies.Tabnine,
    Copilot = I.companies.Github,
    Omni = "",
    Snippet = "",
    Latex = "",
    CommitMsg = "",
}

I.lsp = {
    Error = "",
    Warn = "",
    Hint = "",
    Info = "",
    CodeAction = "",

    ErrorOutline = "",
    WarnOutline = "",
    HintOutline = "",
    InfoOutline = "",
    CodeActionOutline = "",
}

I.git = {
    Branch = "",
    Merge = "",
    Unstaged = I.general.Exclamation,
    Ignored = "",
    Untracked = I.general.CrossThick,
    Added = "",
    Modified = "柳",
    Removed = "",
}

return I
