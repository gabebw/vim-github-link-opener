let s:PACKAGE_REGISTRIES = { 'ruby': 'rubygems' }

function! s:RequestPackageUrl(package)
  let api_url = 'https://octolinker-api.now.sh/?' . s:PACKAGE_REGISTRIES[&ft] . '='
  let request_url = api_url . a:package
  let response = webapi#http#get(request_url)
  let content = webapi#json#decode(response.content)
  return get(content.result[0], 'result', '')
endfunction

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
  let chars = '[-a-zA-Z0-9\.]\+'
  let path = matchstr(word, chars . '/' . chars)
  let has_more_than_one_slash = word =~# '/.\+/'
  let line_has_js_package = getline('.') =~# '\<\(require\|import\|from\)\>'
  let line_has_ruby_package = getline('.') =~# '\<\(require\|gem\)\>'
  if &ft ==# 'go' && has_more_than_one_slash
    let url = matchstr(word, chars . '/' . chars . '/' . chars)
    call s:OpenWithNetrw("https://" . url)
  elseif index(['javascript', 'javascript.jsx', 'typescript'], &ft) >= 0 && line_has_js_package
    let re_scoped_or_nonscoped_npm_package = '\v[''"]\zs((\@(\w+[-.]?)+\/(\w+[-.]?)+)|(\w+[-.]?)+)'
    let package = matchstr(getline('.'), re_scoped_or_nonscoped_npm_package)
    if !empty(package)
      silent execute '!npm repo ' . package | redraw!
    endif
  elseif &ft ==# 'ruby' && line_has_ruby_package
    let package_split_slash = split(matchstr(getline('.'), '\v[''"]\zs(\w[-/]?)+\ze'), '/')
    if empty(package_split_slash) | return | endif

    if len(package_split_slash) > 1
      let package_slash_to_dash = join(package_split_slash, '-')
      let url = s:RequestPackageUrl(package_slash_to_dash)
      if !empty(url)
        call s:OpenWithNetrw(url) | return
      endif
    endif

    let url = s:RequestPackageUrl(package_split_slash[0])
    if !empty(url)
      call s:OpenWithNetrw(url)
    endif
  elseif empty(path) || has_more_than_one_slash
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
