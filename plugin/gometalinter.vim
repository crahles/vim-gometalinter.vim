" needs gometalinter (https://github.com/alecthomas/gometalinter) installed in $PATH

if !exists("g:gometalinter_bin")
    let g:gometalinter_bin = "gometalinter"
endif

function! GoMetalinterRun(...) abort
    echon "GoMetalinter analysing ..." | echohl None
    let out = system(g:gometalinter_bin . " " . expand("%"))
    if v:shell_error
        let errors = []
        let mx = '^\(.\{-}\):\(\d\+\):\(\d\+\)\s*\(.*\)'
        " let mx = '\(?:\[^:\]\+\):\(\d\+\):\(\d\+\)?:\(?:\(warning\)|\(error\)\):\s*\(.*\)'
        for line in split(out, '\n')
            let tokens = matchlist(line, mx)

            if !empty(tokens)
                call add(errors, {"filename": tokens[1],
                            \"lnum": tokens[2],
                            \"col": tokens[3],
                            \"text": tokens[4]})
            endif
        endfor

        if empty(errors)
            echohl Error | echomsg "GoMetalinter returned error" | echohl None
            echo out
        endif

        if !empty(errors)
            redraw | echo
            call setqflist(errors, 'r')
        endif
    else
        call setqflist([])
    endif

    cwindow
endfunction

command! GoMetalinter call GoMetalinterRun()

" vim:ts=4:sw=4:et
