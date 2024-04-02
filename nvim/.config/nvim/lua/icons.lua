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
    CrossThin = "",

    PlusThick = "",
    PlusThin = "+",

    DotsHorizontal = "󰇘",

    CheckThick = "",
    CheckCircle = "",
    CheckCircleOutline = "",
    Square = "■",
    Exclamation = "",
    Bug = "",
    Pencil = "󰏫",
    PencilOff = "󰏯",
    Heart = "",
    Search = "",
    -- Replace = "﯒",
    Shell = "",
    Crosshairs = "",
    Percent = "󱨂",

    ListThick = "",
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
    File = "",
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
    Vim = "",
}

I.types = { -- Arranged approximately in order of abstraction (lo - hi)
    Constant = "",
    Text = "",
    Value = "󰎠",
    Float = "󱂡",
    String = "󰀬",
    Boolean = " ",
    Null = I.general.CircleOutline,
    Operator = "󰎂",
    Color = "",

    Object = "",
    Array = "󰅨",
    Struct = "",

    Function = "󰊕",
    Keyword = "󰌋",
    Variable = "󰂡",

    Enum = "",
    EnumMember = "",

    Class = "󰠱",
    Constructor = "",
    Property = "",
    Field = "󰇽",
    Method = "󰆧",
    TypeParameter = "󰅲",
    Tag = "",

    Interface = "",
    Module = "",

    Unit = "",
    Date = "󰃭",
    DateTime = "󰃰",
    Time = "",

    Folder = I.filesystem.FolderOpen .. "",
    File = I.filesystem.File,
    Reference = I.filesystem.FileSymlink,

    Event = "",

    Spell = I.general.Pencil,
    Tabnine = I.companies.Tabnine,
    Copilot = "",
    CopilotWarn = "",
    Omni = "",
    Snippet = "",
    Latex = "󰀫",
    CommitMsg = "",
}

I.lsp = ({
    solid = {
        Error = "",
        Warn = "",
        Hint = "",
        Info = "",
        CodeAction = "󰂚",
    },
    outline = {
        Error = "󰅚",
        Warn = "󰗖",
        Hint = "",
        Info = "",
        CodeAction = "󰂜",
    },
    text = {
        Error = "E",
        Warn = "W",
        Hint = "H",
        Info = "I",
        CodeAction = "A",
    },
})[vim.g.icon_style]

I.git = ({
    solid = {
        Branch = "",
        Merge = "",
        Unstaged = I.general.Exclamation,
        Ignored = "",
        Untracked = I.general.CrossThick,
        Added = "",
        Modified = "󱗜",
        Renamed = "󱥪",
        Removed = "",
    },
    outline = {
        Branch = "",
        Merge = "",
        Unstaged = I.general.Exclamation,
        Ignored = "",
        Untracked = I.general.CrossThick,
        Added = "",
        Modified = "",
        Renamed = "󱥫",
        Removed = "",
    },
    text = {
        Branch = "B",
        Merge = "M",
        Unstaged = "!",
        Ignored = "I",
        Untracked = "U",
        Added = "A",
        Modified = "M",
        Renamed = "R",
        Removed = "D",
    },
})[vim.g.icon_style]

return I
