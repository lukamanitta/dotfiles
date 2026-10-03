hook global WinSetOption filetype=markdown %{
    set-option buffer autowrap_fmtcmd "fmt -w $kak_autowrap_column"

    
    define-command -hidden -docstring "indent unordered list" \
    md_indent_ul %{
        try %{
            exec -draft Gh <a-k>\s*-\s*$
            exec -draft >
            exec -draft i<backspace><backspace> # Delete extra spaces
        }
    }
    define-command -hidden -docstring "unindent unordered list" \
    md_unindent_ul %{
        try %{
            exec -draft Gh <a-k>\s*-\s*$
            exec -draft <
        }
    }
    
    hook global InsertKey <tab> %{
        md_indent_ul
    }
    hook global InsertKey <s-tab> %{
        md_unindent_ul
    }
}
