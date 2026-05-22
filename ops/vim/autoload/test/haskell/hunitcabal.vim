if !exists('g:test#haskell#hunitcabal#file_pattern')
  let g:test#haskell#hunitcabal#file_pattern = '\v(^|/)test/(Main|.*Test)\.hs$'
endif

if !exists('g:test#haskell#hunitcabal#test_command')
  let g:test#haskell#hunitcabal#test_command = 'test'
endif

let s:hunit_patterns = {
      \ 'test': [
      \   '^\s*\(test[A-Za-z0-9_]*\)\s*::\s*Test\>',
      \   '^\s*\(test[A-Za-z0-9_]*\)\s*=\s*Test\(Case\|Label\|List\)\>'
      \ ],
      \ 'namespace': [
      \   '^\s*module\s\+\([A-Za-z0-9_.]\+\)\s\+'
      \ ],
      \}

function! test#haskell#hunitcabal#test_file(file) abort
  let l:file = substitute(a:file, '\\', '/', 'g')
  if l:file !~# g:test#haskell#hunitcabal#file_pattern
    return 0
  endif
  let l:file_parent_dir = fnamemodify(a:file, ':p:h')
  return !empty(s:get_nearest_project_dir(l:file_parent_dir))
endfunction

function! test#haskell#hunitcabal#build_position(type, position) abort
  let l:file_parent_dir = fnamemodify(a:position['file'], ':p:h')
  let l:package_dir = s:get_nearest_package_dir(l:file_parent_dir)
  let l:project_dir = s:get_nearest_project_dir(l:file_parent_dir)
  let l:package_name_arg = ''

  if !empty(l:package_dir) && l:package_dir !=# l:project_dir
    let l:package_name_arg = fnamemodify(l:package_dir, ':t')
  endif

  if fnamemodify(a:position['file'], ':t') ==# 'Main.hs'
    return s:mk_test_command(l:package_name_arg, '')
  endif

  let l:module_name = s:get_module_name(a:position)
  if a:type ==# 'nearest'
    let l:test_name = s:get_nearest_test_name(a:position)
    if !empty(l:test_name) && !empty(l:module_name)
      return s:mk_test_command(l:package_name_arg, l:module_name . '.' . l:test_name)
    elseif !empty(l:module_name)
      return s:mk_test_command(l:package_name_arg, l:module_name)
    endif
  elseif a:type ==# 'file' && !empty(l:module_name)
    return s:mk_test_command(l:package_name_arg, l:module_name)
  endif

  return s:mk_test_command(l:package_name_arg, '')
endfunction

function! test#haskell#hunitcabal#build_args(args) abort
  return a:args
endfunction

function! test#haskell#hunitcabal#executable() abort
  let l:repo_root = s:get_nearest_parent_dir(getcwd(), '.git')
  if executable('nix') && !empty(l:repo_root)
    let l:installable = escape(l:repo_root . '#haskell', '#')
    return 'nix develop ' . l:installable . ' -c cabal'
  endif
  return 'cabal'
endfunction

function! s:get_nearest_test_name(position) abort
  let l:result = test#base#nearest_test(a:position, s:hunit_patterns)
  return get(l:result['test'], 0, '')
endfunction

function! s:get_module_name(position) abort
  let l:file = fnamemodify(a:position['file'], ':p')
  for l:line in readfile(l:file, '', 40)
    let l:match = matchlist(l:line, '^\s*module\s\+\([A-Za-z0-9_.]\+\)\s\+')
    if !empty(l:match)
      return l:match[1]
    endif
  endfor
  return fnamemodify(a:position['file'], ':t:r')
endfunction

function! s:mk_test_command(package_name_arg, selector) abort
  let l:args = [g:test#haskell#hunitcabal#test_command, a:package_name_arg, '--test-show-details=direct']
  if !empty(a:selector)
    call add(l:args, '--test-option=--match=' . a:selector)
  endif
  return filter(l:args, '!empty(v:val)')
endfunction

function! s:get_nearest_project_dir(pwd) abort
  return s:get_nearest_parent_dir(a:pwd, 'cabal.project')
endfunction

function! s:get_nearest_package_dir(pwd) abort
  let l:dir = a:pwd
  while !empty(l:dir) && l:dir !=# fnamemodify(l:dir, ':h')
    if !empty(glob(l:dir . '/*.cabal'))
      return l:dir
    endif
    let l:dir = fnamemodify(l:dir, ':h')
  endwhile
  if !empty(glob(l:dir . '/*.cabal'))
    return l:dir
  endif
  return ''
endfunction

function! s:get_nearest_parent_dir(pwd, file_name) abort
  let l:dir = a:pwd
  while !empty(l:dir) && l:dir !=# fnamemodify(l:dir, ':h')
    if filereadable(l:dir . '/' . a:file_name) || isdirectory(l:dir . '/' . a:file_name)
      return l:dir
    endif
    let l:dir = fnamemodify(l:dir, ':h')
  endwhile
  if filereadable(l:dir . '/' . a:file_name) || isdirectory(l:dir . '/' . a:file_name)
    return l:dir
  endif
  return ''
endfunction
