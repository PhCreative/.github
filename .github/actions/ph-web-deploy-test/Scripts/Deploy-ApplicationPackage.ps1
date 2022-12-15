param
 (
   [string]$source,
   [string]$recycleApp,
   [string]$computerName,
   [string]$username,
   [string]$password,
   [string]$paramFile,
   [string]$fileName,
   [string]$configuration
 )

 $msdeploy = "C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\msdeploy.exe";

 $computerNameArgument = $computerName + '/MsDeploy.axd?site=' + $recycleApp
 
 $directory = Split-Path -Path (Get-Location) -Parent
 $baseName = (Get-Item $directory).BaseName
 $contentPath = Join-Path(Join-Path $directory $baseName) $source + "\bin\${$configuration}\net6.0\"

 $remoteArguments = "computerName='${computerNameArgument}',userName='${username}',password='${password}',authType='Basic',"

 [string[]] $arguments = 
 "-verb:sync",
 "-source:contentPath=${contentPath}",
 "-dest:iisApp=$recycleApp,$($remoteArguments)includeAcls='False',appOfflineTemplate='app_offline.template.htm'",
 "-allowUntrusted",
 "-enableRule:AppOffline",
 "-setParam:'IIS Web Application Name'='${recycleApp}'",
 "-enableRule:DoNotDeleteRule"

 if ($paramFile){
    $arguments += "-setParamFile:${contentPath}\${paramFile}"
 }
 
  $fullCommand = """$msdeploy"" $arguments"
 Write-Host $fullCommand
 
 $result = cmd.exe /c "$fullCommand"
 
 Write-Host $result