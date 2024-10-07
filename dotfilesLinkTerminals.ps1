# ディレクトリが存在するか確認
$directoryPath = "$HOME\.config"
if (-Not (Test-Path -Path $directoryPath)) {
    # ディレクトリが存在しない場合、作成
    New-Item -ItemType Directory -Path $directoryPath
    Write-Output "Config directory was created."
} else {
    # ディレクトリが既に存在する場合
    Write-Output "Config directory is already existed."
}

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
        Write-Output "There is already file or directory."
    }
}

Create-SymbolicLinkIfNotExists -SourcePath $HOME\dotfiles\.config\wezterm -LinkPath $HOME\.config\wezterm
Create-SymbolicLinkIfNotExists -SourcePath $HOME\dotfiles\.config\alacritty -LinkPath $env:APPDATA\alacritty
Create-SymbolicLinkIfNotExists -SourcePath $HOME\dotfiles\.config\kitty -LinkPath $HOME\.config\kitty