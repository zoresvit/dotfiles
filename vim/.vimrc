let $VIMHOME=$HOME . "/.vim"
let $VIMBUNDLE=$VIMHOME . "/bundle"

" Create directories required by Vim configuration.
if !isdirectory($VIMHOME . "/backups")
    call mkdir($VIMHOME . "/backups", "p")
endif
if !isdirectory($VIMHOME . "/swap")
    call mkdir($VIMHOME . "/swap", "p")
endif


" {{{ OPTIONS

syntax on

set background=dark
set backspace=indent,eol,start
set backup
set backupdir=$VIMHOME/backups
set browsedir=buffer
set colorcolumn=80
"set completeopt=longest,menuone
set cursorcolumn
set cursorline
set directory=$VIMHOME/swap
set fileencodings=utf-8,windows-1251,iso-8859015,koi8-r,latin1
"set fillchars=
set foldmethod=marker
set formatoptions+=r  " Automatically insert current comment leader on Enter.
set hidden
set laststatus=2
set lazyredraw  " Speedup execution during macros and other untyped commands.
set listchars=tab:->,trail:-
set matchpairs+=<:>
set mouse=a
set mousemodel=popup_setpos
set nowrap
set number
set path+=**
set scrolloff=3
"set showfulltag
set spelllang=en_us,ru_yo,uk
set splitbelow
set splitright
" Set native status line as fallback from vim-airline.
set statusline=%f\ %m\ %r\ %y\ [%{&fileencoding}]\ [len\ %L:%p%%]
set statusline+=\ [pos\ %02l:%02c\ 0x%O]\ [chr\ %3b\ 0x%02B]\ [buf\ #%n]
set textwidth=79
set undodir=$VIMHOME/swap
set undofile
set updatetime=1000  " For more efficient Tagbar functioning
set virtualedit=all
set visualbell
set wildmenu

" Search
" ------

set hlsearch
set ignorecase
set incsearch
set nowrapscan
set smartcase

" Indent
" ------

set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Filetype settings
" -----------------

let c_comment_strings = 1
let c_curly_error = 1  " Highlight a missing `}` (may be slow).
let c_space_errors = 1  " Highlight extra white spaces.
let g:load_doxygen_syntax = 1
let g:tex_flavor = "latex"  " Consider .tex files as LaTeX instead of plainTeX.
let g:tex_indent_brace = 0  " Prevent overindentation for `]` and `}`.
let g:xml_syntax_folding = 1

" }}}


" {{{ FUNCTIONS

if !exists("*ReloadConfig")
    " Reload .vimrc and .gvimrc configuration files.
    function! ReloadConfig()
        source $MYVIMRC
        if has("gui_running")
          source $MYGVIMRC
        endif
    endfunction
endif

function! ShowSpaces(...)
  let @/='\v(\s+$)|( +\ze\t)'
  let oldhlsearch=&hlsearch
  if !a:0
    let &hlsearch=!&hlsearch
  else
    let &hlsearch=a:1
  end
  return oldhlsearch
endfunction

function! TrimSpaces() range
    let oldhlsearch=ShowSpaces(1)
    execute a:firstline.",".a:lastline."substitute ///ge"
    let &hlsearch=oldhlsearch
endfunction

" }}}


" {{{ COMMANDS

command! -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call TrimSpaces()

" Save restricted file opened without root permissions via sudo.
command! W :w !sudo tee %

"}}}
"

" {{{ MAPPINGS

" Default <leader> key is \ (backslash).
"let mapleader="\"
nmap <silent> <leader>V :split $MYVIMRC<CR>
nmap <silent> <leader>R :call ReloadConfig()<CR>

" }}}


" {{{ PLUGINS

filetype off  " Filetype recognition must be disabled for Vundle setup.
set rtp+=$VIMBUNDLE/Vundle.vim/
call vundle#begin()

" Essentials
" ==========

Plugin 'VundleVim/Vundle.vim'  " Vim plugin manager.
Plugin 'bling/vim-airline'  " Enhanced status line.
Plugin 'vim-airline/vim-airline-themes'
Plugin 'zoresvit/vim-colors-solarized'
Plugin 'Shougo/unite.vim'  " Fuzzy search for files and buffers.
Plugin 'lyokha/vim-xkbswitch'  " Automatic keyboard layout switcher.
Plugin 'scrooloose/nerdtree'  " File browser.
Plugin 'majutsushi/tagbar'  " File tags browser.
"Plugin 'Valloric/YouCompleteMe'  " Ultimate auto-completion.
Plugin 'scrooloose/syntastic'  " Ultimate static syntax analysis.
Plugin 'SirVer/ultisnips'  " Snippets engine.
Plugin 'honza/vim-snippets'  " Snippets database.
Plugin 'airblade/vim-gitgutter'  " Show git diff in gutter (+/- signs column).
Plugin 'tpope/vim-fugitive'  " Git interface for Vim.
Plugin 'gregsexton/gitv'  " Git repository visualizer (requires vim-fugitive).
Plugin 'mkitt/tabline.vim'  " Better tabs naming.
Plugin 'sjl/gundo.vim'  " Browse Vim undo tree graph.

" Programming
" ===========

Plugin 'klen/python-mode'
Plugin 'lervag/vimtex'
Plugin 'Glench/Vim-Jinja2-Syntax'
Plugin 'rodjek/vim-puppet'
Plugin 'artur-shaik/vim-javacomplete2'
Plugin 'jszakmeister/markdown2ctags'
Plugin 'jszakmeister/rst2ctags'

" Enhancements
" ============

Plugin 'seveas/bind.vim'  " Edit DNS Zone files.
Plugin 'tmux-plugins/vim-tmux'  " Edit Tmux configuration file.
Plugin 'fidian/hexmode'  " Edit binary files.
Plugin 'ekalinin/Dockerfile.vim'  " Edit Dockerfile.
Plugin 'smancill/conky-syntax.vim'  " Syntax highlighting for Conky.
Plugin 'gabrielelana/vim-markdown'  " Edit Markdown.
Plugin 'hrother/msmtp.vim'  " msmtprc syntax highlighting.
Plugin 'hrother/offlineimaprc.vim'  " offlineimaprc highlighting.
Plugin 'Matt-Deacalion/vim-systemd-syntax'
"Plugin 'chase/vim-ansible-yaml'  " Ansible syntax highlighting and snippets.

call vundle#end()
filetype plugin indent on

" }}}

" {{{ PLUGINS CONFIGURATION

" Airline
" -------

let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.paste = '▼'
let g:airline_symbols.readonly = ''
let g:airline_symbols.whitespace = '∅'
let g:airline#extensions#tabline#tab_nr_type = 2
let g:airline_section_y = airline#section#create_right(['ffenc', '0x%02B'])
let g:airline_section_z = airline#section#create(['windowswap', '%p%% ', 'linenr', ':%-v', ':0x%03O'])


" xkbswitch
" ---------

let g:XkbSwitchEnabled = 1
let g:XkbSwitchSkipFt = [ 'nerdtree' ]

" Solarized
" ---------

if isdirectory($VIMBUNDLE . "/vim-colors-solarized")
    let g:solarized_bold=0
    let g:solarized_underline=0
    let g:solarized_italic=0
    colorscheme solarized
endif

" Unite
" -----

call unite#custom#profile('default', 'context', {'winheight': 10})
nnoremap <leader>f :Unite -no-split -start-insert file_rec<CR>
nnoremap <leader>b :Unite -no-split buffer<CR>
let g:unite_enable_auto_select=0

" NERDTree
" --------

imap <F2> :NERDTreeToggle<CR>
nmap <F2> :NERDTreeToggle<CR>

" Tagbar
" ------

imap <F3> :TagbarToggle<CR>
nmap <F3> :TagbarToggle<CR>

let g:tagbar_type_css = {
\ 'ctagstype' : 'Css',
    \ 'kinds'     : [
        \ 'c:classes',
        \ 's:selectors',
        \ 'i:identities'
    \ ]
\ }

let g:tagbar_type_make = {
            \ 'kinds':[
                \ 'm:macros',
                \ 't:targets'
            \ ]
\}

let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '$VIMBUNDLE/markdown2ctags/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

let g:tagbar_type_puppet = {
    \ 'ctagstype': 'puppet',
    \ 'kinds': [
        \'c:class',
        \'s:site',
        \'n:node',
        \'d:definition'
      \]
    \}

let g:tagbar_type_rst = {
    \ 'ctagstype': 'rst',
    \ 'ctagsbin' : '$VIMBUNDLE/rst2ctags/rst2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

" YouCompleteMe
" -------------

let g:ycm_global_ycm_extra_conf = '/home/zoresvit/.vim/.ycm_extra_conf.py'
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>j :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Syntastic
" ---------

" HTML5 lint with http://www.htacg.org/tidy-html5.
let g:syntastic_html_tidy_exec = 'tidy5'

" UtliSnips
" ---------

let g:UltiSnipsExpandTrigger       = '<c-\>'
let g:UltiSnipsListSnippets        = '<c-l>'
let g:UltiSnipsJumpForwardTrigger  = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:UltiSnipsEditSplit = "horizontal"
let g:ultisnips_python_style = "sphinx"

" Python-mode
" -----------

let g:pymode_rope = 0
let g:pymode_folding = 0
let g:pymode_indent = 1
let g:pymode_motion = 1

let g:pymode_trim_whitespaces = 1
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>B'
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1

" vimtex
" ------

let g:vimtex_latexmk_enabled = 0
let g:vimtex_fold_enabled = 0

" }}}
