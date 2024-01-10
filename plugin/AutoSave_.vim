" Auto save of modified file

if exists("g:loaded_autosavePlugin")
    finish
endif

let g:loaded_autosavePlugin = "1"   " 1= plugin is turned ON; 0= plugin is turned OFF

set updatetime=30000                " interval of autosave, ms

if g:loaded_autosavePlugin == "0"
    finish
endif

function AutoSave()
    if g:loaded_autosavePlugin == "0"
        return
    endif
    let g:loaded_autosavePlugin = "0"
    if ( &modified > 0 ) && ( bufname('%')[0] > ' ' )
        if ( localtime() - b:last_save_time ) >= ( &updatetime / 1000 )
            update
            let b:last_save_time = localtime()
        endif
    endif
    let g:loaded_autosavePlugin = "1"
endfunction

let b:last_save_time = localtime()
au CursorHold,CursorHoldI * call AutoSave()
au CursorMoved,CursorMovedI * call AutoSave()