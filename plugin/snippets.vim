function Print(str)
    let @a = a:str
    call feedkeys('"')
    call feedkeys('a')
    call feedkeys('p')
endfunc

"F1  - snippets
    nmap <silent><F1> :echo('plugin snippets is not implemented yet')<Cr>

