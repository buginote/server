set nocompatible "不与 Vi 兼容
syntax enable "打开语法高亮。自动识别代码，使用多种颜色显示。
set showmode "在底部显示，当前处于命令模式还是插入模式
set showcmd "命令模式下，在底部显示，当前键入的指令
set mouse=a "支持使用鼠标
"set encoding=utf-8 "使用 utf-8 编码
"set t_Co=256 "启用256色
"filetype indent on "文件类型检查,找Python 的缩进规则~/.vim/indent/python.vim

"缩进
set autoindent "下一行缩进保持一致
set tabstop=4 "按下 Tab 键时，Vim 显示的空格数
set shiftwidth=4 "在文本上按下>>（增加一级缩进）、<<（取消一级缩进）或者==（取消全部缩进）时，每一级的字符数
set expandtab "由于 Tab 键在不同的编辑器缩进不一致，该设置自动将 Tab 转为空格
set softtabstop=2 "Tab 转为多少个空格

"外观
colorscheme base16-default-dark
set background=dark
set number "显示行号
"set relativenumber "显示光标所在的当前行的行号，其他行都为相对于该行的相对行号
"set cursorline "光标所在的当前行高亮
set wrap "自动折行，即太长的行分成几行显示
set linebreak "只有遇到指定的符号（比如空格、连词号和其他标点符号），才发生折行,不会在单词内部折行
set wrapmargin=2 "折行处与编辑窗口的右边缘之间空出的字符数
set scrolloff=5 "垂直滚动时，光标距离顶部/底部的位置（单位：行）
set sidescrolloff=15 "水平滚动时，光标距离行首或行尾的位置（单位：字符）
set laststatus=2 "是否显示状态栏。0 表示不显示，1 表示只在多窗口时显示，2 表示显示
set ruler "状态栏显示光标的当前位置

"搜索
set showmatch "自动高亮对应的另一个圆括号、方括号和大括号
set hlsearch "高亮显示匹配结果
set incsearch "每输入一个字符，就自动跳到第一个匹配的结果
set ignorecase "搜索时忽略大小写
set smartcase "如果同时打开了ignorecase，那么对于只有一个大写字母的搜索词，将大小写敏感；其他情况都是大小写不敏感.比如，搜索Test时，将不匹配test；搜索test时，将匹配Test

"编辑
"set spell spelllang=en_us "打开英语单词的拼写检查
"set nobackup "不创建备份文件
"set noswapfile "不创建交换文件。交换文件主要用于系统崩溃时恢复文件，文件名的开头是.、结尾是.swp
"set undofile "保留撤销历史,撤消文件是跟原文件保存在一起的隐藏文件，文件名以.un~开头
"set backupdir=~/.vim/.backup//
"set directory=~/.vim/.swp//
"set undodir=~/.vim/.undo// "设置备份文件、交换文件、操作历史文件的保存位置.结尾的//表示生成的文件名带有绝对路径，路径中用%替换目录分隔符，这样可以防止文件重名
"set autochdir "自动切换工作目录。这主要用在一个 Vim 会话之中打开多个文件的情况，默认的工作目录是打开的第一个文件的目录。该配置可以将工作目录自动切换到，正在编辑的文件的目录
set noerrorbells "出错时，不要发出响声
set visualbell "出错时，发出视觉提示，通常是屏幕闪烁
set history=1000 "记住多少次历史操作
set autoread "打开文件监视。如果在编辑过程中文件发生外部改变（比如被别的编辑器编辑了），就会发出提示
"如果行尾有多余的空格（包括 Tab 键），该配置将让这些空格显示成可见的小方
set listchars=tab:»■,trail:■
set list
"命令模式下，底部操作指令按下 Tab 键自动补全。第一次按下 Tab，会显示所有匹配的操作指令的清单；第二次按下 Tab，会依次选择各个指令
set wildmenu
set wildmode=longest:list,full

let g:solarized_termtrans = 1
