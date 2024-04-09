@echo off
rmdir /Q /S ..\..\Vayu-Drivers-Release
mkdir ..\..\Vayu-Drivers-Release

echo @echo off > ..\OnlineUpdater.cmd
echo ^(NET FILE^|^|^(powershell -command Start-Process '%%0' -Verb runAs -ArgumentList '%%* '^&EXIT /B^)^)^>NUL 2^>^&1 >> ..\OnlineUpdater.cmd
echo pushd "%%~dp0" ^&^& cd %%~dp0 >> ..\OnlineUpdater.cmd
echo .\tools\DriverUpdater\%%PROCESSOR_ARCHITECTURE%%\DriverUpdater.exe -r . -d .\definitions\Desktop\ARM64\Internal\vayu.xml >> ..\OnlineUpdater.cmd
echo pause >> ..\OnlineUpdater.cmd

echo @echo off > ..\OfflineUpdater.cmd
echo ^(NET FILE^|^|^(powershell -command Start-Process '%%0' -Verb runAs -ArgumentList '%%* '^&EXIT /B^)^)^>NUL 2^>^&1 >> ..\OfflineUpdater.cmd
echo for /f %%%%a in ('wmic logicaldisk where "VolumeName='WINVAYU'" get deviceid^^^|find ":"')do set "DrivePath=%%%%a" >> ..\OfflineUpdater.cmd
echo if not [%%DrivePath%%]==[] goto start >> ..\OfflineUpdater.cmd
echo if [%%DrivePath%%]==[] echo Automatic WINVAYU detection failed! Enter Drive Letter manually. >> ..\OfflineUpdater.cmd
echo :sdisk >> ..\OfflineUpdater.cmd
echo set /P DrivePath=Enter Drive letter of WINVAYU ^^^(should be X:^^^): >> ..\OfflineUpdater.cmd
echo if [%%DrivePath%%]==[] goto sdisk >> ..\OfflineUpdater.cmd
echo if not "%%DrivePath:~1,1%%"==":" set DrivePath=%%DrivePath%%:>> ..\OfflineUpdater.cmd
echo :start >> ..\OfflineUpdater.cmd
echo if not exist "%%DrivePath%%\Windows\" echo Error! Selected Disk "%%DrivePath%%" doesn't have any Windows installation. ^& pause ^& exit >> ..\OfflineUpdater.cmd
echo .\tools\DriverUpdater\%%PROCESSOR_ARCHITECTURE%%\DriverUpdater.exe -r . -d .\definitions\Desktop\ARM64\Internal\vayu.xml -p %%DrivePath%% >> ..\OfflineUpdater.cmd

echo apps\IPA > filelist_vayu.txt
echo CODE_OF_CONDUCT.md >> filelist_vayu.txt
echo components\ANYSOC\Changelog >> filelist_vayu.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.BASE >> filelist_vayu.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_COMPONENTS >> filelist_vayu.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_RIL >> filelist_vayu.txt
echo components\ANYSOC\Support\Desktop\SUPPORT.DESKTOP.MOBILE_RIL_EXTRAS >> filelist_vayu.txt
echo components\QC8150\Device\DEVICE.SOC_QC8150.VAYU >> filelist_vayu.txt
echo components\QC8150\Device\DEVICE.SOC_QC8150.VAYU_MINIMAL >> filelist_vayu.txt
echo components\QC8150\OEM\OEM.SOC_QC8150.VAYU >> filelist_vayu.txt
echo components\QC8150\Graphics\GRAPHICS.SOC_QC8150.VAYU_DESKTOP >> filelist_vayu.txt
echo components\QC8150\Platform\PLATFORM.SOC_QC8150.BASE >> filelist_vayu.txt
echo components\QC8150\Platform\PLATFORM.SOC_QC8150.BASE_MINIMAL >> filelist_vayu.txt
echo definitions\Desktop\ARM64\Internal\vayu.xml >> filelist_vayu.txt
echo definitions\Desktop\ARM64\PE\vayu.xml >> filelist_vayu.txt
echo tools\DriverUpdater >> filelist_vayu.txt
echo LICENSE.md >> filelist_vayu.txt
echo OfflineUpdater.cmd >> filelist_vayu.txt
echo OnlineUpdater.cmd >> filelist_vayu.txt
echo README.md >> filelist_vayu.txt

cd ..
"%ProgramFiles%\7-Zip\7z.exe" a -tzip ..\Vayu-Drivers-Release\Vayu-Drivers-Desktop.zip @tools\filelist_vayu.txt -scsWIN
"%ProgramFiles%\7-Zip\7z.exe" a -t7z ..\Vayu-Drivers-Release\Vayu-Drivers-Desktop.7z @tools\filelist_vayu.txt -scsWIN
cd tools

del ..\OfflineUpdater.cmd
del ..\OnlineUpdater.cmd
del filelist_vayu.txt
