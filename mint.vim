" Vim syntax file for Mint (Minimal Interpreter)
" Author: Joshua Kinder <https://github.com/kinderjosh>
" Last Changed: 22 Sep 24

if exists("b:current_syntax")
    finish
endif

let b:current_syntax = "mint"

syntax keyword mintStatement dup drop over out store load swap
syntax keyword mintStorageClass a b c d e f g h i j k
syntax match mintComment ";.*" contains=atTodo
syntax match mintNumber "\<\d\+\(\.\d*\)\=\(e[+-]\=\d\+\)\=\>"
syntax keyword mintTodo TODO FIXME XXX

hi def link mintStatement Keyword
hi def link mintStorageClass StorageClass
hi def link mintComment Comment
hi def link mintNumber Number
hi def link mintTodo Todo
