scriptencoding utf-8

" remove leading half-width spaces, tabs and bullet point symbols
let s:pat1 = '^[[:blank:]]*\(+\|-\|\*\|(\?[[:alnum:]]\+[.)]\)*[[:blank:]]*'
" remove last half-width spaces, tabs and symbols
let s:pat2 = '[[:blank:]]*\(#*\|[○×]\)[[:blank:]]*$'


function! copyline#CopyLine() abort
    let pos = getpos(".")

    let text = getline(pos[1])
    " get stirings
    let text1 = substitute(text, s:pat1, "", "")
    let result = substitute(text1, s:pat2, "", "")

    " cursor down
    " https://sy-base.com/myrobotics/vim/vim-cursor-position/
    let pos[1] += 1
    let pos[2] = 0
    call setpos(".", pos)

    " copy result to clipboard
    if result != ""
        echo "Copied [".result."]"
        let @+ = result
    else
        echo "Not copied."
    endif
endfunction

