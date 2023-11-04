" ------------------------------------
" https://vimhelp.org/builtin.txt.html
" colorscheme slate
" colorscheme torte
colorscheme habamax
hi Visual ctermbg=darkgrey ctermfg=NONE guibg=#555555 guifg=NONE
language en_US
language time en_US
language ctype en_US
language messages en_US

set langmenu=en_US
set number
set nowrap
set nopaste
set noruler
set wildmenu
set hlsearch
set wcm=<Tab>
set noshowcmd
set noshowmode
set splitbelow
set ignorecase
set wildoptions=pum
set clipboard=unnamed
"set virtualedit=onemore
"set foldmethod=manual
"set foldmethod=indent
set foldmethod=syntax
set fileformats=dos,unix,mac
set nofoldenable
"set expandtab ts=4 sw=4 ai
"set autoindent
set smartindent
set softtabstop=4
set shiftwidth=4
set tabstop=4
set expandtab

let @s = ''     "line of the block to select
let @u = 1      "search from the beginning of the file
let @v = ''     "string to search
let @w = 0      "is comparasion mode ON
let @x = 11     "font size
let @y = 1      "is menu-bar hidden
let @z = 0      "is output-bar open

function ClearOutput()
    echon "\r\r"
    echon ''
endfunc

function RunScript()
    :call SaveFile(0)
    :!__.bat %
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

function Complile()
    call SaveFile(0)
    set makeprg=compile.bat\ %
    :make
    :copen
    let @z=1
endfunc

function Calculate()
    let @a = trim( @* )
    try
        let @a= eval ( @a )
    catch
        echo '...'
    endtry
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
    if @z == 1
        :cclose
        let @z=0
    else
        :copen
        let @z=1
    endif
endfunc

function ShowHideMenubar()
    if @y == 1
        set guioptions -=m
        set guioptions -=T
        let @y=0
    else
        set guioptions +=m
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
        endtry
    endif
    :q!
endfunc

function SearchPrev(mode)
    if @v > ''
        call search( @v, 'b' )
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

function SearchFor(mode)
    let @a= @v
    if a:mode == 2
        let @a = trim( @* )
    endif
    let @v = input('Search for : ', @a)
    if @v > ''
        if @u == 1
            :1
        endif
        call search( @v, 'c' )
    endif
    call ClearOutput()
    if a:mode == 1
        call feedkeys('i')
    endif
endfunc

function SearchInFiles(mode)
    let @a = @v
    if a:mode == 2
        let @a = trim( @* )
    endif
    let @v = input('Search for : ', @a)
    if @v > ''
        let @a = ':vimgrep "' . @v . '" ' . input('In files : ', '**/*.*')
        try
            execute @a
        catch
        endtry
        :copen
        let @z=1
    endif
    call ClearOutput()
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
    endtry
endfunc

function GoToLine(mode)
    let @a = input('Go to : ')
    if @a > 0
        @aG
    endif
    call ClearOutput()
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
    let @a = input('Search for : ', @a )
    if @a > ''
        let @b = input('Replace with : ', @a )
        if @b > ''
            try
                if @u == 1
                    execute ':%s/' . @a . '/' . @b . '/gc'
                else
                    execute ':,$s/' . @a . '/' . @b . '/gc'
                endif
            catch
            endtry
        endif
    endif
    call ClearOutput()
    if a:mode == 1
        call feedkeys('i')
    endif
endfunc

function SplitCurrentLine()
    let @a = input('Delimiter : ')
    let @a = ':.s/' . @a . '/\r/g'
    try
        execute @a
    catch
    endtry
    call ClearOutput()
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
    catch
    endtry
    call ClearOutput()
endfunc

function Insert(mode)
    let @a = trim( @* )
    let @a = input('String to insert : ' , @a)
    if  @a > ''
        if a:mode > 0
            execute(':%norm A' . @a)
        else
            execute(':%s!^!' . @a . '!')
        endif
    endif
    call ClearOutput()
    call feedkeys('i')
endfunc

function SaveSelection()
    let @a = input('Save selection as : ')
    if @a > ''
        let @a = ":'<,'>w! " . @a
        try
            execute( @a )
        catch
        endtry
    endif
    call feedkeys('g')
    call feedkeys('v')
endfunc

function SaveFileAs(mode)
    if has("gui_running")
        :browse confirm save
    else
        execute(':w ' . input('Save file as : ') )
        call ClearOutput()
    endif
    if a:mode == 1
        if getcurpos()[2]>1
            call feedkeys('l')
        endif
        call feedkeys('i')
    endif
endfunc

function SaveFile(mode)
    if  bufname('%')[0] < ' '
        call SaveFileAs(0)
    else
        :w
    endif
    if a:mode == 1
        call feedkeys('i')
    endif
    if a:mode == 2
        call feedkeys('g')
        call feedkeys('v')
    endif
endfunc

function DeleteTrailingSpaces()
    try
        :%s/\s\+$//g
    catch
    endtry
    call ClearOutput()
endfunc

function TabsToSpaces()
    let @a = ":%s/\t/    /g"
    try
        execute( @a )
    catch
    endtry
    call ClearOutput()
endfunc

function Turn_CSV_into_SQL()
    let @a = input('Delimiter : ','\t')
    if  @a > ' '
        let @a= ":%s/" . @a . "/','/g"
        try
            execute( @a )
        catch
        endtry
        :%norm I,('
        :%norm A')
    endif
    call ClearOutput()
endfunc

function SelectBlock(mode)
    if @s > ''
        try
            call feedkeys('V')
            let num = 0
            while num < strchars( @s )
                call feedkeys( @s[ num ] )
                let  num += 1
            endwhile
            call feedkeys('g')
            call feedkeys('g')
        catch
        endtry
        let @s=''
    else
        let @s=getcurpos()[1]
        if a:mode == 1
            call feedkeys('i')
        endif
    endif
endfunc

function GetCommentForTheFile()
    let CommentByFileType = { 'vim':'"','vimrc':'"','sql':'--','bat':'rem ','cmd':'rem ','py':'#','ps1':'#','c':'\/\/','h':'\/\/','cs':'\/\/','js':'\/\/','sc':'\/\/','ts':'\/\/','cpp':'\/\/','hpp':'\/\/','pas':'\/\/','java':'\/\/','scala':'\/\/' }
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

if has("gui_running")
    set guioptions-=r
    set guifont=Consolas:h11
    set lines=40 columns=120
    call ShowHideMenubar()
endif

"Esc - exit
    nmap <silent><Esc> :call Exit(1)<Cr>
    imap <silent><Esc> <Esc>`^

"Alt+F1 - close folder
    nmap <silent><M-F1> zc
    vmap <silent><M-F1> zf
    imap <silent><M-F1> <Esc>zc<Cr>i

"Ctrl+F1 - comment line/block
    nmap <silent> <C-F1> :call Comment(0)<Cr>i
    imap <silent> <C-F1> <Esc>:call Comment(0)<Cr>i
    vmap <silent> <C-F1> <Esc>:call Comment(1)<Cr>i

"Shift+F1 - match brace
    nmap <silent><S-F1> %
    imap <silent><S-F1> <Esc>%i
    vmap <silent><S-F1> <Esc>%

"F2 - save file
    nmap <F2> :call SaveFile(0)<Cr>
    imap <F2> <Esc>:call SaveFile(1)<Cr>
    vmap <F2> <Esc>:call SaveFile(2)<Cr>

"Alt+F2 - open folder
    nmap <silent><M-F2> zo
    vmap <silent><M-F2> <Esc>zo
    imap <silent><M-F2> <Esc>zoi

"Ctrl+F2 - unComment line/block
    nmap <silent> <C-F2>  :call UnComment(0)<Cr>i
    imap <silent> <C-F2>  <Esc>:call UnComment(0)<Cr>i
    vmap <silent> <C-F2>  <Esc>:call UnComment(1)<Cr>i

"Shift+F2 - save file as...
    nmap <S-F2> :call SaveFileAs(0)<Cr>
    imap <S-F2> <Esc>:call SaveFileAs(1)<Cr>
    vmap <S-F2> <Esc>:call SaveSelection()<Cr>

"F3 - search next / cut selected block
    nmap <silent><F3> :call SearchNext(0)<Cr>
    imap <silent><F3> <Esc><Right>:call SearchNext(1)<Cr>
    vmap <F3> "+xi

"Alt+F3 - Menu 'Service'
    menu Service.Print_All_Buffers   :ls<Cr>
    menu Service.Clear_Search_HiLit  :let @/=''<Cr>:echo ""<Cr>
    menu Service.Clear_Local_BMs     :delmarks!<Cr>:echo ""<Cr>
    menu Service.Clear_Global_BMs    :delmarks A-Z0-9<Cr>:echo ""<Cr>
    menu Service.Close_All           :%bd<Cr>:echo ''<Cr>
    nmap <silent><M-F3>  :emenu Service.<TAB>
    imap <silent><M-F3>  <Esc>:emenu Service.<TAB>
    vmap <silent><M-F3>  <Esc>:emenu Service.<TAB>

"Ctrl+F3 - close current tab
    nmap <silent><C-F3> :tabclose<Cr>
    imap <silent><C-F3> <Esc>:tabclose<Cr>
    vmap <silent><C-F3> <Esc>:tabclose<Cr>

"Shift+F3 - search prev
    nmap <silent><S-F3> :call SearchPrev(0)<Cr>
    imap <silent><S-F3> <Esc>:call SearchPrev(1)<Cr>
    vmap <silent><S-F3> <Esc>:call SearchPrev(1)<Cr>

"F4 - goto next message / copy selected block
    nmap <silent><F4> :call GotoMessage(0)<Cr>
    imap <silent><F4> <Esc>GotoMessage(0)<Cr>i
    vmap <F4> "+yi

"Alt+F4 - exit without saving
    nmap <silent><M-F4> :call Exit(0)<Cr>
    imap <silent><M-F4> <Esc>:call Exit(0)<Cr>
    vmap <silent><M-F4> <Esc>:call Exit(0)<Cr>

"Ctrl+F4 - close current buffer
    nmap <silent><C-F4> :bd<Cr>
    imap <silent><C-F4> <Esc>:bd<Cr>
    vmap <silent><C-F4> <Esc>:bd<Cr>

"Shift+F4 - goto prev message
    nmap <silent><S-F4> :call GotoMessage(1)<Cr>
    imap <silent><S-F4> <Esc>GotoMessage(1)<Cr>i
    vmap <silent><S-F4> <Esc>GotoMessage(1)<Cr>

"F5 - paste
    nmap <F5> pi
    imap <F5> <Esc>"+gPi
    vmap <F5> <Del><C-v>
    cmap <F5> <C-r>"

"Alt+F5 - Menu 'Features'
    menu Features.Histosy       :bro ol<Cr>
    menu Features.Text_to_HEX   :%!xxd<Cr>:echo ''<Cr>
    menu Features.HEX_to_Text   :%!xxd -r<Cr>:echo ''<Cr>
    menu Features.Copy_FilePath :let @* = expand('%:p')<Cr>:echo ''<Cr>
    menu Features.To_Utf8       :w ++enc=utf8   ++ff=dos<Cr>:q<Cr>
    menu Features.To_Win1251    :w ++enc=cp1251 ++ff=dos<Cr>:q<Cr>
    menu Features.To_Cp866      :w ++enc=cp866  ++ff=dos<Cr>:q<Cr>
    menu Features.To_Koi8-r     :w ++enc=koi8-r ++ff=dos<Cr>:q<Cr>
    menu Features.To_Koi8-u     :w ++enc=koi8-u ++ff=dos<Cr>:q<Cr>
    nmap <silent><M-F5>  :emenu Features.<TAB>
    imap <silent><M-F5>  <Esc>:emenu Features.<TAB>
    vmap <silent><M-F5>  <Esc>:emenu Features.<TAB>

"Ctrl+F5 - run script
    nmap <silent><C-F5> :call RunScript()<Cr>
    imap <silent><C-F5> <Esc>:call RunScript()<Cr>
    vmap <silent><C-F5> <Esc>:call RunScript()<Cr>

"Shift+F5 - Menu 'Transformations'
    menu Transformations.Del_trail_spaces   :call DeleteTrailingSpaces()<Cr>
    menu Transformations.Add_before_begins  :call Insert(0)<Cr>
    menu Transformations.Add_after_ends     :call Insert(1)<Cr>
    menu Transformations.Tabs_to_spaces     :call TabsToSpaces()<Cr>
    menu Transformations.Join_all_lines     :call JoinAllLines()<Cr>
    menu Transformations.Split_cur_line     :call SplitCurrentLine()<Cr>
    menu Transformations.CSV_into_SQL       :call Turn_CSV_into_SQL()<Cr>
    nmap <silent><S-F5>  :emenu Transformations.<Tab>
    imap <silent><S-F5>  <Esc>:emenu Transformations.<Tab>
    vmap <silent><S-F5>  <Esc>:emenu Transformations.<Tab>

"F6 - goto next view / calculate selected expression
    nmap <F6> <C-w>w
    imap <F6> <Esc><C-w>w
    vmap <silent><F6> "+y:call Calculate()<Cr>

"Alt+F6 - goto next tab
    nmap <silent><M-F6>  :tabnext<Cr>
    imap <silent><M-F6>  <Esc>:tabnext<Cr>
    vmap <silent><M-F6>  <Esc>:tabnext<Cr>

"Ctrl+F6 - split window horizontally
    nmap <silent><C-F6> :call HSplit()<Cr>
    imap <silent><C-F6> <Esc>:call HSplit()<Cr>i
    vmap <silent><C-F6> <Esc>:call HSplit()<Cr>

"Shift+F6 - split window vertically
    nmap <silent><S-F6> :call VSplit()<Cr>
    imap <silent><S-F6> <Esc>:call VSplit()<Cr>i
    vmap <silent><S-F6> <Esc>:call VSplit()<Cr>

"F7 - search / search selection
    nmap <F7> :call SearchFor(0)<Cr>
    imap <F7> <Esc>:call SearchFor(1)<Cr>
    vmap <F7> "+y:call SearchFor(2)<Cr>

"Alt+F7 - search in files
    nmap <silent><M-F7> :call SearchInFiles(0)<Cr>
    vmap <silent><M-F7> <Esc>:call SearchInFiles(1)<Cr>
    imap <silent><M-F7> "+y:call SearchInFiles(2)<Cr>

"Ctrl+F7 - search and Replace
    nmap <silent><C-F7> :call SearchAndReplace(0)<Cr>
    imap <silent><C-F7> :call SearchAndReplace(1)<Cr>
    vmap <silent><C-F7> "+y:call SearchAndReplace(2)<Cr>

"Shift+F7 - Menu 'Settings'
    menu Settings.Search_From_1   :let @u=1<Cr>:echo ''<Cr>
    menu Settings.Search_Further  :let @u=0<Cr>:echo ''<Cr>
    menu Settings.Ignore_Case     :set ignorecase<Cr>:echo ''<Cr>
    menu Settings.No_Ignore_Case  :set noignorecase<Cr>:echo ''<Cr>
    menu Settings.Fold_Syntax     :set foldmethod=syntax<Cr>:echo ''<Cr>
    menu Settings.Fold_Manual     :set foldmethod=manual<Cr>:echo ''<Cr>
    menu Settings.Fold_Indent     :set foldmethod=indent<Cr>:echo ''<Cr>
    nmap <silent><S-F7>  :emenu Settings.<Tab>
    imap <silent><S-F7>  <Esc>:emenu Settings.<Tab>
    vmap <silent><S-F7>  <Esc>:emenu Settings.<Tab>

"F8 - go to next difference / multi-cursor insert / search-highLighting
    nmap <silent><F8> ]c
    imap <silent><F8> <Esc>i
    vmap <silent><F8> "+y:let @v=substitute( trim( @* ) , '\/' , '\\\/' , 'g')<Cr>:execute "/" . @v<Cr>

"Alt+F8 - compare views
    nmap <silent><M-F8> :call CompareViews()<Cr>
    imap <silent><M-F8> <Esc>:call CompareViews()<Cr>
    vmap <silent><M-F8> <Esc>:call CompareViews()<Cr>

"Shift+F8 - go to prev difference
    nmap <silent><S-F8> [c
    imap <silent><S-F8> <Esc>[c
    vmap <silent><S-F8> <Esc>[c

"Ctrl+F8 - Menu 'Encoding'
    menu Encoding.Utf8     :e ++enc=utf8   ++ff=dos<Cr>:echo ''<Cr>
    menu Encoding.Win1251  :e ++enc=cp1251 ++ff=dos<Cr>:echo ''<Cr>
    menu Encoding.Cp866    :e ++enc=cp866  ++ff=dos<Cr>:echo ''<Cr>
    menu Encoding.Koi8-r   :e ++enc=koi8-r ++ff=dos<Cr>:echo ''<Cr>
    menu Encoding.Koi8-u   :e ++enc=koi8-u ++ff=dos<Cr>:echo ''<Cr>
    nmap <silent><C-F8>  :emenu Encoding.<TAB>
    imap <silent><C-F8>  <Exc>:emenu Encoding.<TAB>
    vmap <silent><C-F8>  <Exc>:emenu Encoding.<TAB>

"F9 - go to local bookmark N1
    nmap <F9> `a
    imap <F9> <Esc>`ai
    vmap <F9> <Esc>`a

"Alt+F9 - go to global bookmark N1
    nmap <M-F9> `A
    imap <M-F9> <Esc>`Ai
    vmap <M-F9> <Esc>`A

"Ctrl+F9 - set global bookmark N1
    nmap <C-F9> mA
    imap <C-F9> <Esc>mAi
    vmap <C-F9> <Esc>mAgv

"Shift+F9 - set local bookmark N1
    nmap <S-F9> ma
    imap <S-F9> <Esc>mai
    vmap <S-F9> <Esc>magv

"F10 - go to local bookmark N2
    nmap <F10> `b
    imap <F10> <Esc>`bi
    vmap <F10> <Esc>`b

"Alt+F10 - go to global bookmark N2
    nmap <M-F10> `B
    imap <M-F10> <Esc>`Bi
    vmap <M-F10> <Esc>`B

"Ctrl+F10 - set global bookmark N2
    nmap <C-F10> mB
    imap <C-F10> <Esc>mBi
    vmap <C-F10> <Esc>mBgv

"Shift+F10 - set local bookmark N2
    nmap <S-F10> mb
    imap <S-F10> <Esc>mbi
    vmap <S-F10> <Esc>mbgv

"F11 - go to local bookmark N3
    nmap <F11> `c
    imap <F11> <Esc>`ci
    vmap <F11> <Esc>`c

"Alt+F11 - go to global bookmark N3
    nmap <M-F11> `C
    imap <M-F11> <Esc>`Ci
    vmap <M-F11> <Esc>`C

"Ctrl+F11 - set global bookmark N3
    nmap <C-F11> mC
    imap <C-F11> <Esc>mCi
    vmap <C-F11> <Esc>mCgv

"Shift+F11 - set local bookmark N3
    nmap <S-F11> mc
    imap <S-F11> <Esc>mci
    vmap <S-F11> <Esc>mcgv

"F12 - go to local bookmark N4
    nmap <F12> `d
    imap <F12> <Esc>`di
    vmap <F12> <Esc>`d

"Alt+F12 - go to global bookmark N4
    nmap <M-F12> `D
    imap <M-F12> <Esc>`Di
    vmap <M-F12> <Esc>`D

"Ctrl+F12 - set global bookmark N4
    nmap <C-F12> mD
    imap <C-F12> <Esc>mDi
    vmap <C-F12> <Esc>mDgv

"Shift+F12 - set local bookmark N4
    nmap <S-F12> md
    imap <S-F12> <Esc>mdi
    vmap <S-F12> <Esc>mdgv

"Tab - move block right
    vmap <silent> <Tab> >gv

"Ctrl+Tab - next buffer
    nmap <silent> <C-Tab> :bn<Cr>
    imap <silent> <C-Tab> <Esc>:bn<Cr>i
    vmap <silent> <C-Tab> <Esc>:bn<Cr>

"Shift+Tab - next buffer / move block left
if has("gui_running")
    nmap <silent> <S-Tab> <4<Left>i
    imap <silent> <S-Tab> <Esc><4<Left>i
else
    nmap <silent> <S-Tab> :bn<Cr>
    imap <silent> <S-Tab> <Esc>:bn<Cr><Right>i
endif
    vmap <silent> <S-Tab> <gv

"BackSpace - go to edit-mode
    nmap <silent><BS> i<BS>

"Insert - go to edit-mode
    vmap <Insert> I

"Alt+Insert - copy current word to clipboard
    nmap <silent><M-Insert> yiw
    imap <silent><M-Insert> <Esc><Right>yiwi
    vmap <silent><M-Insert> <Esc><Right>yiwi

"Ctrl+Insert - copy to clipboard
    nmap <C-Insert> yy
    imap <C-Insert> <Esc>yyi
    vmap <C-Insert> "+yi

"Shift+Insert - paste from clipboard
    nmap <S-Insert> pi
    imap <S-Insert> <Esc>"+gPi
    vmap <S-Insert> <Del><S-Insert>
    cmap <S-Insert> <C-r>"

"Delete - go to edit-mode and delete a symbol / delete block
    nmap <Del> i<Del>
    vmap <Del>  "_di

"Alt+Del - delete line
    nmap <silent><M-Del> :let @a=@*<Cr>dd:let @*=@a<Cr>i
    imap <silent><M-Del> <Esc>:let @a=@*<Cr>dd:let @*=@a<Cr>i
    vmap <silent><M-Del> <Esc>:let @a=@*<Cr>dd:let @*=@a<Cr>v

"Shift+Delete - cut
    nmap <S-Del> ddi
    imap <S-Del> <Esc>ddi
    vmap <S-Del> "+xi

"Alt+End - duplicate line
    nmap <silent><M-End> :t.<Cr>i
    imap <silent><M-End> <Esc>:t.<Cr>i
    vmap <silent><M-End> yPi

"Alt+Up - move line up / move block up
    nmap <M-Up> :m -2<Cr>i
    imap <M-Up> <Esc>:m -2<Cr>i
    vmap <M-Up> :m '<-2<CR>gv=gv

"Ctrl+Up - move to the prev current word / to upper case selection
    nmap <silent><C-Up> :let @a=@*<Cr>yiw:call search(@*,'b')<Cr>:let @*=@a<Cr>
    imap <silent><C-Up> <Esc><Right>:let @a=@*<Cr>yiw:call search( @*,'b')<Cr>:let @*=@a<Cr>i
    vmap <silent><C-Up> Ui

"Alt+Left - home / move selected block left
    nmap <M-Left> <Home>
    imap <M-Left> <Home>
    vmap <M-Left> :s/^ //g<Cr>gv

"Alt+Right - end / move selected block right
    nmap <M-Right> <End>
    imap <M-Right> <End>
    vmap <M-Right> :s/^/ /g<Cr>gv

"Alt+Down - move line down / move block down
    nmap <M-Down> :m +1<Cr>i
    imap <M-Down> <Esc>:m +1<Cr>i
    vmap <M-Down> :m '>+1<CR>gv=gv

"Ctrl+Down - move to the next current word / to lower-case selection
    nmap <silent><C-Down> :let @a=@*<Cr>yiw:call search(@*)<Cr>:let @*=@a<Cr>
    imap <silent><C-Down> <Esc><Right>:let @a=@*<Cr>yiw:call search( @* )<Cr>:let @*=@a<Cr>i
    vmap <silent><C-Down> ui

"Alt+Home - select block
    nmap <silent><M-Home> :call SelectBlock(0)<Cr>
    imap <silent><M-Home> <Esc>:call SelectBlock(1)<Cr>
    vmap <silent><M-Home> <Esc>:call SelectBlock(0)<Cr>

"Shift+Home
    nmap <S-Home> v<Home>
    vmap <S-Home> <Home>
    imap <S-Home> <Esc>v<Home>

"Shift+End
    nmap <S-End> v<End>
    vmap <S-End> <End>
    imap <S-End> <Esc>v<End>

"Alt+PgDn - go to prev view
    nmap <M-PageUp> <C-w>p
    imap <M-PageUp> <Esc><C-w>p
    vmap <M-PageUp> <Esc><C-w>p

"Ctrl+PgUp - go to prev buffer
    nmap <silent> <C-PageUp> :bp<Cr>
    imap <silent> <C-PageUp> <Esc>:bp<Cr>i
    vmap <silent> <C-PageUp> <Esc>:bp<Cr>

"Alt+PgDn - go to next view
    nmap <M-PageDown> <C-w>w
    imap <M-PageDown> <Esc><C-w>w
    vmap <M-PageDown> <Esc><C-w>w

"Ctrl+PgDn - go to next buffer
    nmap <silent> <C-PageDown> :bn<Cr>
    imap <silent> <C-PageDown> <Esc>:bn<Cr>i
    vmap <silent> <C-PageDown> <Esc>:bn<Cr>

"Shift+arrow keys - select text
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

"Ctrl+` - show/hide menu-bar
    nmap <silent><C-`> :call ShowHideMenubar()<Cr>
    imap <silent><C-`> <Esc>:call ShowHideMenubar()<Cr>i
    vmap <silent><C-`> <Esc>:call ShowHideMenubar()<Cr>v

"Ctrl+0 - set font size in to default
    nmap <silent><C-0> :call ChangeFontSize(0)<Cr>
    imap <silent><C-0> <Esc>:call ChangeFontSize(0)<Cr>i
    vmap <silent><C-0> <Esc>:call ChangeFontSize(0)<Cr>v

"Ctrl+- - decrease font size
    nmap <silent><C--> :call ChangeFontSize(-1)<Cr>
    imap <silent><C--> <Esc>:call ChangeFontSize(-1)<Cr>i
    vmap <silent><C--> <Esc>:call ChangeFontSize(-1)<Cr>v

"Ctrl+= - increase font size
    nmap <silent><C-=> :call ChangeFontSize(1)<Cr>
    imap <silent><C-=> <Esc>:call ChangeFontSize(1)<Cr>i
    vmap <silent><C-=> <Esc>:call ChangeFontSize(1)<Cr>v

"Ctrl+\ - set scrollbind - synchronous scrolling of views
    nmap <silent><C-\> :set scrollbind<Cr>
    imap <silent><C-\> <Esc>:set scrollbind<Cr>
    vmap <silent><C-\> <Esc>:set scrollbind<Cr>

"Ctrl+] - open all folders
    nmap <silent><C-]> zR
    imap <silent><C-]> <Esc>zRi
    vmap <silent><C-]> <Esc>zRgv

"Ctrl+A - select all
    nmap <C-A> ggVG
    vmap <C-A> <Esc>ggVG
    imap <C-A> <Esc>ggVG

"Ctrl+B - go to vertical-block-mode
    nmap <C-B> <C-v>
    imap <C-B> <Esc><C-v>
    vmap <C-B> <Esc><C-v>

"Ctrl+C - copy
    nmap <C-C> yy
    imap <C-C> <Esc>yyi
    vmap <C-C> "+yi

"Ctrl+D - redo
    nmap <silent><C-D> :redo<Cr>
    imap <silent><C-D> <Esc>:redo<Cr>i
    vmap <silent><C-D> <Esc>:redo<Cr>gv

"Ctrl+E - compile
    nmap <silent><C-E> :call Complile()<Cr>
    imap <silent><C-E> <Esc>:call Complile()<Cr>
    vmap <silent><C-E> <Esc>:call Complile()<Cr>

"Ctrl+F - search
    nmap <C-F> :call SearchFor(0)<Cr>
    imap <C-F> <Esc>:call SearchFor(1)<Cr>
    vmap <C-F> "+y:call SearchFor(2)<Cr>

"Ctrl+G - goto line number
    nmap <silent><C-G> :call GoToLine(0)<Cr>
    imap <silent><C-G> <Esc>:call GoToLine(1)<Cr>
    vmap <silent><C-G> <Esc>:call GoToLine(2)<Cr>

"Ctrl+H - Search and Replace
    nmap <silent><C-H> :call SearchAndReplace(0)<Cr>
    imap <silent><C-H> <Esc>:call SearchAndReplace(1)<Cr>
    vmap <silent><C-H> "+y:call SearchAndReplace(2)<Cr>

"Ctrl+J - left
    nmap <C-J> <Left>
    imap <C-J> <Left>
    vmap <C-J> <Left>

"Ctrl+K - down
    nmap <C-K> <Down>
    imap <C-K> <Down>
    vmap <C-K> <Down>

"Ctrl+L - right
    nmap <C-L> <Right>
    imap <C-L> <Right>
    vmap <C-L> <Right>

"Ctrl+N - New file
    nmap <silent><C-N> :tabnew<CR>
    imap <silent><C-N> <Esc>:tabnew<Cr>
    vmap <silent><C-N> <Esc>:tabnew<Cr>

"Ctrl+O - Open file
    nmap <silent><C-O> :call OpenFile()<Cr>
    imap <silent><C-O> <Esc>:call OpenFile()<Cr>
    vmap <silent><C-O> <Esc>:call OpenFile()<Cr>

"Ctrl+P - close all folders
    nmap <silent><C-P> zM
    imap <silent><C-P> <Esc>zMi
    vmap <silent><C-P> <Esc>zMgv

"Ctrl+Q - Copy file to history
    nmap <silent><C-Q> :call SaveFile(0)<Cr> :!CopyToHistory.bat %<Cr>
    imap <silent><C-Q> <Esc>:call SaveFile(0)<Cr> :!CopyToHistory.bat %<Cr>i
    vmap <silent><C-Q> <Esc>:call SaveFile(0)<Cr> :!CopyToHistory.bat %<Cr>i

"Ctrl+R - show/hide bottem panel
    nmap <silent><C-R> :call ShowHidePanel()<Cr>
    imap <silent><C-R> <Esc>:call ShowHidePanel()<Cr>i
    vmap <silent><C-R> <Esc>:call ShowHidePanel()<Cr>gv

"Ctrl+S - Save file
    nmap <C-S> :call SaveFile(0)<Cr>
    imap <C-S> <Esc>:call SaveFile(1)<Cr>
    vmap <C-S> <Esc>:call SaveFile(2)<Cr>

"Ctrl+T - New file
    nmap <silent><C-T> :enew<CR>
    imap <silent><C-T> <Esc>:enew<Cr>
    vmap <silent><C-T> <Esc>:enew<Cr>

"Ctrl+U - up
    nmap <C-U> <Up>
    imap <C-U> <Up>
    vmap <C-U> <Up>

"Ctrl+V - paste
    imap <C-V> <Esc>"+gPi
    vmap <C-V> <Del><C-v>
    cmap <C-V> <C-r>"

"Ctrl+X - cut
    nmap <C-X> ddi
    imap <C-X> <Esc>ddi
    vmap <C-X> "+xi

"Ctrl+Y - delete current line
    nmap <silent><C-Y> :let @a=@*<Cr>dd:let @*=@a<Cr>i
    imap <silent><C-Y> <Esc>:let @a=@*<Cr>dd:let @*=@a<Cr>i
    vmap <silent><C-Y> "_di

"Ctrl+Z - undo
    nmap <silent><C-Z> u
    imap <silent><C-Z> <Esc>ui
    vmap <silent><C-Z> <Esc>ugv

"Space - go to command-mode
    nmap <Space> :
