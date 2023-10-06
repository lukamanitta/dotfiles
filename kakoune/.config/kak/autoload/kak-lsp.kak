# kak-lsp
# source "$HOME"/.config/kak/kak-lsp/kak-lsp.kak
eval %sh{kak-lsp --config $HOME/.config/kak/kak-lsp/kak-lsp.toml --kakoune -s $kak_session}
# set global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"
 
map global user l ":enter-user-mode lsp<ret>" -docstring "LSP mode"

hook global WinSetOption filetype=(rust|python|javascript|typescript|dart|svelte) %{
    lsp-enable-window
    lsp-inlay-hints-enable global
    # hook global BufWritePre .* lsp-formatting-sync
}
#   set icons
set-option global lsp_diagnostic_line_error_sign ""
set-option global lsp_diagnostic_line_warning_sign ""
set-option global lsp_diagnostic_line_hint_sign ""
set-option global lsp_diagnostic_line_info_sign ""
set-option global lsp_code_lens_sign ""
set-option global lsp_inlay_diagnostic_sign ""
