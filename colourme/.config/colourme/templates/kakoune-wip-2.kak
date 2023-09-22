# Monokai theme for Kakoune

# Color palette
declare-option str bg 'rgb:{{hex:background}}'
declare-option str fg 'rgb:{{hex:foreground}}'

# Don't know if this is required
declare-option str dimmed_background 'rgb:{{hex:bright.black}}'

declare-option str psel 'rgba:{{hex:selection_bg}}80'
declare-option str ssel 'rgba:{{hex:darken(selection_bg, 0.2)}}80'

declare-option str black 'rgb:{{hex:regular.black}}'
declare-option str red 'rgb:{{hex:regular.red}}'
declare-option str green 'rgb:{{hex:regular.green}}'
declare-option str yellow 'rgb:{{hex:regular.yellow}}'
declare-option str blue 'rgb:{{hex:regular.blue}}'
declare-option str magenta 'rgb:{{hex:regular.magenta}}'
declare-option str cyan 'rgb:{{hex:regular.cyan}}'
declare-option str white 'rgb:{{hex:regular.white}}'


declare-option str brblack 'rgb:{{hex:bright.black}}'
declare-option str brred 'rgb:{{hex:bright.red}}'
declare-option str brgreen 'rgb:{{hex:bright.green}}'
declare-option str bryellow 'rgb:{{hex:bright.yellow}}'
declare-option str brblue 'rgb:{{hex:bright.blue}}'
declare-option str brmagenta 'rgb:{{hex:bright.magenta}}'
declare-option str brcyan 'rgb:{{hex:bright.cyan}}'
declare-option str brwhite 'rgb:{{hex:bright.white}}'

# Reference
# https://github.com/mawww/kakoune/blob/master/colors/default.kak
# TODO: kak-lsp semantic token faces
set-face global value "%opt{purple}"
set-face global type "%opt{cyan}"
set-face global variable "%opt{orange}"
set-face global module "%opt{white}"
set-face global function "%opt{green}"
set-face global string "%opt{yellow}"
set-face global keyword "%opt{pink}"
set-face global operator "%opt{pink}"
set-face global attribute "%opt{orange}"
set-face global bracket "%opt{white}+b"
set-face global arguement "%opt{orange}"
set-face global comma "%opt{white}"
set-face global comment "%opt{gray}+i"
set-face global meta "%opt{red}"
set-face global builtin "%opt{cyan}"
set-face global class "%opt{green}+b"
set-face global equal "%opt{pink}"

# For markup
set-face global title "%opt{pink}"
set-face global header "%opt{orange}"
set-face global bold "%opt{pink}"
set-face global italic "%opt{purple}"
set-face global mono "%opt{green}"
set-face global block "%opt{cyan}"
set-face global link "%opt{green}"
set-face global bullet "%opt{green}"
set-face global list "%opt{white}"

# Builtin faces
set-face global Default "%opt{white},%opt{bg}"
# set-face global Default default,default
set-face global PrimarySelection "default,%opt{psel}"
set-face global SecondarySelection "default,%opt{ssel}"
set-face global PrimaryCursor "%opt{black},%opt{purple}"
set-face global SecondaryCursor "%opt{black},%opt{yellow}"
set-face global PrimaryCursorEol "%opt{black},%opt{cyan}"
set-face global SecondaryCursorEol "%opt{black},%opt{orange}"
set-face global LineNumbers "%opt{gray},%opt{bg}"
set-face global LineNumberCursor "%opt{purple},%opt{bg}+b"
set-face global LineNumbersWrapped "%opt{gray},%opt{bg}+i"
set-face global MenuForeground "%opt{black},%opt{white}+b"
set-face global MenuBackground "%opt{white},%opt{black}"
set-face global MenuInfo "%opt{orange},%opt{black}"
set-face global Information "%opt{yellow},%opt{bg}"
set-face global Error "%opt{red},%opt{bg}"
set-face global StatusLine "%opt{white},%opt{bg}"
set-face global StatusLineMode "%opt{green},%opt{bg}"
set-face global StatusLineInfo "%opt{purple},%opt{bg}"
set-face global StatusLineValue "%opt{orange},%opt{bg}"
set-face global StatusCursor "%opt{white},%opt{blue}"
set-face global Prompt "%opt{green},%opt{bg}"
set-face global MatchingChar "%opt{bg},%opt{blue}"
set-face global Whitespace "%opt{dimgray},%opt{bg}+f"
set-face global WrapMarker Whitespace
set-face global BufferPadding "%opt{gray},%opt{bg}"
