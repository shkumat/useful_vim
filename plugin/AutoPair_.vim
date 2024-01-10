" Auto-enter of 2nd symbol of pair( in gVim )

if exists("g:loaded_autopairPlugin")
    finish
endif

let g:loaded_autopairPlugin = "1"   " 1= plugin is turned ON; 0= plugin is turned OFF

if g:loaded_autopairPlugin == "0"
    finish
endif

imap    [   [  ]<Left><Left>
imap    (   (  )<Left><Left>
imap    {   {  }<Left><Left>
inoremap '  ''<Esc>i
inoremap "  ""<Esc>i
