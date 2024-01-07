" -------------------------------------
"  https://vimhelp.org/builtin.txt.html

" colorscheme slate
" colorscheme torte
colorscheme habamax
hi Visual ctermbg=darkgrey ctermfg=NONE guibg=#555555 guifg=NONE
hi ModeMsg ctermbg=NONE ctermfg=lightgray
hi WildMenu ctermbg=lightgray ctermfg=blue
hi StatusLine ctermbg=darkgrey
hi Search ctermbg=blue ctermfg=lightgray guifg=#cccccc guibg=#1f5faf
hi IncSearch ctermfg=234 ctermbg=108 guifg=#1c1c1c guibg=#87af87
hi CurSearch ctermbg=blue ctermfg=lightgray guifg=#cccccc guibg=#1f5faf
hi Cursor guifg=#181818 guibg=#cccccc

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

set updatetime=30000  " interval of autosave ( ms )

let @s = 1      "1 = auto-save is ON; 0 = auto-save is OFF
let @t = ''     "line of the block to select
let @u = 1      "search from the beginning of file
let @v = ''     "string to search
let @w = 0      "is comparasion mode ON
let @x = 11     "font size
let @y = 1      "is menu-bar hidden
let @z = 0      "is output-bar open

function RunScript()
    :!__.bat %
endfunc

function ClearOutput()
    echon "\r\r"
    echon ''
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
        let @a= '...'
    endtry
    echo @a
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
    if a:direction==0
        let @x = 11
    else
        let @x = @x+a:direction
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
    if ( a:mode == 1 )
        call SaveFile(0)
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
    let b:start_time = localtime()
    if has("gui_running")
        :browse confirm save
        call ClearOutput()
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
    if &modified
        if  bufname('%')[0] < ' '
            call SaveFileAs(0)
        else
            :w
        endif
    endif
    let b:start_time = localtime()
    call ClearOutput()
    if a:mode == 1
        call feedkeys('i')
    endif
    if a:mode == 2
        call feedkeys('g')
        call feedkeys('v')
    endif
endfunc

function OpenFile()
    if has("gui_running")
        :browse confirm e
    else
        :Explore
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

function SplitCurrentLine()
    let @a = input('Delimiter : ')
    let @a = ':.s/' . @a . '/\r/g'
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

function SelectBlock(mode)
    if @t > ''
        try
            let @a=getcurpos()[1]
            let num = 0
            while num < strchars( @t )
                call feedkeys( @t[ num ] )
                let  num += 1
            endwhile
            call feedkeys('g')
            call feedkeys('g')
            call feedkeys('V')
            let num = 0
            while num < strchars( @a )
                call feedkeys( @a[ num ] )
                let  num += 1
            endwhile
            call feedkeys('g')
            call feedkeys('g')
        catch
        endtry
        let @t=''
    else
        let @t=getcurpos()[1]
        if a:mode == 1
            call feedkeys('i')
        endif
    endif
endfunc

function AutoSave()
    if !exists("b:start_time")
        let b:start_time = localtime()
    endif
    if ( &modified > 0 ) && ( bufname('%')[0] > ' ' )
        if ( ( localtime() - b:start_time ) >= ( &updatetime / 1000 ) )
            update
            let b:start_time = localtime()
        endif
    endif
endfunction

if @s > 0
    let b:start_time = localtime()
    au CursorHold,CursorHoldI * call AutoSave()
    au CursorMoved,CursorMovedI * call AutoSave()
endif

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

"Alt+F3 - close current tab
    nmap <silent><M-F3> :tabclose<Cr>
    imap <silent><M-F3> <Esc>:tabclose<Cr>
    vmap <silent><M-F3> <Esc>:tabclose<Cr>

"Ctrl+F3 - close current view
    nmap <silent><C-F3> :close<Cr>
    imap <silent><C-F3> <Esc>:close<Cr>i
    vmap <silent><C-F3> <Esc>:close<Cr>

"Shift+F3 - search prev
    nmap <silent><S-F3> :call SearchPrev(0)<Cr>
    imap <silent><S-F3> <Esc>:call SearchPrev(1)<Cr>
    vmap <silent><S-F3> <Esc>:call SearchPrev(1)<Cr>

"F4 - goto next message / copy selected block
    nmap <silent><F4> :call GotoMessage(0)<Cr>
    imap <silent><F4> <Esc>:call GotoMessage(0)<Cr>i
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
    imap <silent><S-F4> <Esc>:call GotoMessage(1)<Cr>i
    vmap <silent><S-F4> <Esc>:call GotoMessage(1)<Cr>

"F5 - paste
    nmap <F5> pi
    imap <F5> <Esc>"+gPi
    vmap <F5> <Del><C-v>
    cmap <F5> <C-r>"

"Alt+F5 - Menu 'Controls'
    menu Controls.Clear_Global_BMs :delmarks A-Z0-9<Cr>:echo ''<Cr>
    menu Controls.Clear_Local_BMs  :delmarks!<Cr>:echo ''<Cr>
    menu Controls.Collapse_all     zM
    menu Controls.UnCollapse_all   zR
    menu Controls.Copy_FilePath    :let @* = expand('%:p')<Cr>:echo ''<Cr>
    menu Controls.Show_Histosy     :bro ol<Cr>
    menu Controls.Close_All_Files  :%bd<Cr>:echo ''<Cr>
    nmap <silent><M-F5>  :emenu Controls.<TAB>
    imap <silent><M-F5>  <Esc>:emenu Controls.<TAB>
    vmap <silent><M-F5>  <Esc>:emenu Controls.<TAB>

"Ctrl+F5 - run script
    nmap <silent><C-F5> :call SaveFile(0)<Cr>:call RunScript()<Cr>
    imap <silent><C-F5> <Esc>:call SaveFile(0)<Cr>:call RunScript()<Cr>
    vmap <silent><C-F5> <Esc>:call SaveFile(0)<Cr>:call RunScript()<Cr>

"Shift+F5 Menu 'Transformations'
    menu Transformations.Del_trail_spaces  :call DeleteTrailingSpaces()<Cr>
    menu Transformations.Add_before_begins :call Insert(0)<Cr>
    menu Transformations.Add_after_ends    :call Insert(1)<Cr>
    menu Transformations.Tabs_to_spaces    :call TabsToSpaces()<Cr>
    menu Transformations.Join_all_lines    :call JoinAllLines()<Cr>
    menu Transformations.Split_cur_line    :call SplitCurrentLine()<Cr>
    menu Transformations.CSV_into_SQL      :call Turn_CSV_into_SQL()<Cr>
    nmap <silent><S-F5>  :emenu Transformations.<Tab>
    imap <silent><S-F5>  <Esc>:emenu Transformations.<Tab>
    vmap <silent><S-F5>  <Esc>:emenu Transformations.<Tab>

"F6 - goto next view / calculate selected expression
    nmap <F6> <C-w>w
    imap <F6> <Esc><C-w>w
    vmap <silent><F6> "+y:call Calculate()<Cr>

"Alt+F6 - Menu 'Split'
    menu Split.Split_Vertically   :call VSplit()<Cr>
    menu Split.Split_Horizontally :call HSplit()<Cr>
    menu Split.Scroll_Binding     :set scrollbind<Cr>
    menu Split.Compare_Views      :call CompareViews()
    nmap <silent><M-F6>  :emenu Split.<Tab>
    imap <silent><M-F6>  <Esc>:emenu Split.<Tab>
    vmap <silent><M-F6>  <Esc>:emenu Split.<Tab>

"Ctrl+F6  - print list of buffers
    nmap <silent><C-F6> :ls<Cr>
    imap <silent><C-F6> <Esc>:ls<Cr>
    vmap <silent><C-F6> <Esc>:ls<Cr>

"Shift+F6 - goto prev view
    nmap <silent><S-F6> <C-w>p
    imap <silent><S-F6> <Esc><C-w>pi
    vmap <silent><S-F6> <Esc><C-w>p

"F7 - high-light current word / high-light selection
    nmap <silent><F7> :let @/='\<<C-R>=expand("<cword>")<Cr>\>'<Cr>:set hls<Cr>
    imap <silent><F7> <Esc>:let @/='\<<C-R>=expand("<cword>")<Cr>\>'<Cr>:set hls<Cr>i
    vmap <silent><F7> "+ymz:let @v=substitute( trim( @* ) , '\/' , '\\\/' , 'g')<Cr>:execute "/" . @v<Cr>`z

"Alt+F7 - search in files
    nmap <silent><M-F7> :call SearchInFiles(0)<Cr>
    vmap <silent><M-F7> <Esc>:call SearchInFiles(1)<Cr>
    imap <silent><M-F7> "+y:call SearchInFiles(2)<Cr>

"Ctrl+F7 - Menu 'Features'
    menu Features.Sort_Asc    :sort<Cr>:echo ''<Cr>
    menu Features.Sort_Desc   :sort!<Cr>:echo ''<Cr>
    menu Features.To_Utf8     :w ++enc=utf8   ++ff=dos<Cr>:q<Cr>
    menu Features.To_Win1251  :w ++enc=cp1251 ++ff=dos<Cr>:q<Cr>
    menu Features.To_Cp866    :w ++enc=cp866  ++ff=dos<Cr>:q<Cr>
    menu Features.To_Koi8-r   :w ++enc=koi8-r ++ff=dos<Cr>:q<Cr>
    menu Features.To_Koi8-u   :w ++enc=koi8-u ++ff=dos<Cr>:q<Cr>
    menu Features.Text_to_HEX :%!xxd<Cr>:echo ''<Cr>
    menu Features.HEX_to_Text :%!xxd -r<Cr>:echo ''<Cr>
    nmap <silent><C-F7>  :emenu Features.<TAB>
    imap <silent><C-F7>  <Esc>:emenu Features.<TAB>
    vmap <silent><C-F7>  <Esc>:emenu Features.<TAB>

"Shift+F7 - clear high-lights / high-Light selection
    nmap <silent><S-F7> :let @/=''<Cr>:echo ''<Cr>
    imap <silent><S-F7> <Esc>:let @/=''<Cr>:echo ''<Cr>i
    vmap <silent><S-F7> "+ymz:let @v=substitute( trim( @* ) , '\/' , '\\\/' , 'g')<Cr>:execute "/" . @v<Cr>`z

"F8 - go to next difference / multi-cursor insert / search selection
    nmap <silent><F8> ]c
    imap <silent><F8> <Esc>i
    vmap <silent><F8> "+y:call SearchFor(2)<Cr>

"Alt+F8 - Menu 'Settings'
    menu Settings.Search_from_begin :let @u=1<Cr>:echo ''<Cr>
    menu Settings.Search_further    :let @u=0<Cr>:echo ''<Cr>
    menu Settings.Ignore_cases      :set ignorecase<Cr>:echo ''<Cr>
    menu Settings.No_Ignore_cases   :set noignorecase<Cr>:echo ''<Cr>
    menu Settings.Fold_Syntax       :set foldmethod=syntax<Cr>:echo ''<Cr>
    menu Settings.Fold_Manual       :set foldmethod=manual<Cr>:echo ''<Cr>
    menu Settings.Fold_Indent       :set foldmethod=indent<Cr>:echo ''<Cr>
    nmap <silent><M-F8>  :emenu Settings.<Tab>
    imap <silent><M-F8>  <Esc>:emenu Settings.<Tab>
    vmap <silent><M-F8>  <Esc>:emenu Settings.<Tab>

"Ctrl+F8 - Menu 'Encoding'
    menu Encoding.Utf8     :e ++enc=utf8   ++ff=dos<Cr>:echo ''<Cr>
    menu Encoding.Win1251  :e ++enc=cp1251 ++ff=dos<Cr>:echo ''<Cr>
    menu Encoding.Cp866    :e ++enc=cp866  ++ff=dos<Cr>:echo ''<Cr>
    menu Encoding.Koi8-r   :e ++enc=koi8-r ++ff=dos<Cr>:echo ''<Cr>
    menu Encoding.Koi8-u   :e ++enc=koi8-u ++ff=dos<Cr>:echo ''<Cr>
    nmap <silent><C-F8>  :emenu Encoding.<TAB>
    imap <silent><C-F8>  <Exc>:emenu Encoding.<TAB>
    vmap <silent><C-F8>  <Exc>:emenu Encoding.<TAB>

"Shift+F8 - go to prev difference
    nmap <silent><S-F8> [c
    imap <silent><S-F8> <Esc>[c
    vmap <silent><S-F8> <Esc>[c

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
    nmap <silent><F12> `d
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

"Alt+1 - go to 1st tab ( in gVim )
    nmap <silent><M-1> 1gt
    imap <silent><M-1> <Esc>1gti
    vmap <silent><M-1> <Esc>1gt

"Alt+Shift+1 - go to local bookmark N1 ( in gVim )
    nmap <silent><M-!> `a
    imap <silent><M-!> <Esc>`ai
    vmap <silent><M-!> <Esc>`a

"Ctrl+1 - go to global bookmark N1 ( in gVim )
    nmap <silent><C-1> `A
    imap <silent><C-1> <Esc>`Ai
    vmap <silent><C-1> <Esc>`A

"Ctrl+Alt+1 - set local bookmark N1 ( in gVim )
    nmap <silent><C-M-1> ma
    imap <silent><C-M-1> <Esc>mai
    vmap <silent><C-M-1> <Esc>magv

"Ctrl+Shift+1 - set global bookmark N1 ( in gVim )
    nmap <silent><C-S-!> mA
    imap <silent><C-S-!> <Esc>mAi
    vmap <silent><C-S-!> <Esc>mAgv

"Alt+2 - go to 2nd tab ( in gVim )
    nmap <silent><M-2> 2gt
    imap <silent><M-2> <Esc>2gti
    vmap <silent><M-2> <Esc>2gt

"Alt+Shift+2 - go to local bookmark N2 ( in gVim )
    nmap <silent><M-@> `b
    imap <silent><M-@> <Esc>`bi
    vmap <silent><M-@> <Esc>`b

"Ctrl+2 - go to global bookmark N2 ( in gVim )
    nmap <silent><C-2> `B
    imap <silent><C-2> <Esc>`Bi
    vmap <silent><C-2> <Esc>`B

"Ctrl+Alt+2 - set local bookmark N2 ( in gVim )
    nmap <silent><C-M-2> mb
    imap <silent><C-M-2> <Esc>mbi
    vmap <silent><C-M-2> <Esc>mbgv

"Ctrl+Shift+2 - set global bookmark N2 ( in gVim )
    nmap <silent><C-S-@> mB
    imap <silent><C-S-@> <Esc>mBi
    vmap <silent><C-S-@> <Esc>mBgv

"Alt+3 - go to 3rd tab ( in gVim )
    nmap <silent><M-3> 3gt
    imap <silent><M-3> <Esc>3gti
    vmap <silent><M-3> <Esc>3gt

"Alt+Shift+3 - go to local bookmark N3 ( in gVim )
    nmap <silent><M-#> `c
    imap <silent><M-#> <Esc>`ci
    vmap <silent><M-#> <Esc>`c

"Ctrl+3 - go to global bookmark N3 ( in gVim )
    nmap <silent><C-3> `C
    imap <silent><C-3> <Esc>`Ci
    vmap <silent><C-3> <Esc>`C

"Ctrl+Alt+3 - set local bookmark N3 ( in gVim )
    nmap <silent><C-M-3> mc
    imap <silent><C-M-3> <Esc>mci
    vmap <silent><C-M-3> <Esc>mcgv

"Ctrl+Shift+3 - set global bookmark N3 ( in gVim )
    nmap <silent><C-S-#> mC
    imap <silent><C-S-#> <Esc>mCi
    vmap <silent><C-S-#> <Esc>mCgv

"Alt+4 - go to 4th tab ( in gVim )
    nmap <silent><M-4> 4gt
    imap <silent><M-4> <Esc>4gti
    vmap <silent><M-4> <Esc>4gt

"Alt+Shift+4 - go to local bookmark N4 ( in gVim )
    nmap <silent><M-$> `d
    imap <silent><M-$> <Esc>`di
    vmap <silent><M-$> <Esc>`d

"Ctrl+4 - go to global bookmark N4 ( in gVim )
    nmap <silent><C-4> `D
    imap <silent><C-4> <Esc>`Di
    vmap <silent><C-4> <Esc>`D

"Ctrl+Alt+4 - set local bookmark N4 ( in gVim )
    nmap <silent><C-M-4> md
    imap <silent><C-M-4> <Esc>mdi
    vmap <silent><C-M-4> <Esc>mdgv

"Ctrl+Shift+4 - set global bookmark N4 ( in gVim )
    nmap <silent><C-S-$> mD
    imap <silent><C-S-$> <Esc>mDi
    vmap <silent><C-S-$> <Esc>mDgv

"Alt+5 - go to 5th tab ( in gVim )
    nmap <silent><M-5> 5gt
    imap <silent><M-5> <Esc>5gti
    vmap <silent><M-5> <Esc>5gt

"Alt+Shift+5 - go to local bookmark N5 ( in gVim )
    nmap <silent><M-%> `e
    imap <silent><M-%$> <Esc>`ei
    vmap <silent><M-%$> <Esc>`e

"Ctrl+5 - go to global bookmark N5 ( in gVim )
    nmap <silent><C-5> `E
    imap <silent><C-5> <Esc>`Ei
    vmap <silent><C-5> <Esc>`E

"Ctrl+Alt+5 - set local bookmark N5 ( in gVim )
    nmap <silent><C-M-5> me
    imap <silent><C-M-5> <Esc>mei
    vmap <silent><C-M-5> <Esc>megv

"Ctrl+Shift+5 - set global bookmark N5 ( in gVim )
    nmap <silent><C-S-%> mE
    imap <silent><C-S-%> <Esc>mEi
    vmap <silent><C-S-%> <Esc>mEgv

"Alt+6 - go to 6th tab ( in gVim )
    nmap <silent><M-6> 6gt
    imap <silent><M-6> <Esc>6gti
    vmap <silent><M-6> <Esc>6gt

"Alt+7 - go to 7th tab ( in gVim )
    nmap <silent><M-7> 7gt
    imap <silent><M-7> <Esc>7gti
    vmap <silent><M-7> <Esc>7gt

"Alt+8 - go to 8th tab ( in gVim )
    nmap <silent><M-8> 8gt
    imap <silent><M-8> <Esc>8gti
    vmap <silent><M-8> <Esc>8gt

"Alt+9 - go to 9th tab ( in gVim )
    nmap <silent><M-9> 9gt
    imap <silent><M-9> <Esc>9gti
    vmap <silent><M-9> <Esc>9gt

"Tab - move block right
    vmap <silent> <Tab> >gv

"Ctrl+Tab - next buffer ( in gVim )
    nmap <silent> <C-Tab> :call SaveFile(0)<Cr>:bn<Cr>
    imap <silent> <C-Tab> <Esc>:call SaveFile(0)<Cr>:bn<Cr>i
    vmap <silent> <C-Tab> <Esc>:call SaveFile(0)<Cr>:bn<Cr>

"Shift+Tab - prev buffer / move block left
    nmap <silent> <S-Tab> :call SaveFile(0)<Cr>:bp<Cr>
    imap <silent> <S-Tab> <Esc>:call SaveFile(0)<Cr>:bp<Cr><Right>i
    vmap <silent> <S-Tab> <gv

"BackSpace - go to edit-mode
    nmap <silent><BS> i<BS>

"Shift+Enter - print ;<Enter> ( in gVim )
    nmap <S-Enter> i;<Cr>
    imap <S-Enter> ;<Cr>
    vmap <S-Enter> <Esc>i;<Cr>

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

"Ctrl+Del - delete word
    nmap <silent><C-Del> :let @a=@*<Cr>daw:let @*=@a<Cr>i
    imap <silent><C-Del> <Esc>:let @a=@*<Cr>daw:let @*=@a<Cr>i
    vmap <silent><C-Del> <Esc>:let @a=@*<Cr>daw:let @*=@a<Cr>i

"Shift+Delete - cut current line / selection
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
    vmap <M-Left> :s/^ //g<Cr>:let @/=''<Cr>gv

"Alt+Right - end / move selected block right
    nmap <M-Right> <End>
    imap <M-Right> <End>
    vmap <M-Right> :s/^/ /g<Cr>:let @/=''<Cr>gv

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

"Alt+PgUp - go to prev tab
    nmap <silent><M-PageUp> :tabprev<Cr>
    imap <silent><M-PageUp> <Esc>:tabprev<Cr>
    vmap <silent><silent><M-PageUp> <Esc>:tabprev<Cr>

"Ctrl+PgUp - go to prev buffer
    nmap <silent><C-PageUp> :call SaveFile(0)<Cr>:bp<Cr>
    imap <silent><C-PageUp> <Esc>:call SaveFile(0)<Cr>:bp<Cr>i
    vmap <silent><C-PageUp> <Esc>:call SaveFile(0)<Cr>:bp<Cr>

"Alt+PgDn - go to next tab
    nmap <silent><M-PageDown> :tabnext<Cr>
    imap <silent><M-PageDown> <Esc>:tabnext<Cr>
    vmap <silent><M-PageDown> <Esc>:tabnext<Cr>

"Ctrl+PgDn - go to next buffer
    nmap <silent><C-PageDown> :call SaveFile(0)<Cr>:bn<Cr>
    imap <silent><C-PageDown> <Esc>:call SaveFile(0)<Cr>:bn<Cr>i
    vmap <silent><C-PageDown> <Esc>:call SaveFile(0)<Cr>:bn<Cr>

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

"Ctrl+` - show/hide menu-bar ( in gVim )
    nmap <silent><C-`> :call ShowHideMenubar()<Cr>
    imap <silent><C-`> <Esc>:call ShowHideMenubar()<Cr>i
    vmap <silent><C-`> <Esc>:call ShowHideMenubar()<Cr>v

" ~ - clear output
    nmap <silent>~ :echo ''<Cr>

" * - high-light current word in Vim
    nmap <silent>* :let @/='\<<C-R>=expand("<cword>")<Cr>\>'<Cr>:set hls<Cr>

"Ctrl+] - clear output
    nmap <silent><C-]> :call ClearOutput()<Cr>
    imap <silent><C-]> <Esc>:call ClearOutput()<Cr>i
    vmap <silent><C-]> <Esc>:call ClearOutput()<Cr>

"Ctrl+; - go to prev tab ( in gVim )
    nmap <silent><C-;> :tabprev<Cr>
    imap <silent><C-;> <Esc>:tabprev<Cr>
    vmap <silent><C-;> <Esc>:tabprev<Cr>

"Ctrl+' - go to next tab ( in gVim )
    nmap <silent><C-'> :tabprev<Cr>
    imap <silent><C-'> <Esc>:tabprev<Cr>
    vmap <silent><C-'> <Esc>:tabprev<Cr>

"Ctrl+, - split vertically ( in gVim )
    nmap <silent><C-,>  :call VSplit()<Cr>
    imap <silent><C-,>  <Esc>:call VSplit()<Cr>i
    vmap <silent><C-,>  <Esc>:call VSplit()<Cr>

"Ctrl+. - split horizontally ( in gVim )
    nmap <silent><C-.>  :call HSplit()<Cr>
    imap <silent><C-.>  <Esc>:call VSplit()<Cr>i
    vmap <silent><C-.>  <Esc>:call VSplit()<Cr>

"Ctrl+\ - incremental search
    nmap <C-\> :call feedkeys('/')<Cr>
    imap <C-\> <Esc>:call feedkeys('/')<Cr>
    vmap <C-\> "+y:call feedkeys('/')<Cr>:call feedkeys( trim( @* ) )<Cr>

"Ctrl+/ - incremental search ( in gVim )
    nmap <C-/> :call feedkeys('/')<Cr>
    imap <C-/> <Esc>:call feedkeys('/')<Cr>
    vmap <C-/> "+y:call feedkeys('/')<Cr>:call feedkeys( trim( @* ) )<Cr>

"Ctrl+- - decrease font size ( in gVim )
    nmap <silent><C--> :call ChangeFontSize(-1)<Cr>
    imap <silent><C--> <Esc>:call ChangeFontSize(-1)<Cr>i
    vmap <silent><C--> <Esc>:call ChangeFontSize(-1)<Cr>v

"Ctrl+= - increase font size ( in gVim )
    nmap <silent><C-=> :call ChangeFontSize(1)<Cr>
    imap <silent><C-=> <Esc>:call ChangeFontSize(1)<Cr>i
    vmap <silent><C-=> <Esc>:call ChangeFontSize(1)<Cr>v

"Ctrl+0 - set font size in to default ( in gVim )
    nmap <silent><C-0> :call ChangeFontSize(0)<Cr>
    imap <silent><C-0> <Esc>:call ChangeFontSize(0)<Cr>i
    vmap <silent><C-0> <Esc>:call ChangeFontSize(0)<Cr>v

"Ctrl+Enter - clear output ( in gVim )
    nmap <C-Enter> :call ClearOutput()<Cr>
    imap <C-Enter> <Esc>:call ClearOutput()<Cr>i
    vmap <C-Enter> <Esc>:call ClearOutput()<Cr>

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
    nmap <silent><C-E> :call SaveFile(0)<Cr>:call Complile()<Cr>
    imap <silent><C-E> <Esc>:call SaveFile(0)<Cr>:call Complile()<Cr>
    vmap <silent><C-E> <Esc>:call SaveFile(0)<Cr>:call Complile()<Cr>

"Ctrl+F - search / search selection
    nmap <C-F> :call SearchFor(0)<Cr>
    imap <C-F> <Esc>:call SearchFor(1)<Cr>
    vmap <C-F> "+y:call SearchFor(2)<Cr>

"Ctrl+G - goto line number
    nmap <silent><C-G> :call GoToLine(0)<Cr>
    imap <silent><C-G> <Esc>:call GoToLine(1)<Cr>
    vmap <silent><C-G> <Esc>:call GoToLine(2)<Cr>

"Ctrl+H - search and replace
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

"Ctrl+O - open file
    nmap <silent><C-O> :call SaveFile(0)<Cr>:call OpenFile()<Cr>
    imap <silent><C-O> <Esc>:call SaveFile(0)<Cr>:call OpenFile()<Cr>
    vmap <silent><C-O> <Esc>:call SaveFile(0)<Cr>:call OpenFile()<Cr>

"Ctrl+P - new Tab
    nmap <silent><C-P> :tabnew<CR>
    imap <silent><C-P> <Esc>:tabnew<Cr>
    vmap <silent><C-P> <Esc>:tabnew<Cr>

"Ctrl+Q - copy file to history
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

"Ctrl+T - new file
    nmap <silent><C-T> :call SaveFile(0)<Cr>:enew<CR>
    imap <silent><C-T> <Esc>:call SaveFile(0)<Cr>:enew<Cr>
    vmap <silent><C-T> <Esc>:call SaveFile(0)<Cr>:enew<Cr>

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

"Ctrl+Space - auto-completion ( in gVim )
    nmap <silent><C-Space> i<C-N>
    imap <silent><C-Space> <C-N>
    vmap <silent><C-Space> <Esc>i<C-N>

"Shift+Space - incremental search ( in gVim )
    nmap <S-Space> :call feedkeys('/')<Cr>
    imap <S-Space> <Esc>:call feedkeys('/')<Cr>
    vmap <S-Space> "+y:call feedkeys('/')<Cr>:call feedkeys( trim( @* ) )<Cr>

"Mouse middle click - clear high-lights ( in gVim )
    nmap <silent><MiddleMouse> :let @/=''<Cr>:echo ''<Cr>
    imap <silent><MiddleMouse> <Esc>:let @/=''<Cr>:echo ''<Cr>i
    vmap <silent><MiddleMouse> <Esc>:let @/=''<Cr>:echo ''<Cr>

"Mouse left double click - hightlight current word ( in gVim )
    nmap <silent><2-LeftMouse> :let @/='\<<C-R>=expand("<cword>")<Cr>\>'<Cr>:set hls<Cr>
    imap <silent><2-LeftMouse> <Esc>:let @/='\<<C-R>=expand("<cword>")<Cr>\>'<Cr>:set hls<Cr>i
    vmap <silent><2-LeftMouse> <Esc>:let @/='\<<C-R>=expand("<cword>")<Cr>\>'<Cr>:set hls<Cr>
