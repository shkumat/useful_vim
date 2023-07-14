"--------------------------------------------------------------------------
" see   https://ru.wikibooks.org/wiki/Vim
"  and  http://konishchevdmitry.blogspot.com/2008/07/howto-vim.html

" colorscheme slate
" colorscheme torte
colorscheme habamax

set number
set nowrap
set nopaste
set noruler
set wildmenu
set wcm=<Tab>
set noshowcmd
set noshowmode
set splitbelow
set ignorecase
set wildoptions=pum
set clipboard=unnamed

"set foldmethod=manual
"set foldmethod=indent
set foldmethod=syntax

"set fileformat=dos
set fileformats=dos,unix,mac
set nofoldenable 

"set expandtab ts=4 sw=4 ai
"set autoindent
set smartindent
set softtabstop=4   
set shiftwidth=4
set tabstop=4
set expandtab

let @v=''   "string to search
let @w=0    "is comparasion mode ON 
let @x=11   "font size
let @y=1    "is menu-bar hidden
let @z=0    "is output-bar open

function Exit()
    :delmarks A-Z0-9
    :delmarks!
    :x
endfunc

function OpenFile()
    if has("gui_running")
        :browse confirm e
    else
        :Explore
    endif
endfunc

function Complile()    
    :call SaveFile(0)
    :set makeprg=compile.bat\ %
    :make
    :copen
    let @z=1
endfunc

function HSplit()
    if ( bufnr('%') == 1 ) && ( bufnr('$') > 1 )
        :sp #2
    else
        :sp #1
    endif
endfunc

function VSplit()
    if ( bufnr('%') == 1 ) && ( bufnr('$') > 1 )
        :vsp #2
    else
        :vsp #1
    endif
endfunc

function CompareViews()
    if @w==0
        :windo diffthis
        let @w=1
    else
        :diffoff
        let @w=0
    endif
endfunc

function ChangeFontSize(direction)
    if  a:direction==0
        let @x=11
    else   
        let @x=@x+a:direction
    endif
    let @a = 'set guifont=Consolas:h' . @x 
    execute @a
endfunc

function ShowHidePanel()
    if (@z==1) 
        :cclose
        let @z=0
    else
        :copen
        let @z=1
    endif
endfunc

function SearchFor(mode)
    let @v = input('Search for : ')
    call search( @v )
    if a:mode == 1
        call feedkeys('i')
    endif
endfunc

function SearchPrev(mode)
    if @v > '' 
        call search( @v , 'b' )
    endif
    if a:mode == 1
        call feedkeys('i')
    endif
endfunc

function SearchNext(mode)
    if @v > '' 
        call feedkeys('l')        
        call search( @v )
        call feedkeys('h')        
    endif
    if a:mode == 1
        call feedkeys('i')
    endif
endfunc

function GoToLine(mode)
    let @a = input('Go to : ') 
    if @a > 0
        @aG
    endif
    if a:mode == 1
        :call feedkeys('i')
    endif
    if a:mode == 2
        :call feedkeys('v')
    endif
endfunc

function SearchAndReplace(mode)
    let @a = input('Search for : ')
    let @a = ':%s/' . @a . '/' . input('Replace with : ', @a ) . '/gc'
    try
        execute @a    
    catch
        :echo "....."
    endtry
    if a:mode == 1
        :call feedkeys('i')
    endif
endfunc

function ShowHideMenubar()
    if (@y==1)
        set guioptions -=m
        set guioptions -=T
        let @y=0
    else
        set guioptions +=m
        "set guioptions +=T
        let @y=1
    endif
endfunc

function SearchInFiles()
    let @a = input('Search for : ') 
    let @a = ':vimgrep "' . @a . '" ' . input('In files : ','**/*.*')
    try
        execute @a
    catch
        :echo '.....'
    endtry
    :copen
    let @z=1
endfunc

function Insert(mode)
    let @a = input('String to insert : ')
    if  @a < ' '
        finish
    endif
    if a:mode > 0
         execute(':%norm A' . @a )
    else
         execute(':%norm I' . @a )
    endif
    call feedkeys('i')
endfunc

function SaveFileAs(mode)
    if has("gui_running")
        :browse confirm save
    else
        execute(':w ' . input('Save file as : ') )
    endif
    if a:mode == 1
        :call feedkeys('i')
    endif
    if a:mode == 2
        :call feedkeys('v')
    endif
endfunc

function SaveFile(mode)
    if  bufname('%')[0] < ' '
        :call SaveFileAs(0)
    else
        :w
    endif
    if a:mode == 1
        :call feedkeys('i')
    endif
    if a:mode == 2
        :call feedkeys('v')
    endif
endfunc

function Convert_TSV_to_SQL()
    :%s/\t/','/g
    :%norm I,('
    :%norm A')
endfunc

if has("gui_running")
    set guioptions-=r
    "set showtabline=2
    set guifont=Consolas:h11
    set lines=40 columns=120
    call ShowHideMenubar()
endif

"Esc  - exit
    nmap <silent><Esc> :call Exit()<Cr>

"F1  -  print list of buffers
    nmap <silent><F1> :ls<Cr>
    imap <silent><F1> <Esc>:ls<Cr>

"Alt+F1  - close folder
    nmap <silent><M-F1> zc
    vmap <silent><M-F1> zf
    imap <silent><M-F1> <Esc>zc<Cr>i

"Ctrl+F1  -  comment line/block with plugin "comment.vim"
"  The plugin is here   https://www.vim.org/scripts/script.php?script_id=1528
"  and here are my keys-maps for it:
"   imap <silent> <C-F1>  <Esc>:call CommentLine()<CR><Up>i
"   vmap <silent> <C-F1>  :call RangeCommentLine()<CR>

"Shift+F1  - match brace
    nmap <silent><S-F1> i<Esc>%<Cr>
    imap <silent><S-F1> <Esc>%i

"F2  - save file
    nmap <F2> :call SaveFile(0)<Cr>
    imap <F2> <Esc>:call SaveFile(1)<Cr>
    vmap <F2> <Esc>:call SaveFile(2)<Cr>

"Alt+F2  - open folder
    nmap <silent><M-F2> zo
    vmap <silent><M-F2> <Esc>zo
    imap <silent><M-F2> <Esc>zoi

"Ctrl+F2  -  uncomment line/block with plugin "comment.vim"
"  The plugin is here   https://www.vim.org/scripts/script.php?script_id=1528
"  and here are my keys-maps for it:
"   imap <silent> <C-F2>  <Esc>:call UnCommentLine()<CR>i
"   vmap <silent> <C-F2>  :call RangeUnCommentLine()<CR>

"Shift+F2  - save file as...
    nmap <S-F2> :call SaveFileAs(0)<Cr>
    imap <S-F2> <Esc>:call SaveFileAs(1)<Cr>
    vmap <S-F2> <Esc>:call SaveFileAs(2)<Cr>

"F3  - Search next
    nmap <silent><F3> :call SearchNext(0)<Cr>
    imap <silent><F3> <Esc>:call SearchNext(1)<Cr>
    vmap <silent><F3> <Esc>:call SearchNext(0)<Cr>

"Alt+F3 - Close all buffers
    nmap <silent><M-F3> :%bd<Cr>
    imap <silent><M-F3> <Esc>:%bd<Cr>
    vmap <silent><M-F3> <Esc>:%bd<Cr>

"Ctrl+F3 - Close current tab
    nmap <silent><C-F3> :tabclose<Cr>
    imap <silent><C-F3> <Esc>:tabclose<Cr>
    vmap <silent><C-F3> <Esc>:tabclose<Cr>

"Shift+F3  - Search prev
    nmap <silent><S-F3> :call SearchPrev(0)<Cr>
    imap <silent><S-F3> <Esc>:call SearchPrev(1)<Cr>
    vmap <silent><S-F3> <Esc>:call SearchPrev(0)<Cr>

"F4  - goto next error
    nmap    <silent><F4> :cn<Cr>
    imap    <silent><F4> <Esc>:cn<Cr>i

"Alt+F4  - exit without saving
    nmap <silent><M-F4> :q!<Cr>
    imap <silent><M-F4> <Esc>:q!<Cr>
    vmap <silent><M-F4> <Esc>:q!<Cr>

"Ctrl+F4 - Close current buffer
    nmap <silent><C-F4> :bd<Cr>
    imap <silent><C-F4> <Esc>:bd<Cr>
    vmap <silent><C-F4> <Esc>:bd<Cr>

"Shift+F4  - goto prev error
    nmap <silent><S-F4> :cp<Cr>
    imap <silent><S-F4> <Esc>:cp<Cr>i

"F5 - reserved

"Alt+F5 - menu Insert
    menu InsertInto.Beginnings :call Insert(0)<Cr>
    menu InsertInto.Ends       :call Insert(1)<Cr>
    nmap <silent><M-F5>        :emenu InsertInto.<Tab>
    imap <silent><M-F5>        <Esc>:emenu InsertInto.<Tab>
                                

"Ctrl+F5 - reserved

"Shift+F5 - reserved
                     
"F6  - goto next view
    nmap <F6>  <C-w>w
    imap <F6>  <Esc><C-w>w

"Alt+F6  - split window horizontally
    nmap <silent><C-F6> :call HSplit()<Cr>
    imap <silent><C-F6> <Esc>:call HSplit()<Cr>i

"Ctrl+F6  - goto next tab
    nmap <silent><C-F6>  :tabnext<Cr>
    imap <silent><C-F6>  <Esc>:tabnext<Cr>
    vmap <silent><C-F6>  <Esc>:tabnext<Cr>

"Shift+F6  - split window vertically
    nmap <silent><S-F6> :call VSplit()<Cr>
    imap <silent><S-F6> <Esc>:call VSplit()<Cr>i

"F7  - Search
    nmap <silent><F7> :call SearchFor(0)<Cr>
    vmap <silent><F7> <Esc>:call SearchFor(0)<Cr>

"Alt+F7  - Search in files
    nmap <silent><M-F7> :call SearchInFiles()<Cr>
    vmap <silent><M-F7> <Esc>:call SearchInFiles()<Cr>
    imap <silent><M-F7> <Esc>:call SearchInFiles()<Cr>

"Ctrl+F7 - Search and Replace
    nmap <silent><C-F7> :call SearchAndReplace(0)<Cr>
    imap <silent><C-F7> <Esc>:call SearchAndReplace(1)<Cr>

"Shift+F7 - menu Case-Sensitiveness
    menu CaseSensitiveness.IgnoreCase   :set ignorecase<Cr>
    menu CaseSensitiveness.Noignorecase :set noignorecase<Cr>
    nmap <silent><S-F7>    :emenu CaseSensitiveness.<Tab>
    imap <silent><S-F7>    <Esc>:emenu CaseSensitiveness.<Tab>
    
"F8  - compile
    nmap <silent><F8>  :call Complile()<Cr>
    imap <silent><F8>  <Esc>:call Complile()<Cr>i

"Alt+F8  - compare views
    nmap <silent><M-F8>  :call CompareViews()<Cr>
    imap <silent><M-F8>  <Esc>:call CompareViews()<Cr>

"Ctrl+F8 - menu Convert to
    menu ConvertTo.windows :w ++enc=cp1251 ++ff=dos<Cr>
    menu ConvertTo.utf-8   :w ++enc=utf8   ++ff=dos<Cr>
    menu ConvertTo.cp866   :w ++enc=cp866  ++ff=dos<Cr>
    menu ConvertTo.koi8-r  :w ++enc=koi8-r ++ff=dos<Cr>
    menu ConvertTo.koi8-u  :w ++enc=koi8-u ++ff=dos<Cr>
    nmap <silent><C-F8>    :emenu ConvertTo.<TAB>

"Shift+F8 - menu Encoding
    menu Encoding.windows  :e ++enc=cp1251 ++ff=dos<Cr>
    menu Encoding.utf-8    :e ++enc=utf8   ++ff=dos<Cr>
    menu Encoding.cp866    :e ++enc=cp866  ++ff=dos<Cr>
    menu Encoding.koi8-r   :e ++enc=koi8-r ++ff=dos<Cr>
    menu Encoding.koi8-u   :e ++enc=koi8-u ++ff=dos<Cr>
    nmap <silent><S-F8>    :emenu Encoding.<TAB>

"F9  - go to local bookmark N1
    nmap <F9> `a
    imap <F9> <Esc>`ai

"Alt+F9  - set global bookmark N1
    nmap <M-F9> mA
    imap <M-F9> <Esc>mAi

"Ctrl+F9  - set local bookmark N1
    nmap <C-F9> ma
    imap <C-F9> <Esc>mai

"Shift+F9  - go to global bookmark N1
    nmap <S-F9> `A
    imap <S-F9> <Esc>`Ai

"F10  - go to local bookmark N2
    nmap <F10> `b
    imap <F10> <Esc>`bi

"Alt+F10  - set global bookmark N2
    nmap <M-F10> mB
    imap <M-F10> <Esc>mBi

"Ctrl+F10  - set local bookmark N2
    nmap <C-F10> mb
    imap <C-F10> <Esc>mbi

"Shift+F10  - go to global bookmark N2
    nmap <S-F10> `B
    imap <S-F10> <Esc>`Bi

"F11  - go to local bookmark N3
    nmap <F11> `c
    imap <F11> <Esc>`ci

"Alt+F11  - set global bookmark N3
    nmap <M-F11> mC
    imap <M-F11> <Esc>mCi

"Ctrl+F11  - set local bookmark N3
    nmap <C-F11> mc
    imap <C-F11> <Esc>mci

"Shift+F11  - go to global bookmark N3
    nmap <S-F11> `C
    imap <S-F11> <Esc>`Ci

"F12  - go to local bookmark N4
    nmap <F12> `d
    imap <F12> <Esc>`di

"Alt+F12  - set global bookmark N4
    nmap <M-F12> mD
    imap <M-F12> <Esc>mDi

"Ctrl+F12  - set local bookmark N4
    nmap <C-F12> md
    imap <C-F12> <Esc>mdi

"Shift+F12  - go to global bookmark N4
    nmap <S-F12> `D
    imap <S-F12> <Esc>`Di

"Ctrl+Tab - next buffer 
    nmap <silent> <C-Tab> :bn<Cr><Left> 
    imap <silent> <C-Tab> <Esc>:bn<Cr> 
    vmap <silent> <C-Tab> <Esc>:bn<Cr> 

"Shift+Tab - next buffer 
    nmap <silent> <S-Tab> :bn<Cr><Left> 
    imap <silent> <S-Tab> <Esc>:bn<Cr> 
    vmap <silent> <S-Tab> <Esc>:bn<Cr> 

"BackSpace  - go to visual-mode / visual-block-mode
    nmap <silent><BS> v
    vmap <silent><BS> <Esc><C-v>

"Space  - go to command-mode
    nmap <Space> :

"Insert  - go to edit-mode 
    vmap <silent><Insert> I

"Alt+Insert - copy current filename to clipboard / multi-cursor insert
    nmap <silent><M-Insert> :let @* = expand('%:p')<Cr>
    imap <silent><M-Insert> <Esc>i

"Ctrl+Insert - copy to clipboard
    vmap <C-Insert> "+yi
    nmap <C-Insert> yy
    imap <C-Insert> <Esc>yyi

"Shift+Insert - paste from clipboard
    nmap <S-Insert> pi<Right>
    vmap <S-Inseer> <Esc>"+gPi
    imap <S-Insert> <Esc>"+gPi
    cmap <S-Insert> <C-r>"

"Delete - go to edit-mode and delete a symbol
    nmap <Del> i<Del>

"Shift+Delete - cut
    vmap <S-Del> "+xi

"Alt+Del - delete line 
    imap <silent><M-Del> <Esc>ddi

"Alt+End - duplicate line 
"    nmap <silent><M-End> :t.<Cr>i
    imap <silent><M-End> <Esc>:t.<Cr>i

"Alt+Up  - go to prev diff / move line up
    nmap <M-Up> [c
    imap <M-Up> <Esc>:m -2<Cr>i

"Ctrl+Up  - move to the prev current word / to upper case
    nmap <C-Up> "+yw?<C-r>"<Cr>
    imap <C-Up> <Esc><Right>"+yw?<C-r>"<Cr>i
    vmap <C-Up> Ui

"Alt+Left - home
    nmap <M-Left> <Home>
    imap <M-Left> <Home>
    vmap <M-Left> <Home>

"Alt+Right - end
    nmap <M-Right> <End>
    imap <M-Right> <End>
    vmap <M-Right> <End>

"Alt+Down  - go to next diff / move line down
    nmap <M-Down> ]c
    imap <M-Down> <Esc>:m +1<Cr>i

"Ctrl+Down  - move to the next current word / to lower-case
    nmap <C-Down> "+yw/<C-r>"<Cr>
    imap <C-Down> <Esc><Right>"+yw/<C-r>"<Cr>i
    vmap <C-Down> ui

"Alt+Home  - go to visual-block-mode
    nmap <M-Home> <C-v>
    imap <M-Home> <Esc><Right><C-v>

"Shift+Home
    nmap <S-Home> v<Home>
    vmap <S-Home> <Home>
    imap <S-Home> <Esc>v<Home>    

"Shift+End
    vmap <S-End> <End>
    nmap <S-End> v<End>
    imap <S-End> <Esc>v<End>    

"Alt+PgDn  - go to prev view
    nmap <M-PageUp> <C-w>p
    imap <M-PageUp> <Esc><C-w>p

"Ctrl+PgUp  - go to prev buffer
    nmap <silent> <C-PageUp> :bp<Cr><Left> 
    imap <silent> <C-PageUp> <Esc>:bp<Cr> 
    vmap <silent> <C-PageUp> <Esc>:bp<Cr> 

"Alt+PgDn  - go to next view
    nmap <M-PageDown> <C-w>w
    imap <M-PageDown> <Esc><C-w>w

"Ctrl+PgDn  - go to next buffer
    nmap <silent> <C-PageDown> :bn<Cr><Left> 
    imap <silent> <C-PageDown> <Esc>:bn<Cr> 
    vmap <silent> <C-PageDown> <Esc>:bn<Cr> 

" Shift+arrow keys   -  selection
    vmap <S-Up> <Up>
    nmap <S-Up> v<Up>
    imap <S-Up> <Esc>v<Up>
    vmap <S-Down> <Down>
    nmap <S-Down> v<Down>
    imap <S-Down> <Esc>v<Down>
    vmap <S-Left> <Left>
    nmap <S-Left> v<Left>
    imap <S-Left> <Esc>v<Left>
    vmap <S-Right> <Right>
    nmap <S-Right> v<Right>
    imap <S-Right> <Esc>v<Right>
    nmap <S-PageUp> v<PageUp>
    imap <S-PageUp> <PageUp>
    nmap <S-PageDown> v<PageDown>
    imap <S-PageDown> <PageDown>

"Ctrl+`  - show/hide menu-bar
    nmap <silent><C-`>  :call ShowHideMenubar()<Cr>
    imap <silent><C-`>  <Esc>:call ShowHideMenubar()<Cr>i
    vmap <silent><C-`>  <Esc>:call ShowHideMenubar()<Cr>v

"Ctrl+0     set font size in to default
    nmap    <silent><C-0>   :call ChangeFontSize(0)<Cr>
    imap    <silent><C-0>   <Esc>:call ChangeFontSize(0)<Cr>i

"Ctrl+-     decrease font size
    nmap    <silent><C-->   :call ChnangeFontSize(-1)<Cr>
    imap    <silent><C-->   <Esc>:call ChnangeFontSize(-1)<Cr>i

"Ctrl+=     increase font size
    nmap    <silent><C-=>   :call ChnangeFontSize(1)<Cr>
    imap    <silent><C-=>   <Esc>:call ChnangeFontSize(1)<Cr>i

" Ctrl+\  - set scrollbind - synchronous scrolling of views
    nmap    <silent><C-\> :set scrollbind<Cr>
    imap    <silent><C-\> <Esc>:set scrollbind<Cr>
    vmap    <silent><C-\> <Esc>:set scrollbind<Cr>

"Ctrl+]  - open all folders
    nmap <silent><C-]> zR
    imap <silent><C-]> <Esc>zRi

",  - delete local bookmarks
    nmap , :delmarks!<Cr>

";  - delete global bookmarks
    nmap ; :delmarks A-Z0-9<Cr>

"Ctrl+A  - select all
    vmap <C-a> ggVG
    nmap <C-a> v<Cr>ggVG
    imap <C-a> <Esc>v<Cr>ggVG

"Ctrl+B menu "FoldMethod"
    menu FoldMethod.Syntax  :set foldmethod=syntax<Cr>
    menu FoldMethod.Manual  :set foldmethod=manual<Cr>
    menu FoldMethod.Indent  :set foldmethod=indent<Cr>
    nmap <silent><C-B> :emenu FoldMethod.<Tab>

"Ctrl+C - copy
    vmap <C-c> "+yi
    nmap <C-c> yy
    imap <C-c> <Esc>yyi

"Ctrl+D  - redo
    nmap <silent><C-d> :redo<Cr>
    imap <silent><C-d> <Esc>:redo<Cr>i

"Ctrl+E  - compile
    nmap <silent><C-E>  :call Complile()<Cr>
    imap <silent><C-E>  <Esc>:call Complile()<Cr>

"Ctrl+F  - search
    nmap <C-f> :call SearchFor(0)<Cr>
    imap <C-f> <Esc>:call SearchFor(1)<Cr>

"Ctrl+G  - goto line number
    nmap <silent><C-g> :call GoToLine(0)<Cr>
    imap <silent><C-g> <Esc>:call GoToLine(1)<Cr>
    vmap <silent><C-g> <Esc>:call GoToLine(2)<Cr>

"Ctrl+H - Search and Replace
    nmap <silent><C-h> :call SearchAndReplace(0)<Cr>
    imap <silent><C-h> <Esc>:call SearchAndReplace(1)<Cr>

"Ctrl+J  - left
    map <C-j> <Left>

"Ctrl+K  - down
    map <C-k> <Down>

"Ctrl+L  - right
    map <C-l> <Right>

"Ctrl+;  delete current symbol
    imap <Silent><C-;> <Esc>:ls<Cr>

"Ctrl+N - New file
    nmap <silent><C-N> :tabnew<CR>
    imap <silent><C-N> <Esc>:tabnew<Cr>
    vmap <silent><C-N> <Esc>:tabnew<Cr>

"Ctrl+O  - Open file
    nmap <silent><C-O>  :call OpenFile()<Cr>
    imap <silent><C-O>  <Esc>:call OpenFile()<Cr>
    vmap <silent><C-O>  <Esc>:call OpenFile()<Cr>

"Ctrl+P  - close all folders
    nmap <silent><C-P> zM
    imap <silent><C-P> <Esc>zM

"Ctrl+Q  - Copy file to history
    nmap <silent><C-Q>  :call SaveFile(0)<Cr> :!CopyToHistory.bat %<Cr>
    imap <silent><C-Q>  <Esc>:call SaveFile(0)<Cr> :!CopyToHistory.bat %<Cr>i

"Ctrl+R  - show/hide bottem panel
    nmap <silent><C-R>  :call ShowHidePanel()<Cr>
    imap <silent><C-R>  <Esc>:call ShowHidePanel()<Cr>i

"Ctrl+S - Save file
    nmap <C-S> :call SaveFile(0)<Cr>
    imap <C-S> <Esc>:call SaveFile(1)<Cr>
    vmap <C-S> <Esc>:call SaveFile(2)<Cr>

"Ctrl+T - New file
    nmap <silent><C-T> :enew<CR>
    imap <silent><C-T> <Esc>:enew<Cr>
    vmap <silent><C-T> <Esc>:enew<Cr>

"Ctrl+U  - up
    map  <C-u> <Up>

"Ctrl+V  paste
    "nmap <C-v> pi<Right>
    imap <C-v> <Esc>"+gPi
    vmap <C-v> <Esc>"+gPi
    cmap <C-v> <C-r>"

"Ctrl+X  - cut 
    vmap <C-x> "+xi

"Ctrl+Y  - delete current line
    imap <C-Y> <Esc>dd<Cr><Up>i

"Ctrl+Z  - undo 
    nmap <silent><C-z> u
    imap <silent><C-z> <Esc>ui

"\t  - convert TSV to SQL
    nmap \t :call Convert_TSV_to_SQL()<Cr>i
