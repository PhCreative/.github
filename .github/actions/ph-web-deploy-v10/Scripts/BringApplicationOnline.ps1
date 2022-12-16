param
 (
   [string]$source,
   [string]$recycleApp,
   [string]$computerName,
   [string]$username,
   [string]$password,
   [string]$paramFile,
   [string]$fileName
 )

 $msdeploy = "C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\msdeploy.exe";

 $computerNameArgument = $computerName + '/MsDeploy.axd?site=' + $recycleApp
 
 $directory = Split-Path -Path (Get-Location) -Parent
 $baseName = (Get-Item $directory).BaseName
 $contentroot = $directory + '\' + $baseName

 $remoteArguments = "computerName='${computerNameArgument}',userName='${username}',password='${password}',authType='Basic',"
 
   [string[]] $appOfflineDeleteArguments = 
 "-verb:delete",
 "-dest:contentPath=$recycleApp\App_offline.htm,$($remoteArguments)includeAcls='False'",
 "-allowUntrusted"
 
  $deleteAppOfflineCommand = """$msdeploy"" $appOfflineDeleteArguments"
 Write-Host $deleteAppOfflineCommand
 $deleteAppOfflineResult = cmd.exe /c "$deleteAppOfflineCommand"
 Write-Host $deleteAppOfflineResult
