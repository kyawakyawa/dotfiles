function Create-SymbolicLinkIfNotExists {
    param (
        [string]$SourcePath,
        [string]$LinkPath
    )

    # リンクパスが存在するか確認
    if (-Not (Test-Path -Path $LinkPath)) {
        # リンクパスが存在しない場合、シンボリックリンクを作成
        New-Item -ItemType SymbolicLink -Path $LinkPath -Target $SourcePath
        Write-Output "symbolic link was created."
    } else {
        # リンクパスが既に存在する場合
        Write-Output "There is already file or directory '$LinkPath'."
    }
}

Create-SymbolicLinkIfNotExists -SourcePath $HOME\dotfiles\.vimrc -LinkPath $HOME\.vimrc
Create-SymbolicLinkIfNotExists -SourcePath $HOME\dotfiles\.vim -LinkPath $HOME\.vim
Create-SymbolicLinkIfNotExists -SourcePath $HOME\dotfiles\.gitconfig -LinkPath $HOME\.gitconfig
Create-SymbolicLinkIfNotExists -SourcePath $HOME\dotfiles\.config\nvim -LinkPath $env:LOCALAPPDATA\nvim
Create-SymbolicLinkIfNotExists -SourcePath $HOME\dotfiles\.config\efm-langserver  -LinkPath $env:APPDATA\efm-langserver
Create-SymbolicLinkIfNotExists -SourcePath $HOME\dotfiles\.config\lazygit -LinkPath $env:LOCALAPPDATA\lazygit
