" Comment \ uncomment for current like \ selection

if exists("g:loaded_commentsPlugin")
    finish
endif

let g:loaded_commentsPlugin = "1"   " 1= plugin is turned ON; 0= plugin is turned OFF

function GetCommentForTheFile()
    let CommentByFileType = { 
\           'vim'   :   '"'
\       ,   'vimrc' :   '"'
\       ,   'py'    :   '#'
\       ,   'ps1'   :   '#'
\       ,   'sql'   :   '--'
\       ,   'bat'   :   'rem '
\       ,   'cmd'   :   'rem '
\       ,   'c'     :   '\/\/'
\       ,   'h'     :   '\/\/'
\       ,   'cs'    :   '\/\/'
\       ,   'js'    :   '\/\/'
\       ,   'sc'    :   '\/\/'
\       ,   'ts'    :   '\/\/'
\       ,   'cpp'   :   '\/\/'
\       ,   'hpp'   :   '\/\/'
\       ,   'pas'   :   '\/\/'
\       ,   'java'  :   '\/\/'
\       ,   'scala' :   '\/\/' 
\   }
    let @a = tolower( expand('%:e') )
    if has_key( CommentByFileType , @a )
        return CommentByFileType[ @a ]
    else
        return ''
    endif
endfunc

function UnComment(mode)
    let @a = GetCommentForTheFile()
    if @a > ''
        let @a = 's/^' . @a . '//'
        if a:mode == 1
            let @a = ":'<,'>" . @a
        endif
        try
            execute( @a )
        catch
        endtry
    endif
endfunc

function Comment(mode)
    let @a = GetCommentForTheFile()
    if @a > ''
        if ( stridx( trim( getline(".") ) , @a ) !=-1 ) || ( @a=='\/\/' && stridx( trim( getline(".") ) , '//' ) !=-1 )
            return
        endif
        let @a = 's!^!' . @a . '!'
        if a:mode == 1
            let @a = ":'<,'>" . @a
        endif
        try
            execute( @a )
        catch
        endtry
    endif
endfunc

if g:loaded_commentsPlugin > "0"

    "Ctrl+F1 - comment line/block
        nmap <silent> <C-F1> :call Comment(0)<Cr>i
        imap <silent> <C-F1> <Esc>:call Comment(0)<Cr>i
        vmap <silent> <C-F1> <Esc>:call Comment(1)<Cr>i

    "Ctrl+F2 - unComment line/block
        nmap <silent> <C-F2>  :call UnComment(0)<Cr>i
        imap <silent> <C-F2>  <Esc>:call UnComment(0)<Cr>i
        vmap <silent> <C-F2>  <Esc>:call UnComment(1)<Cr>i

endif
