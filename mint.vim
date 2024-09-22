" Vim syntax file for AT (Abstract Template)
" Author: Joshua Kinder <https://github.com/kinderjosh>
" Last Changed: 20 Sep 24

if exists("b:current_syntax")
    finish
endif

let b:current_syntax = "mint"

syntax keyword atStatement dup drop over out store load swap
syntax keyword atStorageClass a b c d e f g h i j k
syntax match atComment ";.*" contains=atTodo
syntax match atNumber "\<\d\+\(\.\d*\)\=\(e[+-]\=\d\+\)\=\>"
syntax keyword atTodo TODO FIXME XXX

hi def link atStatement Keyword
hi def link atStorageClass StorageClass
hi def link atComment Comment
hi def link atNumber Number
hi def link atTodo Todo
