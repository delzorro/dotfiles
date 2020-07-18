"
" Generate phpdoc for methods
"
function! phpDoc#createPhpDoc()
    let l:currLine = getline('.')
    if l:currLine !~# '\c^.*function[^(]\+([^)]*)'
        echom "No (correct) method header found."
        return
    endif
    " Parse parameters from function declaration
    let l:funcParamsPart=  substitute(l:currLine, '\c^.*function[^(]\+(\([^)]*\)).*', '\1', '')
    let l:funcParams = split(l:funcParamsPart, ',')
    "if len(l:funcParams) <= 0
    "    echom "No method parameters found."
    "    return
    "endif
    " Parse return type
    let l:funcReturnPart =  substitute(l:currLine, '\c^[^)]\+)[^:]*:\(.\+\)', '\1', '')
    " Build phpdoc part array
    let l:phpDocs = ['<function description>', 'TODO']
    for l:param in l:funcParams
        let l:strippedParam = s:trimSpaces(l:param)
        let l:defaultIndex = stridx(l:strippedParam, "=")
        let l:defaultValue = ""
        if l:defaultIndex > -1
            let l:defaultValue = l:strippedParam[(l:defaultIndex+1):]
            let l:strippedParam = l:strippedParam[0:(l:defaultIndex-1)]
        endif
        let l:typedParams = split(l:strippedParam)
        let l:phpParam = '@param'
        let l:phpParamType = "<mixed>"
        let l:phpParamDefinition = s:trimSpaces(l:typedParams[0])
        if len(l:typedParams) > 1
            let l:phpParamType = l:phpParamDefinition
            let l:phpParamDefinition = s:trimSpaces(l:typedParams[1])
        endif
        let l:phpParam.=" ".l:phpParamType." ".l:phpParamDefinition
        let l:phpParam.=" - <describe>"
        if l:defaultValue != ""
            let l:defaultValue = s:trimSpaces(l:defaultValue)
            let l:phpParam.=" (default ".l:defaultValue.") "
        endif
        call add(l:phpDocs, l:phpParam)
    endfor
    " Return type
    let l:funcReturnType = "void"
    if l:funcReturnPart != l:currLine
        let l:funcReturnType = s:trimSpaces(l:funcReturnPart)
    endif
    let l:phpReturn = "@return ".l:funcReturnType." - <describe>"
        call add(l:phpDocs, l:phpReturn)
    " Build phpdoc string from phpdoc parts
    let l:phpDocString = "/**\n"
    for l:phpDocElement in l:phpDocs
        let l:phpDocString .= " * " .l:phpDocElement."\n"
    endfor
    let l:phpDocString .= " */\n"
    " Print phpdoc string above function
    " - Saving original registry content
    let l:phpDocLines = (len(l:phpDocs) + 1)
        "echo "#lines2indent: ".l:phpDocLines
    let l:regSave = @@
    let @@ = l:phpDocString
    exec "silent normal! P"
    exec "silent normal! =".l:phpDocLines."j"   | " Fix indentation docblock
    exec "silent normal! ".(l:phpDocLines+1)."j" | " Return cursor to method header
    let @@ = l:regSave
endfunction

"
" Strip left and right spaces of input parameter
"
function! s:trimSpaces(inputString)
    let l:strippedInput = substitute(a:inputString, '^\s*\(.\+\)$', '\1', '') | " Trim spaces left
    let l:strippedInput = substitute(l:strippedInput, '^\(.\+\)\s*$', '\1', '') | " Trim spaces right
    return l:strippedInput
endfunction
