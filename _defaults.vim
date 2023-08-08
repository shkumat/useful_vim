"---------------------------------
" see   https://ru.wikibooks.org/wiki/Vim
"  and  http://konishchevdmitry.blogspot.com/2008/07/howto-vim.html

" colorscheme slate
" colorscheme torte
colorscheme habamax
hi Visual ctermbg=LightGray ctermfg=Black guibg=#505050 guifg=NONE

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

function RunScript()
    :call SaveFile(0)
    :!__.bat %
endfunc

function Complile()
    :call SaveFile(0)
    :set makeprg=compile.bat\ %
    :make
    :copen
    let @z=1
endfunc

function OpenFile()
    if has("gui_running")
        :browse confirm e
    else
        :Explore
    endif
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

function Calculate()
    let @a = trim( @* )
    try
        let @a= eval ( @a )
    catch
        let @a = ".."
    endtry
    :echo @a
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

function Exit(mode)
    :delmarks A-Z0-9
    :delmarks!
    if a:mode == 1
        try
            :x
        catch
            :echo ".."
        endtry
    endif
    :q!
endfunc

function SearchFor(mode)
    let @a= ''
    if a:mode == 2
        let @a = @*
    endif
    let @v = input('Search for : ', @a )
    if @a > ''
        call search( @v )
    endif
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

function GotoMessage(mode)
    try
        if a:mode == 1
            :cp
        else
            :cn
        endif
    catch
        :echo '..'
    endtry
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
    let @a= ''
    if a:mode == 2
        let @a = @*
    endif
    let @a = input('Search for : ',@a)
    if @a > ''
        let @a = ':%s/' . @a . '/' . input('Replace with : ', @a ) . '/gc'
        try
            execute @a
        catch
            :echo "....."
        endtry
        if a:mode == 1
            :call feedkeys('i')
        endif
    endif
endfunc

function SplitCurrentLine()
    let @a = input('Delimiter : ')
    let @a = ':.s/' . @a . '/\r/g'
    try
        execute @a
        echo ' - done'
    catch
        :echo " ....."
    endtry
endfunc

function JoinAllLines()
    let @a = input('Delimiter : ')
    if @a > ''
        let @a = ':%s/\n/'. @a .'/g'
    else
        let @a = ':%s/\n//g'
    endif
    try
        execute @a
        echo ' - done'
    catch
        :echo " ....."
    endtry
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

function DeleteTrailingSpaces()
    try
        :%s/\s\+$//g
        let @a='done'
    catch
        let @a='..'
    endtry
    :echo @a
endfunc

function TabsToSpaces()
    let @a = ":%s/\t/    /g"
    try
        execute( @a )
        let @a='done.'
    catch
        let @a='..'
    endtry
    :echo @a
endfunc

function Turn_CSV_into_SQL()
    let @a = input('Delimiter : ','\t')
    if  @a > ' '
        let @a= ":%s/" . @a . "/;/g"
        try
            execute( @a )
        catch
            :echo '..'
        endtry
        :%norm I,('
        :%norm A')
    endif
endfunc

if has("gui_running")
    set guioptions-=r
    "set showtabline=2
    set guifont=Consolas:h11
    set lines=40 columns=120
    call ShowHideMenubar()
endif

"Esc  - exit
    nmap <silent><Esc> :call Exit(1)<Cr>

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
    imap <silent><F3> <Esc><Right>:call SearchNext(1)<Cr>
    vmap <silent><F3> <Esc>:call SearchNext(1)<Cr>

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
    vmap <silent><S-F3> <Esc>:call SearchPrev(1)<Cr>

"F4  - goto next message
    nmap    <silent><F4> :call GotoMessage(0)<Cr>
    imap    <silent><F4> <Esc>:cn<Cr>i

"Alt+F4  - exit without saving
    nmap <silent><M-F4> :call Exit(0)<Cr>
    imap <silent><M-F4> <Esc>:call Exit(0)<Cr>
    vmap <silent><M-F4> <Esc>:call Exit(0)<Cr>

"Ctrl+F4 - Close current buffer
    nmap <silent><C-F4> :bd<Cr>
    imap <silent><C-F4> <Esc>:bd<Cr>
    vmap <silent><C-F4> <Esc>:bd<Cr>

"Shift+F4  - goto prev message
    nmap <silent><S-F4> :call GotoMessage(1)<Cr>
    imap <silent><S-F4> <Esc>:cp<Cr>i

"F5 - reserved

"Alt+F5 - calculate selected expression
    nmap <silent><M-F5> :call Calculate()<Cr>
    imap <silent><M-F5> <Esc>:call Calculate()<Cr>
    vmap <silent><M-F5> "+y:call Calculate()<Cr>

"Ctrl+F5 - run script
    nmap <silent><C-F5> :call RunScript()<Cr>
    imap <silent><C-F5> <Esc>:call RunScript()<Cr>

"Shift+F5 - menu Transformations
    menu Transformations.Del_trail_spaces   :call DeleteTrailingSpaces()<Cr>
    menu Transformations.Add_before_begins  :call Insert(0)<Cr>
    menu Transformations.Add_after_ends     :call Insert(1)<Cr>
    menu Transformations.Split_cur_line     :call SplitCurrentLine()<Cr>
    menu Transformations.Join_all_lines     :call JoinAllLines()<Cr>
    menu Transformations.Tabs_to_spaces     :call TabsToSpaces()<Cr>
    menu Transformations.CSV_into_SQL       :call Turn_CSV_into_SQL()<Cr>
    nmap <silent><S-F5>     :emenu Transformations.<Tab>
    imap <silent><S-F5>     <Esc>:emenu Transformations.<Tab>
    vmap <silent><S-F5>     <Esc>:emenu Transformations.<Tab>

"F6  - goto next view
    nmap <F6>  <C-w>w
    imap <F6>  <Esc><C-w>w

"Alt+F6  - goto next tab
    nmap <silent><M-F6>  :tabnext<Cr>
    imap <silent><M-F6>  <Esc>:tabnext<Cr>
    vmap <silent><M-F6>  <Esc>:tabnext<Cr>

"Ctrl+F6  - split window horizontally
    nmap <silent><C-F6> :call HSplit()<Cr>
    imap <silent><C-F6> <Esc>:call HSplit()<Cr>i

"Shift+F6  - split window vertically
    nmap <silent><S-F6> :call VSplit()<Cr>
    imap <silent><S-F6> <Esc>:call VSplit()<Cr>i

"F7  - go to prev difference / search
    nmap <silent><F7> [c
    imap <silent><F7> <Esc>:call SearchFor(1)<Cr>
    vmap <silent><F7> "+y:call SearchFor(2)<Cr>

"Alt+F7  - Search in files
    nmap <silent><M-F7> :call SearchInFiles()<Cr>
    vmap <silent><M-F7> <Esc>:call SearchInFiles()<Cr>
    imap <silent><M-F7> <Esc>:call SearchInFiles()<Cr>

"Ctrl+F7 - Search and Replace
    nmap <silent><C-F7> :call SearchAndReplace(0)<Cr>
    imap <silent><C-F7> :call SearchAndReplace(1)<Cr>
    vmap <silent><C-F7> "+y:call SearchAndReplace(2)<Cr>

"Shift+F7 - menu Case-Sensitiveness
    menu CaseSensitiveness.IgnoreCase   :set ignorecase<Cr>
    menu CaseSensitiveness.NoIgnorecase :set noignorecase<Cr>
    nmap <silent><S-F7>    :emenu CaseSensitiveness.<Tab>
    imap <silent><S-F7>    <Esc>:emenu CaseSensitiveness.<Tab>

"F8  - go to next difference
    nmap <silent><F8> ]c

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

"Alt+F9  - go to global bookmark N1
    nmap <M-F9> `A
    imap <M-F9> <Esc>`Ai

"Ctrl+F9  - set global bookmark N1
    nmap <C-F9> mA
    imap <C-F9> <Esc>mAi

"Shift+F9  - set local bookmark N1
    nmap <S-F9> ma
    imap <S-F9> <Esc>mai

"F10  - go to local bookmark N2
    nmap <F10> `b
    imap <F10> <Esc>`bi

"Alt+F10  - go to global bookmark N2
    nmap <M-F10> `B
    imap <M-F10> <Esc>`Bi

"Ctrl+F10  - set global bookmark N2
    nmap <C-F10> mB
    imap <C-F10> <Esc>mBi

"Shift+F10  - set local bookmark N2
    nmap <S-F10> mb
    imap <S-F10> <Esc>mbi

"F11  - go to local bookmark N3
    nmap <F11> `c
    imap <F11> <Esc>`ci

"Alt+F11  - go to global bookmark N3
    nmap <M-F11> `C
    imap <M-F11> <Esc>`Ci

"Ctrl+F11  - set global bookmark N3
    nmap <C-F11> mC
    imap <C-F11> <Esc>mCi

"Shift+F11  - set local bookmark N3
    nmap <S-F11> mc
    imap <S-F11> <Esc>mci

"F12  - go to local bookmark N4
    nmap <F12> `d
    imap <F12> <Esc>`di

"Alt+F12  - go to global bookmark N4
    nmap <M-F12> `D
    imap <M-F12> <Esc>`Di

"Ctrl+F12  - set global bookmark N4
    nmap <C-F12> mD
    imap <C-F12> <Esc>mDi

"Shift+F12  - set local bookmark N4
    nmap <S-F12> md
    imap <S-F12> <Esc>mdi

"Tab - shift block right
    imap <silent> <Tab> <Esc>v>i
    vmap <silent> <Tab> >i

"Ctrl+Tab - next buffer
    nmap <silent> <C-Tab> :bn<Cr>
    imap <silent> <C-Tab> <Esc>:bn<Cr>i
    vmap <silent> <C-Tab> <Esc>:bn<Cr>

"Shift+Tab - next buffer / shift block left
    nmap <silent> <S-Tab> :bn<Cr>
    imap <silent> <S-Tab> <Esc>:bn<Cr><Right>i
    vmap <silent> <S-Tab> <i

"BackSpace  - go to edit-mode
    nmap <silent><BS> i<BS>

"Insert  - go to edit-mode
    vmap <silent><Insert> i

"Alt+Insert -  copy file-path to cbd / multi-cursor insert
    nmap <silent><M-Insert> :let @* = expand('%:p')<Cr>
    imap <silent><M-Insert> <Esc>i
    vmap <silent><M-Insert> I

"Ctrl+Insert - copy to clipboard
    nmap <C-Insert> yy
    imap <C-Insert> <Esc>yyi
    vmap <C-Insert> "+yi

"Shift+Insert - paste from clipboard
    nmap <S-Insert> pi<Right>
    vmap <S-Inseer> <Esc>"+gPi
    imap <S-Insert> <Esc>"+gPi
    cmap <S-Insert> <C-r>"

"Delete - go to edit-mode and delete a symbol
    nmap <Del> i<Del>

"Del
    vmap <silent><Del>  "_di

"Alt+Del - delete line
    nmap <silent><M-Del> :let @a=@*<Cr>dd:let @*=@a<Cr>i
    imap <silent><M-Del> <Esc>:let @a=@*<Cr>dd:let @*=@a<Cr>i
    vmap <silent><M-Del> "_di

"Shift+Delete - cut
    nmap <S-Del> ddi
    imap <S-Del> <Esc>ddi
    vmap <S-Del> "+xi

"Alt+End - duplicate line
    nmap <silent><M-End> :t.<Cr>i
    imap <silent><M-End> <Esc>:t.<Cr>i
    vmap <silent><M-End> yPi

"Alt+Up  - go to vertical block mode / move line up
    nmap <M-Up> <C-v><Up>
    imap <M-Up> <Esc>:m -2<Cr>i

"Ctrl+Up  - move to the prev current word / to upper case
    nmap <C-Up> "+yw?<C-r>"<Cr>
    imap <C-Up> <Esc><Right>"+yw?<C-r>"<Cr>i
    vmap <C-Up> Ui

"Alt+Left - home
    nmap <M-Left> <C-v><Left>
    imap <M-Left> <Home>
    vmap <M-Left> <Left>

"Alt+Right - end
    nmap <M-Right> <C-v><Right>
    imap <M-Right> <End>
    vmap <M-Right> <Right>

"Alt+Down  - go to vertical block mode / move line down
    nmap <M-Down> <C-v><Down>
    imap <M-Down> <Esc>:m +1<Cr>i

"Ctrl+Down  - move to the next current word / to lower-case
    nmap <C-Down> "+yw/<C-r>"<Cr>
    imap <C-Down> <Esc><Right>"+yw/<C-r>"<Cr>i
    vmap <C-Down> ui

"Alt+Home  - go to vertical-block-mode
    nmap <M-Home> <C-v>
    imap <M-Home> <Esc><Right><C-v>

"Shift+Home
    nmap <S-Home> v<Home>
    vmap <S-Home> <Home>
    imap <S-Home> <Esc>v<Home>

"Shift+End
    nmap <S-End> v<End>
    vmap <S-End> <End>
    imap <S-End> <Esc>v<End>

"Alt+PgDn  - go to prev view
    nmap <M-PageUp> <C-w>p
    imap <M-PageUp> <Esc><C-w>p

"Ctrl+PgUp  - go to prev buffer
    nmap <silent> <C-PageUp> :bp<Cr>
    imap <silent> <C-PageUp> <Esc>:bp<Cr>i
    vmap <silent> <C-PageUp> <Esc>:bp<Cr>

"Alt+PgDn  - go to next view
    nmap <M-PageDown> <C-w>w
    imap <M-PageDown> <Esc><C-w>w

"Ctrl+PgDn  - go to next buffer
    nmap <silent> <C-PageDown> :bn<Cr>
    imap <silent> <C-PageDown> <Esc>:bn<Cr>i
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
    nmap <C-a> ggVG
    vmap <C-a> <Esc>ggVG
    imap <C-a> <Esc>ggVG

"Ctrl+B menu "FoldMethod"
    menu FoldMethod.Syntax  :set foldmethod=syntax<Cr>
    menu FoldMethod.Manual  :set foldmethod=manual<Cr>
    menu FoldMethod.Indent  :set foldmethod=indent<Cr>
    nmap <silent><C-B> :emenu FoldMethod.<Tab>

"Ctrl+C - copy
    nmap <C-c> yy
    imap <C-c> <Esc>yyi
    vmap <C-c> "+yi

"Ctrl+D  - redo
    nmap <silent><C-d> :redo<Cr>
    imap <silent><C-d> <Esc>:redo<Cr>i

"Ctrl+E  - compile
    nmap <silent><C-E>  :call Complile()<Cr>
    imap <silent><C-E>  <Esc>:call Complile()<Cr>

"Ctrl+F  - search
    nmap <C-f> :call SearchFor(0)<Cr>
    imap <C-f> <Esc>:call SearchFor(1)<Cr>
    vmap <C-f> "+y:call SearchFor(2)<Cr>

"Ctrl+G  - goto line number
    nmap <silent><C-g> :call GoToLine(0)<Cr>
    imap <silent><C-g> <Esc>:call GoToLine(1)<Cr>
    vmap <silent><C-g> <Esc>:call GoToLine(2)<Cr>

"Ctrl+H - Search and Replace
    nmap <silent><C-h> :call SearchAndReplace(0)<Cr>
    imap <silent><C-h> <Esc>:call SearchAndReplace(1)<Cr>
    vmap <silent><C-h> "+y:call SearchAndReplace(2)<Cr>

"Ctrl+J  - left
    nmap <C-j> <Left>
    imap <C-j> <Left>

"Ctrl+K  - down
    nmap <C-k> <Down>
    imap <C-k> <Down>

"Ctrl+L  - right
    nmap <C-l> <Right>
    imap <C-l> <Right>

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
    nmap  <C-u> <Up>
    imap  <C-u> <Up>

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

"Space  - go to command-mode
    nmap <Space> :

"Enter - go to insert mode
    nmap <Enter> i<Enter>
