# vim-perpetuloc

Cursor-based location list jumping for vim.

## Commands

- `:[count]Lnext` - jump to the [count] next error in the location list after the current cursor position, regardless of what vim has as the "current" error. If on or after the last error, jump to the first error.
- `:[count]Lprevious` - jump to the [count] previous error in the location list before the current cursor position, regardless of what vim has as the "current" error. If on or before the first error, jump to the last error.
- `:Lfirst[!] [nr]` - an alias for `:lfirst` (see `:h :lfirst`)
- `:Llast[!] [nr]` - an alias for `:llast` (see `:h :llast`)

`:Lfirst` and `:Llast` are just defined for consistency - they can make it easier to define mappings dynamically.

## Installation

Use your favourite plugin manager. For example, if you're using vim-plug, add the following to your plugin configuration:

```
Plug 'msrose/vim-perpetuloc'
```

Optionally add the following commands to your vimrc:

```
nnoremap [l :Lprevious
nnoremap ]l :Lnext
nnoremap [L :Lfirst
nnoremap ]L :Llast
```

## Motivation

By default, location list jumping with `:lnext` and `:lprevious` works like the analogous commands for the quickfix list (`:cnext`/`:cprevious`):

- Jump points are discrete: if you jump to an error and then move around with `j`/`k`, vim still thinks you're at the error you last jumped to, even though your cursor position has changed, so jumping to another error can sometimes appear to "skip" errors.
- You can't jump from above the first error to the first error (or from below the last error to the last error) using `:lnext` (`:lprevious`): you have to use `:lfirst` (`:llast`) instead.
- The location list doesn't wrap (you can't jump beyond the first error or the last error with `:lprevious`/`:lnext`).

Since location lists are local to the current window, you might find it more useful to jump to errors based on the current cursor position, and allow jumps to wrap past the first and last errors.
The `:Lnext` and `:Lprevious` commands defined by perpetuloc offer "continuous" (i.e. perpetual) location list jumping, instead of the default "discrete" jumping.
