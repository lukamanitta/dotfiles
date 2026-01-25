function fish_user_key_bindings
    fish_vi_key_bindings

    bind -M insert -m default jk repaint

    bind -M insert \cf accept-autosuggestion
    bind \cf accept-autosuggestion

    bind -M insert ! bind_bang
    bind -M insert '$' bind_dollar
end
