" Auto save of a modified current file

if exists("g:loaded_autosavePlugin")
    finish
endif

let g:loaded_autosavePlugin = "1"   " 1= plugin is turned ON; 0= plugin is turned OFF

set updatetime=30000                " interval of autosave, ms

if g:loaded_autosavePlugin == "0"
    finish
endif

function AutoSave()
    if ( &modified > 0 ) && ( bufname('%')[0] > ' ' )
        if !exists("b:last_save_time")
            let b:last_save_time = localtime()
        else
            if ( localtime() - b:last_save_time ) >= ( &updatetime / 1000 )
                update
                let b:last_save_time = localtime()
            endif
        endif
    endif
endfunction

let b:last_save_time = localtime()
au CursorHold,CursorHoldI * call AutoSave()
au CursorMoved,CursorMovedI * call AutoSave()