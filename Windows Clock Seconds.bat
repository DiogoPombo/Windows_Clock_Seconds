@echo off
set APP=Windows Clock Seconds
set AUTHOR=POMBO
set AVATAR=\Õ/
set MADE_BY=MADE BY:
set SPACE= 
set KEY=EWEP
echo %APP%%SPACE%%MADE_BY%%SPACE%%SPACE%%AUTHOR%%SPACE%%SPACE%%AVATAR%%SPACE%%KEY%

setlocal

set "psScript=%~dp0tempScript.ps1"

:: Cria o script PowerShell temporário
echo Add-Type -AssemblyName System.Windows.Forms > "%psScript%"
echo Add-Type -AssemblyName System.Drawing >> "%psScript%"
echo $form = New-Object System.Windows.Forms.Form >> "%psScript%"
echo $form.Text = 'Clock Configuration' >> "%psScript%"
echo $form.Size = New-Object System.Drawing.Size(300,150) >> "%psScript%"
echo $form.StartPosition = 'CenterScreen' >> "%psScript%"
echo $label = New-Object System.Windows.Forms.Label >> "%psScript%"
echo $label.Text = 'Do you want to enable seconds on the taskbar clock?' >> "%psScript%"
echo $label.Size = New-Object System.Drawing.Size(280,20) >> "%psScript%"
echo $label.Location = New-Object System.Drawing.Point(10,20) >> "%psScript%"
echo $form.Controls.Add($label) >> "%psScript%"
echo $enableButton = New-Object System.Windows.Forms.Button >> "%psScript%"
echo $enableButton.Text = 'Enable' >> "%psScript%"
echo $enableButton.Size = New-Object System.Drawing.Size(75,23) >> "%psScript%"
echo $enableButton.Location = New-Object System.Drawing.Point(10,60) >> "%psScript%"
echo $enableButton.Add_Click({ >> "%psScript%"
echo     reg add 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' /v ShowSecondsInSystemClock /t REG_DWORD /d 1 /f >> "%psScript%"
echo     [System.Windows.Forms.MessageBox]::Show('Seconds have been enabled, reboot to see changes!', 'Done!') >> "%psScript%"
echo     $form.Close() >> "%psScript%"
echo }) >> "%psScript%"
echo $form.Controls.Add($enableButton) >> "%psScript%"
echo $disableButton = New-Object System.Windows.Forms.Button >> "%psScript%"
echo $disableButton.Text = 'Disable' >> "%psScript%"
echo $disableButton.Size = New-Object System.Drawing.Size(75,23) >> "%psScript%"
echo $disableButton.Location = New-Object System.Drawing.Point(100,60) >> "%psScript%"
echo $disableButton.Add_Click({ >> "%psScript%"
echo     reg add 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' /v ShowSecondsInSystemClock /t REG_DWORD /d 0 /f >> "%psScript%"
echo     [System.Windows.Forms.MessageBox]::Show('Seconds have been disabled, reboot to see changes!', 'Done!') >> "%psScript%"
echo     $form.Close() >> "%psScript%"
echo }) >> "%psScript%"
echo $form.Controls.Add($disableButton) >> "%psScript%"
echo $exitButton = New-Object System.Windows.Forms.Button >> "%psScript%"
echo $exitButton.Text = 'Exit' >> "%psScript%"
echo $exitButton.Size = New-Object System.Drawing.Size(75,23) >> "%psScript%"
echo $exitButton.Location = New-Object System.Drawing.Point(190,60) >> "%psScript%"
echo $exitButton.Add_Click({ >> "%psScript%"
echo     $form.Close() >> "%psScript%"
echo }) >> "%psScript%"
echo $form.Controls.Add($exitButton) >> "%psScript%"
echo $form.Topmost = $true >> "%psScript%"
echo $form.Add_Shown({$form.Activate()}) >> "%psScript%"
echo [void] $form.ShowDialog() >> "%psScript%"

powershell -ExecutionPolicy Bypass -File "%psScript%"

del "%psScript%"

endlocal

exit