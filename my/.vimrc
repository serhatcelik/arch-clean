" Create a highlight group for trailing whitespaces.
highlight Trail ctermbg=red

" Ensure that the highlight group is not cleared by future ColorScheme commands.
autocmd ColorScheme * highlight Trail ctermbg=red

" Show trailing whitespaces.
match Trail /\s\+$/

" Strip trailing whitespaces on save.
autocmd BufWritePre * :%s/\s\+$//e

" Automatically go to next line.
set whichwrap+=<,>,[,]

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Use space characters instead of tabs.
set expandtab

" Copy the indentation of the current line to a new line.
set autoindent

" Do smart autoindenting when starting a new line.
set smartindent

" Shift tab for insert mode.
inoremap <S-Tab> <C-d>

" Do not save backup files.
set nobackup

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Set the commands to save in history.
set history=10000

" Show the status on the second to last line.
set laststatus=2

" When a bracket is inserted, do not jump to the matching one.
set noshowmatch

" Show line numbers.
" set number

" Show a vertical line for the maximum line length.
" set colorcolumn=80
