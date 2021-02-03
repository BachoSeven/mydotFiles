" {{{ Post-Plugin Settings

" Startify
	fu! s:center(lines) abort
		let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
		let centered_lines = map(copy(a:lines),
					\ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
		retu centered_lines
	endfu
	let s:header = [
\ ' ________    _______  _____  ___  ___      ___  __     ___      ___ ',
\ '("      "\  /"     "|(\"   \|"  \|"  \    /"  ||" \   |"  \    /"  |',
\ ' \___/   :)(: ______)|.\\   \    |\   \  //  / ||  |   \   \  //   |',
\ '   /  ___/  \/    |  |: \.   \\  | \\  \/. ./  |:  |   /\\  \/.    |',
\ '  //  \__   // ___)_ |.  \    \. |  \.    //   |.  |  |: \.        |',
\ ' (:   / "\ (:      "||    \    \ |   \\   /    /\  |\ |.  \    /:  |',
\ '  \_______) \_______) \___|\____\)    \__/    (__\_|_)|___|\__/|___|',
\]
	let g:startify_custom_header = s:center(s:header)
	let g:startify_skiplist = [
	\ 'COMMIT_EDITMSG',
	\ ]
	let g:startify_use_env = 1

" Lf
	let g:lf_replace_netrw = 1 " open lf when a directory is opened with vim

" Better Escape
	let g:better_escape_interval = 200
	let g:better_escape_shortcut = 'jj'

" NerdCommenter
	let g:NERDSpaceDelims = 1
	let g:NERDCompactSexyComs = 1
	let g:NERDCustomDelimiters = { 'lf': { 'left': '#' } }	" Fix lfrc comments

" Deoplete
	let g:deoplete#enable_at_startup = 1

"" FZF
	let g:fzf_layout = { 'window': '10new' }
	nn <silent> <C-p> :FZF -m<cr>

" Better command history with q:
	command! CmdHist cal fzf#vim#command_history({'right': '40'})
	nn q: :CmdHist<CR>

" Change Colorscheme using fzf
	nn <silent> <leader>sc :cal fzf#run({
	\   'source':
	\     map(split(globpath(&rtp, "colors/*.vim"), "\n"),
	\         "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
	\   'sink':    'colo',
	\   'options': '+m',
	\   'left':    30
	\ })<CR>

" Change buffers with fzf
	fu! s:buflist()
	  redir => ls
	  silent ls
	  redir END
	  return split(ls, '\n')
	endf

	fu! s:bufopen(e)
	  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
	endf

	nn <silent> <Leader><Enter> :cal fzf#run({
	\   'source':  reverse(<sid>buflist()),
	\   'sink':    function('<sid>bufopen'),
	\   'options': '+m',
	\   'down':    len(<sid>buflist()) + 2
	\ })<CR>

" Autosave
	let g:auto_save = 0 " off by default

" Vimtex Configuration
	let g:matchup_override_vimtex = 1
	let g:vimtex_matchparen_deferred = 1
	se cole=2
	let g:vimtex_syntax_conceal_defaul = 0
	let g:vimtex_syntax_conceal = {
	\ 'accents' : 1,
	\ 'fancy' : 1,
	\ 'greek' : 1,
	\ 'math_bounds' : 1,
	\ 'math_delimiters' : 1,
	\ 'math_fracs' : 1,
	\ 'math_super_sub' : 1,
	\ 'math_symbols' : 1,
	\ 'styles' : 1,
	\ }
	hi Conceal ctermbg=none
  let g:vimtex_quickfix_mode = 2
  let g:vimtex_compiler_progname = 'nvr'
	let g:vimtex_view_use_temp_files = 1
  let g:vimtex_view_method='zathura'
  let g:vimtex_compiler_latexmk = {
    \ 'background' : 1,
    \ 'build_dir' : '',
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'options' : [
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}
  " Compile on initialization, cleanup on quit
  augroup vimtex_event_1
    au!
    au User VimtexEventQuit     call vimtex#compiler#clean(0)
    " au User VimtexEventInitPost call vimtex#compiler#compile()
	augroup END
  " Close viewers when vimtex buffers are closed
  function! CloseViewers()
    " Close viewers on quit
    if executable('xdotool') && exists('b:vimtex')
        \ && exists('b:vimtex.viewer') && b:vimtex.viewer.xwin_id > 0
      call system('xdotool windowclose '. b:vimtex.viewer.xwin_id)
    endif
  endfunction
  augroup vimtex_event_2
    au!
    au User VimtexEventQuit call CloseViewers()
  augroup END
" fzf integration for vimtex
  nn <localleader>lt :cal vimtex#fzf#run('cti', {'window': '50vnew'} )<cr>

	" UltiSnips
    let g:UltiSnipsExpandTrigger = '<tab>'
    let g:UltiSnipsJumpForwardTrigger = '<tab>'
    let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
    let g:UltiSnipsSnippetDirectories = [$HOME.'/.config/nvim/UltiSnips']

" vimtex deoplete
	cal deoplete#custom#var('omni', 'input_patterns', {
		\ 'tex': g:vimtex#re#deoplete
		\})

" UndoTree
	let g:undotree_WindowLayout = 3
	nn <leader>u :UndotreeToggle<cr>
	let g:undotree_SetFocusWhenToggle = 1
  let g:undotree_CursorLine = 0

" Gruvbox Material
	let g:gruvbox_material_transparent_background = 1
	let g:gruvbox_material_enable_italic = 1	" Italic Keywords
	let g:gruvbox_material_disable_italic_comment = 1

" Devicons
	let g:webdevicons_enable = 1
	let g:webdevicons_enable_startify = 1

" Lightline
	let g:lightline = {
				\ 'colorscheme': 'gruvbox_material',
	      \ 'active': {
				\   'left': [ [ 'mode', 'paste' ],
				\             [ 'readonly', 'filename' ] ],
				\ },
				\ 'component_function': {
				\   'filename': 'LightlineFilename',
	      \   'fileformat': 'LightlineFileformat',
				\		'filetype': 'LightlineFiletype',
				\		'fileencoding': 'LightlineFileencoding',
				\	},
				\	'mode_map': {
				\		'n' : 'N',
				\		'i' : 'I',
				\		'R' : 'R',
				\		'v' : 'V',
				\		'V' : 'VL',
				\		"\<C-v>": 'VB',
				\		'c' : 'C',
				\		's' : 'S',
				\		'S' : 'SL',
				\		"\<C-s>": 'SB',
				\		't': 'T',
				\ },
				\ }
	se noshowmode " Don't display mode in command line
	let g:lightline.separator = {
      \   'left': '', 'right': ''
      \}
	let g:lightline.subseparator = {
      \   'left': '', 'right': ''
      \}
	" Show total line number in square brackets
	let g:lightline.component = {
			\ 'lineinfo': '%3l[%L]:%-2v'}
	fu! LightlineFilename() " Trim bar between filename and modified sign
		let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
		let modified = &modified ? ' +' : ''
		retu filename . modified
	endfu
	fu! LightlineFileformat()
		retu winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
	endfu
	fu! LightlineFiletype()
		retu winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
	endfu
	fu! LightlineFileencoding()
		retu winwidth(0) > 60 ? (strlen(&fenc) ? &fenc : &enc) : ''
	endfu

" Minimap
	nn <leader>M :MinimapToggle<cr>
	let g:minimap_width = 20

" Limelight
	" Color name (:help cterm-colors) or ANSI code
	let g:limelight_conceal_ctermfg = '#a89984'
	" Color name (:help gui-colors) or RGB color
	let g:limelight_conceal_guifg = '#928374'

	" Default: 0.5
	let g:limelight_default_coefficient = 0.7

	" Number of preceding/following paragraphs to include (default: 0)
	let g:limelight_paragraph_span = 1

" Goyo
	let g:goyo_width = 100
	map <leader>g :Goyo \| se linebreak<CR>
	map <leader>G :Goyo \| se nolinebreak<CR>

	" Limelight integration
	au! User GoyoEnter Limelight
	fu! s:goyo_leave()
		hi LineNr ctermbg=NONE guibg=NONE
		hi Normal guibg=NONE ctermbg=NONE
		Limelight!
	endf
	au! User GoyoLeave nested cal <SID>goyo_leave()

" }}}
