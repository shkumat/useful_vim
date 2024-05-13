" Keyboard snippets. It is not implemented yet

if exists("g:loaded_snippetsPlugin")
    finish
endif

let g:loaded_snippetsPlugin = "0"   " 1= plugin is turned ON; 0= plugin is turned OFF


function Print(str)
    let @a = a:str
    call feedkeys('"')
    call feedkeys('a')
    call feedkeys('p')
endfunc
