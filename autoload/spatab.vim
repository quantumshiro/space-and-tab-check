" 何行まで判定に利用するか
let s:max_line_num = get(g:, 'spatab_max_line_num', 300)
"スペース判定の場合に返す文字列
let s:space_name = get(g:, 'spatab_space_name', 'space')
"タブ判定
let s:tab_namee = get(g:, 'spatab_tab_name', 'tab')
"スペース判定ノ場合に実行される関数名
let s:space_func_name = get(g:, 'spatab_space_func_name', '')
"タブ判定
let s:tab_func_name = get(g:, 'spatab_tab_func_name', '')
"判定時に、自動的にexpandtabを切り替えるかのフラグ
let s:suto_expandtab = get(g:, 'spatab_auto_expandtab', 1)

function! spatab#GetDetectName() abort
	let detect_name = get(b:, 'space_detect_name', '')
	"すでにチェック済みか確認。済んでいるのなら飛ばす
	if detect_name ==# ''
		let buflines = getbline(bufname('%'), 1, s:max_line_num)
		let len_tab = len( filter(copy(buflines), "v:val =~# '^\\t'") )
		let len_space = len( filter(copy(buflines), "v:val =~# '^ '") )

		if len_space > len_tab

			let detect_name = s:space_name

		elseif len_space < len_tab 

			let detect_name = s:tab_name

		endif

		let b:spatab_detect_name = detect_name
	endif

	return detect_name
endfunction

function! spatab#Excute() abort
	let res = spatab#GetDetectName()
	if res ==# s:space_name
		if s:auto_expandtab | setlocal expandtab | endif
		if s:space_func_name !=# '' | call {s:space_func_name}() | endif

	elseif res ==# s:tab_name
		if s:auto_expandtab | setlocal noexpandtab | endif
    	if s:tab_func_name !=# '' | call {s:tab_func_name}() | endif
	endif

endfunction

