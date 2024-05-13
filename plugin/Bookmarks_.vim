" Bookmarks in gVim

if exists("g:loaded_bookmarksPlugin")
    finish
endif

let g:loaded_bookmarksPlugin = "1"   " 1= plugin is turned ON; 0= plugin is turned OFF

if g:loaded_bookmarksPlugin == "0"
    finish
endif

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

"Alt+Shift+5 - go to local bookmark N5 ( in gVim )
    nmap <silent><M-%> `e
    imap <silent><M-%> <Esc>`ei
    vmap <silent><M-%> <Esc>`e

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

"Alt+Shift+6 - go to local bookmark N6 ( in gVim )
    nmap <silent><M-^> `f
    imap <silent><M-^> <Esc>`fi
    vmap <silent><M-^> <Esc>`f

"Ctrl+6 - go to global bookmark N6 ( in gVim )
    nmap <silent><C-6> `F
    imap <silent><C-6> <Esc>`Fi
    vmap <silent><C-6> <Esc>`F

"Ctrl+Alt+6 - set local bookmark N6 ( in gVim )
    nmap <silent><C-M-6> mf
    imap <silent><C-M-6> <Esc>mfi
    vmap <silent><C-M-6> <Esc>mfgv

"Ctrl+Shift+6 - set global bookmark N6 ( in gVim )
    nmap <silent><C-S-^> mF
    imap <silent><C-S-^> <Esc>mFi
    vmap <silent><C-S-^> <Esc>mFgv

"Alt+Shift+7 - go to local bookmark N7 ( in gVim )
    nmap <silent><M-&> `g
    imap <silent><M-&> <Esc>`gi
    vmap <silent><M-&> <Esc>`g

"Ctrl+7 - go to global bookmark N7 ( in gVim )
    nmap <silent><C-7> `G
    imap <silent><C-7> <Esc>`Gi
    vmap <silent><C-7> <Esc>`G

"Ctrl+Alt+7 - set local bookmark N7 ( in gVim )
    nmap <silent><C-M-&> mg
    imap <silent><C-M-&> <Esc>mgi
    vmap <silent><C-M-&> <Esc>mggv

"Ctrl+Shift+7 - set global bookmark N7 ( in gVim )
    nmap <silent><C-S-&> mG
    imap <silent><C-S-&> <Esc>mGi
    vmap <silent><C-S-&> <Esc>mGgv

"Alt+Shift+8 - go to local bookmark N8 ( in gVim )
    nmap <silent><M-*> `h
    imap <silent><M-*> <Esc>`hi
    vmap <silent><M-*> <Esc>`h

"Ctrl+8 - go to global bookmark N8 ( in gVim )
    nmap <silent><C-8> `H
    imap <silent><C-8> <Esc>`Hi
    vmap <silent><C-8> <Esc>`H

"Ctrl+Alt+8 - set local bookmark N8 ( in gVim )
    nmap <silent><C-M-8> mh
    imap <silent><C-M-8> <Esc>mhi
    vmap <silent><C-M-8> <Esc>mhgv

"Ctrl+Shift+8 - set global bookmark N8 ( in gVim )
    nmap <silent><C-S-*> mH
    imap <silent><C-S-*> <Esc>mHi
    vmap <silent><C-S-*> <Esc>mHgv

"Alt+Shift+9 - go to local bookmark N9 ( in gVim )
    nmap <silent><M-(> `i
    imap <silent><M-(> <Esc>`ii
    vmap <silent><M-(> <Esc>`i

"Ctrl+9 - go to global bookmark N9 ( in gVim )
    nmap <silent><C-9> `I
    imap <silent><C-9> <Esc>`Ii
    vmap <silent><C-9> <Esc>`I

"Ctrl+Alt+9 - set local bookmark N9 ( in gVim )
    nmap <silent><C-M-9> mi
    imap <silent><C-M-9> <Esc>mii
    vmap <silent><C-M-9> <Esc>migv

"Ctrl+Shift+9 - set global bookmark N9 ( in gVim )
    nmap <silent><C-S-(> mI
    imap <silent><C-S-(> <Esc>mIi
    vmap <silent><C-S-(> <Esc>mIgv
