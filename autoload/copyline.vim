scriptencoding utf-8

let g:copyline_str_start = "(start)"
let g:copyline_str_end = "(end)"


" remove leading half-width spaces, tabs and bullet point symbols
let s:pat1 = '^[[:blank:]]*\(+\|-\|\*\|(\?[[:alnum:]]\+[.)]\)*[[:blank:]]*'
" remove last half-width spaces, tabs and symbols
let s:pat2 = '[[:blank:]]*\(#*\|[○×]\)[[:blank:]]*$'


" get stirings
function! GetString(text) abort
    let text1 = substitute(a:text, s:pat1, "", "")
    let result = substitute(text1, s:pat2, "", "")
    return result
endfunction

" copy text to clipboard
function! CopyTextClipboard(text) abort
    if a:text != "" && match(a:text, "^#") == -1
        echo "Copied [".a:text."]"
        let @+ = a:text
    else
        echo "Not copied."
    endif
endfunction


function! copyline#CopyLineSingle() abort
    let pos = getpos(".")

    let text = getline(pos[1])
    let result = GetString(text)
    call CopyTextClipboard(result)

    " cursor down
    " https://sy-base.com/myrobotics/vim/vim-cursor-position/
    let pos[1] += 1
    let pos[2] = 0
    call setpos(".", pos)
endfunction


function! copyline#CopyLineMulti() abort
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
        let result = GetString(text)
        call CopyTextClipboard(result)
        sleep 1
    endfor
    call cursor(endLine + 1, 0)
endfunction

