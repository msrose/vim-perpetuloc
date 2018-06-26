if exists('g:loaded_perpetuloc')
  finish
endif

let g:loaded_perpetuloc = 1

function! s:PerpetulocJump(type, offset)
  let loclist = getloclist(0)
  if empty(loclist)
    echo 'No errors!'
    return
  endif
  let error_count = len(loclist)
  if error_count == 1
    ll 1
    return
  endif
  let current_cursor_line = line('.')
  let current_cursor_column = col('.')
  let error_after_index = 0
  let error_before_index = -1
  while error_after_index < error_count
    let error = loclist[error_after_index]
    if error.lnum == current_cursor_line &&
          \ error.col > current_cursor_column ||
          \ error.lnum > current_cursor_line
      let error_before_index = error_after_index - 1
      break
    endif
    let error_after_index += 1
  endwhile
  let error_after_index = error_after_index % error_count
  let error_after = loclist[error_after_index]
  let current_line_length = len(getline('.'))
  if error_after.lnum == current_cursor_line &&
        \ error_after.col > current_cursor_line &&
        \ current_cursor_column == current_line_length
    let error_after_index += 1
  endif
  let error_after_index = error_after_index % error_count
  let error_before = loclist[error_before_index]
  if error_before.lnum == current_cursor_line && error_before.col == current_cursor_column
    let error_before_index = error_after_index - 2
  endif
  let jump_dict = { 'previous': error_before_index, 'next': error_after_index }
  if !has_key(jump_dict, a:type)
    throw 'LocJump: Unknown jump type "' . a:type . '". Expected one of [' . join(keys(jump_dict), ',') . '].'
  endif
  let error_index_to_jump_to = jump_dict[a:type]
  if error_index_to_jump_to < 0
    let error_index_to_jump_to += error_count
  endif
  let error_index_to_jump_to += a:type == 'next' ? a:offset - 1 : 1 - a:offset
  let error_index_to_jump_to = error_index_to_jump_to % error_count
  execute 'll ' . (error_index_to_jump_to + 1)
endfunction

if !exists(':Lnext')
  command -count=1 Lnext call s:PerpetulocJump('next', <count>)
endif
if !exists(':Lprevious')
  command -count=1 Lprevious call s:PerpetulocJump('previous', <count>)
endif
if !exists(':Lfirst')
  command -nargs=? -bang Lfirst lfirst<bang> <args>
endif
if !exists(':Llast')
  command -nargs=? -bang Llast llast<bang> <args>
endif
