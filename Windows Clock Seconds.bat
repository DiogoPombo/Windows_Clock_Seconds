@echo off
setlocal

set APP=Windows Clock Seconds
set AUTHOR=POMBO
set AVATAR=\Õ/
set MADE_BY=MADE BY:
set SPACE= 
set KEY=EWEP
echo %APP%%SPACE%%MADE_BY%%SPACE%%SPACE%%AUTHOR%%SPACE%%SPACE%%AVATAR%%SPACE%%KEY%

:: Batch
echo.
echo This program enable or disable seconds on the Windows taskbar clock!
echo.
pause

cls
echo.
color 0C
echo Warning! - This program makes changes in Windows registry and may not work properly if run without proper permissions!

:: VBS
setlocal

echo Set objShell = CreateObject("WScript.Shell") > "%~dp0\prompt.vbs"
echo answer = objShell.Popup("This program makes changes in Windows registry! Proceed?", 0, "Windows Clock Seconds - Alert!", 4 + 32) >> "%~dp0\prompt.vbs"
echo If answer = 6 Then >> "%~dp0\prompt.vbs"
echo     WScript.Quit(0) >> "%~dp0\prompt.vbs"
echo Else >> "%~dp0\prompt.vbs"
echo     WScript.Quit(1) >> "%~dp0\prompt.vbs"
echo End If >> "%~dp0\prompt.vbs"

cscript //nologo "%~dp0\prompt.vbs"
if %errorlevel% neq 0 (
    del "%~dp0\prompt.vbs"
    endlocal
    exit /b
)
del "%~dp0\prompt.vbs"

cls
echo.
color 07
echo Authorized!

:: PowerShell

set "psScript=%~dp0\psScript.ps1"
set "exitFlag=%~dp0\exitFlag.tmp"

echo 1 > "%exitFlag%"

:: PowerShell
echo Add-Type -AssemblyName System.Windows.Forms > "%psScript%"
echo Add-Type -AssemblyName System.Drawing >> "%psScript%"
echo $form = New-Object System.Windows.Forms.Form >> "%psScript%"
echo $form.Text = 'Clock Configuration' >> "%psScript%"
echo $form.Size = New-Object System.Drawing.Size(300,150) >> "%psScript%"
echo $form.StartPosition = 'CenterScreen' >> "%psScript%"
echo $label = New-Object System.Windows.Forms.Label >> "%psScript%"
echo $label.Text = 'Do you want to enable or disable seconds?' >> "%psScript%"
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
echo $exitButton.Text = 'Cancel' >> "%psScript%"
echo $exitButton.Size = New-Object System.Drawing.Size(75,23) >> "%psScript%"
echo $exitButton.Location = New-Object System.Drawing.Point(190,60) >> "%psScript%"
echo $exitButton.Add_Click({ >> "%psScript%"
echo     $form.Close() >> "%psScript%"
echo     Remove-Item "%exitFlag%" >> "%psScript%"
echo }) >> "%psScript%"
echo $form.Controls.Add($exitButton) >> "%psScript%"
echo $form.Topmost = $true >> "%psScript%"
echo $form.Add_Shown({$form.Activate()}) >> "%psScript%"
echo [void] $form.ShowDialog() >> "%psScript%"

::PowerShell
powershell -ExecutionPolicy Bypass -File "%psScript%"

:: Temp
if not exist "%exitFlag%" (
    goto :CLEANUP
)

:MENU
cls
echo Changes done, reboot required!
echo.
echo Want to reboot Windows now?
echo.
echo 1. Reboot now!
echo.
echo 2. Reboot later!
echo.
echo =====================================
echo.
set /p choice="Choose an option: (1 or 2): "

if %choice%==1 goto now
if %choice%==2 goto CLEANUP
goto MENU

:now
shutdown -r -t 5
goto CLEANUP

:CLEANUP
del "%psScript%"
del "%exitFlag%"
goto EOF

:EOF
endlocal
exit
