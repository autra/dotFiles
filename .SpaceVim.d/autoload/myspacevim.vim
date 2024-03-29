function! myspacevim#before() abort
  let g:python3_host_prog = "/usr/bin/python3"
  " let g:python_host_prog = "/usr/bin/python"
  
  " Default to static completion for SQL
  " until I take the time to look at the dbext plugin
  let g:omni_sql_default_compl_type = 'syntax'
endfunction

function! myspacevim#after() abort

" general {
    " doesn't work well with telescope
    " set autochdir
" }

" Vim UI {
    set ignorecase                  " Case insensitive search
    set smartcase                   " case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
" }

" vimfiler customization {
"    nmap <buffer> c   <Plug>(vimfiler_create_file: 
" }

" vebugger customization {
    nmap [SPC]du :VBGrawWrite u<CR>
    nmap [SPC]dd :VBGrawWrite d<CR>
    nmap [SPC]dr :VBGrawWrite 
    " where am I TODO make a fn that put you back at the current line
    nmap [SCP]dw :VBGrawWrite w<CR>
" }

  " ctrlp customization
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']

  " eslint: always execute the local one
  " let g:syntastic_javascript_eslint_exe = '$(npm bin)/eslint'

  "
  call dein#add('CaffeineViking/vim-glsl')
  " use local eslint exec
  " call dein#add('benjie/local-npm-bin.vim')
  " let b:neomake_javascript_eslint_exe = GetNpmBin('eslint')


  " rust
  "
  call dein#add('puuuuh/vimspector-rust')


  " colorscheme
  " onehalf colorscheme
  call dein#add('sonph/onehalf', #{ rtp: './vim' })
  " call dein#add('chriskempson/base16-vim')

endfunction
