####################################################################
# ������H
# �w�肵���ԍ��ɑ΂���IP��ς�����
####################################################################

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) { Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs; exit }

# ���s�X�N���v�g���u���Ă���p�X�̎擾
$ScriptDir = Split-Path $MyInvocation.MyCommand.path

# ��c���ԍ�����͂�����
$MeetingRoomID = Read-Host "��c���ԍ�����͂��Ă�������(ex:3-6)"

# IP�̃��X�g����`����Ă�t�@�C�������邩�m�F �Ȃ������瑦�I��
$Judge = Test-Path $ScriptDir\IPList.ini
If($Judge -ne "True"){
    Write-Host "IP����`���ꂢ�Ă�t�@�C�����Ȃ���"
    exit 1
}

# grep��awk�݂����Ȃ��Ƃ����ĕK�v�ȏ���ϐ��ɓ˂�����
$IPAddress = Select-String $MeetingRoomID $ScriptDir\IPList.ini -Encoding default | ForEach-Object { $($_ -split",")[1] }
$Mask      = Select-String $MeetingRoomID $ScriptDir\IPList.ini -Encoding default | ForEach-Object { $($_ -split",")[2] }
$Gateway   = Select-String $MeetingRoomID $ScriptDir\IPList.ini -Encoding default | ForEach-Object { $($_ -split",")[3] }

# MAC�A�h���X���w�肳����
Get-NetAdapter
$MacAddress = Read-Host "MAC�A�h���X��I��ł�������"

# ���ۂ�IP���Z�b�g����
$a = Read-Host "IP�A�h���X�F${IPAddress}`r`n�T�u�l�b�g�}�X�N�F${Mask}`r`n�f�t�H���g�Q�[�g�E�F�C�F${Gateway}`r`n������Őݒ肵�܂��B��낵���ł����H`r`n�i�ނɂ͂Ȃ񂩉����Ă��������B"
Get-NetAdapter | ? MacAddress -eq $MacAddress | New-NetIPAddress -AddressFamily IPv4 -IPAddress $IPAddress -PrefixLength $Mask -DefaultGateway $Gateway

claer
ipconfig
$a = Read-Host "������ɂ͉��������Ă�������"
exit 0