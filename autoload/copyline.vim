scriptencoding utf-8

let g:copyline_str_start = "(start)"
let g:copyline_str_end = "(end)"


" remove leading half-width spaces, tabs and bullet point symbols
let s:pat1 = '^[[:blank:]]*\(+\|-\|\*\|(\?[[:alnum:]]\+[.)]\)*[[:blank:]]*'
" remove last half-width spaces, tabs and symbols
let s:pat2 = '[[:blank:]]*\(#*\|[○×]\)[[:blank:]]*$'


function! copyline#CopyLine() abort
    let pos = getpos(".")
    call setpos(".", [0, pos[1], 0, 0])

    let flags = "cW"
    let startLine = search(g:copyline_str_start, flags)
    let endLine = search(g:copyline_str_end, flags)

    if startLine == 0 || endLine == 0
        echo "missing start or end tag"
        call setpos(".", pos)
        return
    endif

    let texts = getline(startLine + 1, endLine - 1)
    for text in texts
        " get stirings
        let text1 = substitute(text, s:pat1, "", "")
        let result = substitute(text1, s:pat2, "", "")

        " copy result to clipboard
        if result != ""
            echo "Copied [".result."]"
            let @+ = result
            sleep 1
        else
            echo "Not copied."
        endif

    endfor

    " call cursor(endLine + 1, 0)
    call setpos(".", [0, endLine + 1, 0, 0])
endfunction

