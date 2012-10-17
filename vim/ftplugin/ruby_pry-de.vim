" Add this as ~/.vim/ftplugin/ruby_pry-de.vim (and make sure you've done:
"   filetype plugin on
" in your vim startup files.

" Add the pry debug line with \\p (or <Space><Space>p, if you mapped it)
map <Leader><Leader>p orequire 'pry';binding.pry<esc>:w<cr>
" …also, allow bpry<space> (or bpry<C-]>) from Insert Mode:
iabbr bpry require 'pry';binding.pry

" Nab the last line from ~/.pry_history.
map <leader>pry1 o<esc>:.!tail -1 ~/.pry_history<cr>==

" Recommended: Play with tslime.vim, vimux, et. al.
" I plan to really work out a good flow with the best parts of those, and put
" it here. In the meantime, these paltry snippets will have to do. ☹
