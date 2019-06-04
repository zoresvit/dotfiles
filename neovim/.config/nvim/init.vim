let $VIM_HOME=fnamemodify($MYVIMRC, ':h')
let $VIM_SITE=$HOME . "/.local/share/nvim/site"
let $VIM_PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"


" PLUGINS
" =======

" Auto install vim-plug plugin manage/r.
if !filereadable($VIM_HOME . '/autoload/plug.vim')
    if executable('curl')
        silent !curl -fLo $VIM_HOME/autoload/plug.vim --create-dirs $VIM_PLUG_URL
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    else
        echomsg "Install curl to download vim-plug plugin manager!"
    endif
endif

call plug#begin($VIM_HOME . "/plugins")
    Plug 'junegunn/vim-plug'  " Generate :help for vim-plug itself.

    " Basics
    Plug 'arcticicestudio/nord-vim'  " Colorscheme.
    Plug 'itchyny/lightline.vim'  " Enhanced status line.
    Plug 'sjl/gundo.vim', {'on': 'GundoToggle'}  " Browse change history tree.
    Plug 'ctrlpvim/ctrlp.vim'

    " Editing
    Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
    Plug 'cohama/lexima.vim'
    Plug 'fidian/hexmode'  " Hex editor mode.

    " Version control
    Plug 'gregsexton/gitv', {'on': ['Gitv']} | Plug 'tpope/vim-fugitive' 
    Plug 'mhinz/vim-signify'  " Show diff in signcolumn.

    " Completion
    Plug 'ncm2/ncm2' | Plug 'roxma/nvim-yarp'
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-path'
    Plug 'ncm2/ncm2-ultisnips'
    Plug 'ncm2/ncm2-vim-lsp'
    if exists('*nvim_open_win')
        Plug 'ncm2/float-preview.nvim'
    endif

    " Programming
    Plug 'liuchengxu/vista.vim', {'on': 'Vista'}
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/vim-lsp'
    "Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }

    " Enhancements for specific file types.
    Plug 'smancill/conky-syntax.vim'  " Syntax for .conkyrc.
    Plug 'hashivim/vim-vagrant', {'for': 'Vagrantfile'}
    Plug 'pearofducks/ansible-vim', {'for': 'ansible', 'do': 'cd ./UltiSnips; ./generate.py'}
    Plug 'cespare/vim-toml', {'for': ['toml']}
    Plug 'leafgarland/typescript-vim', {'for': ['typescript']}
    Plug 'pangloss/vim-javascript', {'for': ['javascript']}
    Plug 'octol/vim-cpp-enhanced-highlight', {'for': ['cpp']}
    Plug 'plasticboy/vim-markdown', {'for': ['markdown']}
    Plug 'Glench/Vim-Jinja2-Syntax', {'for': ['jinja']}
call plug#end()

" nord-vim
" --------

let g:nord_italic = 1
let g:nord_underline = 1
let g:nord_uniform_diff_background = 1
colorscheme nord

" lightline.vim
" -------------

let g:lightline = {
    \ 'colorscheme': 'nord',
    \ 'active': {
    \   'left': [
    \               ['mode', 'paste'],
    \               ['fugitive'],
    \               ['filename']
    \           ],
    \   'right': [
    \               ['lineinfo'],
    \               ['percent'],
    \               ['filetype', 'fileformat', 'fileencoding', 'charvaluehex']
    \           ]
    \ },
    \ 'inactive': {
    \   'left': [[], ['filename']],
    \   'right': [['lineinfo'], ['percent']]
    \ },
    \ 'component': {
    \   'lineinfo': '%3l:%-2v',
	\   'charvaluehex': '%2Bₕ',
    \ },
    \ 'component_function': {
    \   'readonly': 'LightlineReadonly',
    \   'fugitive': 'LightlineFugitive'
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }

function! LightlineReadonly()
    return &readonly ? '' : ''
endfunction

function! LightlineFugitive()
    if exists('*fugitive#head')
        let branch = fugitive#head()
        return branch !=# '' ? ''.branch : ''
    endif
    return ''
endfunction

" gundo.vim
" ---------

let g:gundo_prefer_python3 = 1

" ctrlp.vim
" ---------

let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:10,results:10'

" ultisnips
" ---------

let g:UltiSnipsExpandTrigger = '<C-\>'

command! UltiSnipsListSnippets :call UltiSnips#ListSnippets()

" vim-signify
" -----------
"
let g:signify_vcs_list = ['git', 'hg']
let g:signify_sign_delete            = '−'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change            = '~'
let g:signify_sign_changedelete      = '≂'
let g:signify_sign_show_count = 0

" ncm2
" ----

let g:float_preview#docked = 0
let g:float_preview#max_width = 100

function! NCM2Config()
    call nvim_win_set_option(g:float_preview#win, 'cursorline', v:false)
    call nvim_win_set_option(g:float_preview#win, 'cursorcolumn', v:false)
endfunction

augroup NCM2
    autocmd!
    autocmd User FloatPreviewWinOpen call NCM2Config()
    autocmd BufEnter * call ncm2#enable_for_buffer()
augroup end

" vista.vim
" ---------

let g:vista_echo_cursor = 0
let g:vista_blink = [0, 0]

" vim-lsp
" -------

let g:lsp_virtual_text_enabled = 0
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_highlights_enabled = 0

augroup LSPCLANG
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
augroup end

augroup LSPPYTHON
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ 'workspace_config': {
        \   'pyls': {'plugins': {'pydocstyle': {'enabled': v:true}}}
        \   }
        \ })
augroup end

augroup LSPRUST
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
        \ 'whitelist': ['rust'],
        \ })
augroup end

augroup LSPGOLANG
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
        \ 'whitelist': ['go'],
        \ })
    autocmd BufWritePre *.go LspDocumentFormatSync
augroup end

augroup LSPBASH
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'bash-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
        \ 'whitelist': ['sh'],
        \ })
augroup end


" SETTINGS
" ========

set autoread
set background=dark
set backspace=indent,eol,start
set backup
set clipboard=unnamed,unnamedplus
set colorcolumn=80
set completeopt=menuone,noinsert,noselect
set cursorcolumn
set cursorline
set formatoptions+=r  " Auto-insert current comment leader on Enter.
set hidden  " Hide current buffer when opening new file instead of closing it.
set lazyredraw
set listchars=tab:→\ ,space:·,extends:▶,precedes:◀,nbsp:␣
set matchpairs+=<:>
set mouse=a
set mousehide
set mousemodel=popup_setpos
set nofoldenable
set noshowmode  " Mode is already displayed by statusline plugin.
set nowrap
set number
set path+=**  " Search downwards in a directory for `gf`, etc.
set scrolloff=3
set showbreak=↪
set showfulltag  " Show arguments for a function when available, etc.
set sidescrolloff=3
set spelllang=en_us,ru_yo,uk
set splitbelow
set splitright
set termguicolors
set textwidth=79
set title
set undofile
set updatetime=1000
set virtualedit=all
set wildmenu

" Search
set hlsearch
set incsearch
set nowrapscan
set ignorecase
set infercase
set smartcase

" Indentation
set breakindent
set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set shiftround

" Directories for temp files.
set undodir=$VIM_SITE/undo
set backupdir=$VIM_SITE/backups
set directory=$VIM_SITE/swap  " Directory to store swap files.

" Ensure directories for Vim temp files exist.
for path in [&undodir, &backupdir, &directory]
    if !isdirectory(expand(path))
        call mkdir(expand(path), "p")
    endif
endfor

" File browser
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_liststyle = 3
let g:netrw_silent = 1
let g:netrw_special_syntax = 1
let g:netrw_winsize = 20

" Filetype settings
let c_comment_strings = 1
let c_space_errors = 1  " Highlight extra white spaces.
let g:tex_flavor = "latex"  " Consider .tex files as LaTeX instead of plainTeX.

" Prevent Neovim from calling Python on startup.
" See https://github.com/neovim/neovim/issues/5728#issuecomment-265454125
let g:python3_host_skip_check = 0
let g:python_host_skip_check = 0
if has("mac")
    let g:python_host_prog  = '/usr/local/bin/python'
    let g:python3_host_prog = '/usr/local/bin/python3'
else
    let g:python_host_prog  = '/usr/bin/python'
    let g:python3_host_prog = '/usr/bin/python3'
endif

" GUI settings
if !has("mac")
    set guifont=Hack:h14
endif


" MAPPINGS
" ========

nnoremap <silent> <leader>V :edit $MYVIMRC<CR>
nnoremap <leader>R :source $MYVIMRC<CR>
nnoremap <leader>s :set spell!<CR>
nnoremap <leader>ff :CtrlP<CR>
nnoremap <leader>fb :CtrlPBuffer<CR>

" Reset search highlighting by double pressing Esc in normal mode.
nnoremap <Esc><Esc> :nohlsearch<CR>

inoremap <silent> <leader>1 :Lexplore<CR>
nnoremap <silent> <leader>1 :Lexplore<CR>

inoremap <silent> <leader>2 :Vista<CR>
nnoremap <silent> <leader>2 :Vista<CR>

inoremap <silent> <leader>3 :GundoToggle<CR>
nnoremap <silent> <leader>3 :GundoToggle<CR>

"nnoremap <silent> <leader>ff :Denite file/rec<CR>
"nnoremap <silent> <leader>fb :Denite buffer<CR>
"nnoremap <silent> <leader>fg :Denite grep<CR>
"nnoremap <silent> <leader>fr :Denite register<CR>
"nnoremap <silent> <leader>fw :DeniteCursorWord file/rec buffer grep<CR>


" COMMANDS
" ========

" Remove trailing spaces from file.
function! ShowSpaces(...)
    " Highlight trailing spaces.
    let @/='\v(\s+$)|( +\ze\t)'
    let oldhlsearch=&hlsearch
    if !a:0
        let &hlsearch=!&hlsearch
    else
        let &hlsearch=a:1
    end
    return oldhlsearch
endfunction

function! FixSpaces()
    " Remove trailing spaces.
    let oldhlsearch=ShowSpaces(1)
    execute a:firstline.",".a:lastline."substitute ///ge"
    let &hlsearch=oldhlsearch
endfunction

command! -bar -nargs=0 -range=% FixSpaces <line1>,<line2>call FixSpaces()

" Update plugins.
command! Update :call ReloadConfig() | PlugUpdate | PlugUpgrade | source $MYVIMRC

" Commands for merge conflict resolution.
command! MergeLocal :diffget //2
command! MergeRemote :diffget //3


" AUTOCOMMANDS
" ============

augroup CPP
    autocmd!
    autocmd FileType c,h,cpp,cxx setlocal cindent
    autocmd FileType c,h,cpp,cxx setlocal cinoptions = "h3,l1,g1,t0,i4,+4,(0,w1,W4"
augroup END

augroup MISC
    autocmd!
    " Treat .conf files as .cfg.
    autocmd BufReadPost,BufNewFile *.conf setlocal filetype=cfg
augroup END
