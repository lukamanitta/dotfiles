" Custom syntax file for algorithmic pseudo code
" Based on pseudo code from COMP3506 UQ Course

" TODO: Add math conceal chars

syntax keyword pseudoMethod function Algorithm
syntax keyword pseudoFunction first isEmpty remove add
syntax keyword pseudoConditional if then else match case
syntax keyword pseudoRepeat while do for repeat until
syntax keyword pseudoStatement return
syntax keyword pseudoKeyword Input Output
" syntax keyword pseudoType bool char nat int real set multiset seq string map imap object array array2 array3
" syntax keyword pseudoLogic requires ensures modifies reads decreases invariant
syntax keyword pseudoBoolean true false

syntax region pseudoString start=/"/ skip=/\\"/ end=/"/

syntax match pseudoComment /\/\/.*/
syntax region pseudoComment start="/\*" end="\*/"

syntax match pseudoNumber /\d\+\>/
syntax match pseudoIdentifier /\<\w\+\>/

" Conceal assignment with 2 characters (so comments still line up)
syntax match pseudoAssignmentFirst "<" contained conceal cchar=←
syntax match pseudoOperator "<-" contains=pseudoAssignmentFirst conceal cchar=―

" syntax match pseudoOperator "<=" conceal cchar=
" syntax match pseudoOperator ">=" conceal cchar=

highlight link pseudoFunction Function
highlight link pseudoMethod Statement
highlight link pseudoModule StorageClass
highlight link pseudoTypeDef Typedef
highlight link pseudoConditional Conditional
highlight link pseudoRepeat Repeat
highlight link pseudoKeyword Keyword
highlight link pseudoType Type
highlight link pseudoLogic Debug
highlight link pseudoComment Comment
highlight link pseudoString String
highlight link pseudoNumber Number
highlight link pseudoOperator Operator
highlight link pseudoStatement Statement
highlight link pseudoBoolean Boolean
