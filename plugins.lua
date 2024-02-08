return require('packer').startup(function(use)

	use 'preservim/nerdtree'
	use 'tiagofumo/vim-nerdtree-syntax-highlight'
	use {'iamcco/markdown-preview.nvim',
	    run = 'cd app && yarn install',
		cmd = 'MarkdownPreview'}
	use 'morhetz/gruvbox'
	use 'vim-airline/vim-airline'
	use 'vim-airline/vim-airline-themes'
	use 'rafi/awesome-fim-colorschemes'
end)
