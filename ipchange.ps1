####################################################################
# 何これ？
# 指定した番号に対してIPを変えるやつ
####################################################################

Set-ExecutionPolicy RemoteSigned
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) { Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs; exit }

# 実行スクリプトが置いてあるパスの取得
$ScriptDir = Split-Path $MyInvocation.MyCommand.path

# 会議室番号を入力させる
$MeetingRoomID = Read-Host "会議室番号を入力してください(ex:3-6)"

# IPのリストが定義されてるファイルがあるか確認 なかったら即終了
$Judge = Test-Path $ScriptDir\IPList.ini
If($Judge -ne "True"){
    Write-Host "IPが定義されいてるファイルがないよ"
    exit 1
}

# grepとawkみたいなことをして必要な情報を変数に突っ込む
$IPAddress = Select-String $MeetingRoomID $ScriptDir\IPList.ini -Encoding default | ForEach-Object { $($_ -split",")[1] }
$Mask      = Select-String $MeetingRoomID $ScriptDir\IPList.ini -Encoding default | ForEach-Object { $($_ -split",")[2] }
$Gateway   = Select-String $MeetingRoomID $ScriptDir\IPList.ini -Encoding default | ForEach-Object { $($_ -split",")[3] }

# MACアドレスを指定させる
Get-NetAdapter
$MacAddress = Read-Host "MACアドレスを選んでください"

# 実際にIPをセットする
$a = Read-Host "IPアドレス：${IPAddress}`r`nサブネットマスク：${Mask}`r`nデフォルトゲートウェイ：${Gateway}`r`nこちらで設定します。よろしいですか？`r`n進むにはなんか押してください。"
Get-NetAdapter | ? MacAddress -eq $MacAddress | New-NetIPAddress -AddressFamily IPv4 -IPAddress $IPAddress -PrefixLength $Mask -DefaultGateway $Gateway

claer
ipconfig
$a = Read-Host "続けるには何か押してください"
exit 0