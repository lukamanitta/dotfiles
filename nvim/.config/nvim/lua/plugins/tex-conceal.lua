local apply_globals = require('utils.config').apply_globals

apply_globals({
    tex_conceal = 'abdgm',
    tex_conceal_frac = 1,
    tex_superscripts = '[0-9a-zA-W.,:;+-<>/()=]',
    tex_subscripts = '[0-9aehijklmnoprstuvx,+-/().]',
})
