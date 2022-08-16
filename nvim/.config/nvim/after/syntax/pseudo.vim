" Custom syntax file for algorithmic pseudo code
" Based on pseudo code from COMP3506 UQ Course

" TODO: Add math conceal chars

syntax keyword pseudoMethod function Algorithm
highlight link pseudoMethod Statement

syntax keyword pseudoFunction first isEmpty remove add insert enqueue dequeue visit
highlight link pseudoFunction Function

syntax keyword pseudoConditional if then else match case
highlight link pseudoConditional Conditional

syntax keyword pseudoRepeat while do for repeat until foreach
syntax match pseudoRepeat "for.*\zsto\ze.*"
syntax match pseudoRepeat "for.*\zsdownto\ze"
syntax match pseudoRepeat "foreach\.*\zsof\ze"
syntax match pseudoRepeat "foreach.*\zsin\ze"
highlight link pseudoRepeat Repeat

syntax keyword pseudoStatement return
highlight link pseudoStatement Statement

syntax keyword pseudoKeyword Input Output
highlight link pseudoKeyword Keyword

" syntax keyword pseudoType bool char nat int real set multiset seq string map imap object array array2 array3
" syntax keyword pseudoLogic requires ensures modifies reads decreases invariant
syntax keyword pseudoBoolean true false
highlight link pseudoBoolean Boolean

syntax region pseudoString start=/"/ skip=/\\"/ end=/"/
highlight link pseudoString String


syntax match pseudoComment /\/\/.*/
syntax region pseudoComment start="/\*" end="\*/"
highlight link pseudoComment Comment

syntax region pseudoAlgorithmDoc start="Input\zs" end="Output"
highlight link pseudoAlgorithmDoc Normal

syntax match pseudoNumber /\d\+\>/
highlight link pseudoNumber Number

syntax match pseudoIdentifier /\<\w\+\>/

" Conceal assignment with 2 characters (so comments still line up)
syntax match pseudoAssignmentFirst "<" contained conceal cchar=←
syntax match pseudoOperator "<-" contains=pseudoAssignmentFirst conceal cchar=―
highlight link pseudoOperator Operator

highlight link pseudoModule StorageClass
highlight link pseudoTypeDef Typedef
highlight link pseudoType Type
highlight link pseudoLogic Debug
