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
 $contentPath = Join-Path(Join-Path $directory $baseName) $source
 $contentroot = $directory + $baseName

 $remoteArguments = "computerName='${computerNameArgument}',userName='${username}',password='${password}',authType='Basic',"

 [string[]] $arguments = 
 "-verb:sync",
 "-source:package=${contentPath}\${fileName}",
 "-dest:auto,$($remoteArguments)includeAcls='False'",
 "-allowUntrusted",
 "-setParam:'IIS Web Application Name'='${recycleApp}'",
 "-enableRule:DoNotDeleteRule"

 if ($paramFile){
    $arguments += "-setParamFile:${contentPath}\${paramFile}"
 }
 
  [string[]] $appOfflineArguments = 
 "-verb:sync",
 "-source:contentPath=$contentroot\app_offline.template.htm",
 "-dest:contentPath=$recycleApp\App_offline.htm",
 "-allowUntrusted",
 "-enableRule:DoNotDeleteRule"
 
   [string[]] $appOfflineDeleteArguments = 
 "-verb:delete",
 "-dest:contentPath=$recycleApp\App_offline.htm",
 "-allowUntrusted"
 
 $deployAppOfflineCommand = """$msdeploy"" $appOfflineArguments"
 Write-Host $deployAppOfflineCommand
 $appOfflineResult = cmd.exe /c "$deployAppOfflineCommand"
 Write-Host $appOfflineResult
 
  $fullCommand = """$msdeploy"" $arguments"
 Write-Host $fullCommand
 
 $result = cmd.exe /c "$fullCommand"
 
 Write-Host $result
 
  $deleteAppOfflineCommand = """$msdeploy"" $appOfflineDeleteArguments"
 Write-Host $deleteAppOfflineCommand
 $deleteAppOfflineResult = cmd.exe /c "$deleteAppOfflineCommand"
 Write-Host $deleteAppOfflineResult
