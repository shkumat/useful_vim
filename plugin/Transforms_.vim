" Transformatons of text

if exists("g:loaded_transformsPlugin")
    finish
endif

let g:loaded_transformsPlugin = "1"   " 1= plugin is turned ON; 0= plugin is turned OFF

if g:loaded_transformsPlugin == "0"
    finish
endif

function Clear_Output()
    echon "\r\r"
    echon ''
endfunc

function DeleteTrailingSpaces()
    try
        :%s/\s\+$//g
    catch
    endtry
    call Clear_Output()
endfunc

function TabsToSpaces()
    let @a = ":%s/\t/    /g"
    try
        execute( @a )
    catch
    endtry
    call Clear_Output()
endfunc

function SplitCurrentLine()
    let @a = input('Delimiter : ')
    let @a = ':.s/' . @a . '/\r/g'
    try
        execute @a
    catch
    endtry
    call Clear_Output()
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
    call Clear_Output()
    call feedkeys('i')
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
    call Clear_Output()
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
    call Clear_Output()
endfunc


"Alt+F5 Menu 'Transformations'
    menu Transformations.Del_trail_spaces  :call DeleteTrailingSpaces()<Cr>
    menu Transformations.Tabs_to_spaces    :call TabsToSpaces()<Cr>
    menu Transformations.Split_cur_line    :call SplitCurrentLine()<Cr>
    menu Transformations.Join_all_lines    :call JoinAllLines()<Cr>
    menu Transformations.Add_before_begins :call Insert(0)<Cr>
    menu Transformations.Add_after_ends    :call Insert(1)<Cr>
    menu Transformations.CSV_into_SQL      :call Turn_CSV_into_SQL()<Cr>
    nmap <silent><M-F5>  :emenu Transformations.<Tab>
    imap <silent><M-F5>  <Esc>:emenu Transformations.<Tab>
    vmap <silent><M-F5>  <Esc>:emenu Transformations.<Tab>
