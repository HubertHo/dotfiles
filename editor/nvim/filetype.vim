if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufRead,BufNewFile *.tex setfiletype tex
    au! BufREad,BufNewFile *njk setfiletype htmldjango
augroup END
