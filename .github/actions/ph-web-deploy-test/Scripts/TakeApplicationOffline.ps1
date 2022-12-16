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
 
  [string[]] $appOfflineArguments = 
 "-verb:sync",
 "-source:contentPath=$contentroot\app_offline.htm",
 "-dest:contentPath=$recycleApp\app_offline.htm,$($remoteArguments)includeAcls='False'",
 "-allowUntrusted",
 "-enableRule:DoNotDeleteRule"
 
 $deployAppOfflineCommand = """$msdeploy"" $appOfflineArguments"
 Write-Host $deployAppOfflineCommand
 $appOfflineResult = cmd.exe /c "$deployAppOfflineCommand"
 Write-Host $appOfflineResult
