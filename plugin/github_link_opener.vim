" Shamelessly cribbed from https://github.com/christoomey/vim-quicklink
function! s:OpenWithNetrw(url)
  if has("patch-7.4.567")
    call netrw#BrowseX(a:url, 0)
  else
    call netrw#NetrwBrowseX(a:url, 0)
  endif
endfunction

function! s:OpenGitHubLink()
  let word = expand('<cWORD>')
  let chars = '[-a-z0-9\.]\+'
  let path = matchstr(word, chars . '/' . chars)
  let has_more_than_one_slash = word =~# '/.\+/'
  if empty(path) || has_more_than_one_slash
    " Default behavior of `gx`
    call s:OpenWithNetrw(expand("<cfile>"))
  else
    call s:OpenWithNetrw("https://github.com/" . path)
  endif
endfunction

command! OpenGitHubLink call <sid>OpenGitHubLink()

if ! get(g:, 'github_link_opener_no_mappings', 0)
  nnoremap gx :OpenGitHubLink<CR>
endif
