function databaseBackup($destinationFolder, $portalDatabaseDestination, $oldVersion) {
	echo "=================================================="
	echo "| Backup database folder."
	echo "=================================================="
	echo "Destination folder path          : $destinationFolder"
	echo "Database destination folder path: $portalDatabaseDestination"
	echo "Old version                      : $oldVersion"
	$constructedPath = "$destinationFolder\$portalDatabaseDestination"
	echo "Constructed backup path          : $constructedPath"
	$resolvedBackupPath = resolve-path "$($destinationFolder)"
	$resolvedConstructedPath = resolve-path "$($constructedPath)"
	echo "Resolved destination path        : $resolvedBackupPath"
	echo "Resolved constructed path        : $resolvedConstructedPath"
	$currentDate = date -f yyyyMMdd_HHmmss
	
	
	Add-Type -assembly "system.io.compression.filesystem"
	$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
	if ((test-path "$($resolvedBackupPath)\$($portalDatabaseDestination)_$($oldVersion).zip") -eq $true) {
		[io.compression.zipfile]::CreateFromDirectory("$($resolvedConstructedPath)", "$($resolvedBackupPath)\$($portalDatabaseDestination)_$($oldVersion)_$($currentDate).zip", $compressionLevel, $false)
		generateBackupVersionContentXml "portalDatabaseLatestBackupFile" "$($resolvedBackupPath)\$($portalDatabaseDestination)_$($oldVersion)_$($currentDate).zip"
	} else {
		[io.compression.zipfile]::CreateFromDirectory("$($resolvedConstructedPath)", "$($resolvedBackupPath)\$($portalDatabaseDestination)_$($oldVersion).zip", $compressionLevel, $false)
		generateBackupVersionContentXml "portalDatabaseLatestBackupFile" "$($resolvedBackupPath)\$($portalDatabaseDestination)_$($oldVersion).zip"
	}
}

function reportingBackup($destinationFolder, $portalReportingDestination, $oldVersion) {
	echo "=================================================="
	echo "| Backup reporting folder."
	echo "=================================================="
	echo "Destination folder path          : $destinationFolder"
	echo "Reporting destination folder path: $portalReportingDestination"
	echo "Old version                      : $oldVersion"
	$constructedPath = "$destinationFolder\$portalReportingDestination"
	echo "Constructed backup path          : $constructedPath"
	$resolvedBackupPath = resolve-path "$($destinationFolder)"
	$resolvedConstructedPath = resolve-path "$($constructedPath)"
	echo "Resolved destination path        : $resolvedBackupPath"
	echo "Resolved constructed path        : $resolvedConstructedPath"
	$currentDate = date -f yyyyMMdd_HHmmss
	
	
	Add-Type -assembly "system.io.compression.filesystem"
	$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
	if ((test-path "$($resolvedBackupPath)\$($portalReportingDestination)_$($oldVersion).zip") -eq $true) {
		[io.compression.zipfile]::CreateFromDirectory("$($resolvedConstructedPath)", "$($resolvedBackupPath)\$($portalReportingDestination)_$($oldVersion)_$($currentDate).zip", $compressionLevel, $false)
		generateBackupVersionContentXml "portalReportingLatestBackupFile" "$($resolvedBackupPath)\$($portalReportingDestination)_$($oldVersion)_$($currentDate).zip"
	} else {
		[io.compression.zipfile]::CreateFromDirectory("$($resolvedConstructedPath)", "$($resolvedBackupPath)\$($portalReportingDestination)_$($oldVersion).zip", $compressionLevel, $false)
		generateBackupVersionContentXml "portalReportingLatestBackupFile" "$($resolvedBackupPath)\$($portalReportingDestination)_$($oldVersion).zip"
	}
}

function portalBackup($destinationFolder, $portalPortalDestination, $oldVersion) {
	echo "=================================================="
	echo "| Backup portal folder"
	echo "=================================================="
	echo "Destination folder path          : $destinationFolder"
	echo "Reporting destination folder path: $portalPortalDestination"
	echo "Old version                      : $oldVersion"
	$constructedPath = "$destinationFolder\$portalPortalDestination"
	echo "Constructed backup path          : $constructedPath"
	$resolvedBackupPath = resolve-path "$($destinationFolder)"
	$resolvedConstructedPath = resolve-path "$($constructedPath)"
	echo "Resolved destination path        : $resolvedBackupPath"
	echo "Resolved constructed path        : $resolvedConstructedPath"
	$currentDate = date -f yyyyMMdd_HHmmss
	
	
	Add-Type -assembly "system.io.compression.filesystem"
	$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
	if ((test-path "$($resolvedBackupPath)\$($portalPortalDestination)_$oldVersion.zip") -eq $true) {
		[io.compression.zipfile]::CreateFromDirectory("$($resolvedConstructedPath)", "$($resolvedBackupPath)\$($portalPortalDestination)_$($oldVersion)_$($currentDate).zip", $compressionLevel, $false)
		generateBackupVersionContentXml "portalPortalLatestBackupFile" "$($resolvedBackupPath)\$($portalPortalDestination)_$($oldVersion)_$($currentDate).zip"
	} else {
		[io.compression.zipfile]::CreateFromDirectory("$($resolvedConstructedPath)", "$($resolvedBackupPath)\$($portalPortalDestination)_$($oldVersion).zip", $compressionLevel, $false)
		generateBackupVersionContentXml "portalPortalLatestBackupFile" "$($resolvedBackupPath)\$($portalPortalDestination)_$($oldVersion).zip"
	}
}



function generateBackupVersionBeginXml() {
	$outputLocation = ".\config\backupVersionsConfig.xml"

	echo "Generating $($outputLocation)"
	
	# IMPORTANT: Line[3] is old version, line[1] is new version.
	echo "<?xml version=`"1.0`"?>" > $outputLocation
	echo "<configuration>" >> $outputLocation
	echo "	<backupVariables>" >> $outputLocation
	return
}

function generateBackupVersionContentXml($key, $value) {
	$outputLocation = ".\config\backupVersionsConfig.xml"
	echo "		<add key=`"$($key)`" value=`"$($value)`" />" >> $outputLocation
	return
}

function generateBackupVersionEndXml() {
	$outputLocation = ".\config\backupVersionsConfig.xml"
	echo "	</backupVariables>" >> $outputLocation
	echo "</configuration>" >> $outputLocation
	
	echo "Done!"
	echo ""
	return
}



################################################################################
# SCRIPT START
################################################################################

[xml]$deploymentDateConfigFile = get-content .\config\deploymentDateConfig.xml
[xml]$commonConfigFile = get-content .\config\commonConfig.xml
[xml]$releaseVersionConfigFile = get-content .\config\releaseVersionsConfig.xml
[xml]$enabledComponentsConfigFile = get-content .\config\enabledComponentsConfig.xml

$deploymentDate = $deploymentDateConfigFile.configuration.deploymentDate.add.value					# Deployment date.

$environment = $commonConfigFile.configuration.commonVariables.add[0].value							# Staging or Deployment.
$sourceFolder = $commonConfigFile.configuration.commonVariables.add[1].value							# Where the patch files are located at.
$destinationFolder = $commonConfigFile.configuration.commonVariables.add[2].value					# Where the location of the folder to be patched is at.

$portalDatabaseVariables = $commonConfigFile.configuration.portalDatabaseVariables.add[0].value,	# Source directory where new database files are located.
							$commonConfigFile.configuration.portalDatabaseVariables.add[1].value	# Destination directory where database files are to be copied to.

$portalReportingVariables = $commonConfigFile.configuration.portalReportingVariables.add[0].value,	# Source directory where the new reporting files are located.
							$commonConfigFile.configuration.portalReportingVariables.add[1].value	# Destination directory where reporting files are to be copied to.

$portalPortalVariables = $commonConfigFile.configuration.portalPortalVariables.add[0].value,		# Source directory where the new portal files are located.
							$commonConfigFile.configuration.portalPortalVariables.add[1].value		# Destination directory where portal files are to be copied to.

$oldVersion = $releaseVersionConfigFile.configuration.versionVariables.add[0].value					# Old Version Number
$newVersion = $releaseVersionConfigFile.configuration.versionVariables.add[1].value					# New Version Number

$isDatabase = $enabledComponentsConfigFile.configuration.enabledComponentsVariables.add[0].value	# Is database component enabled
$isReporting = $enabledComponentsConfigFile.configuration.enabledComponentsVariables.add[1].value	# Is reporting component enabled
$isPortal = $enabledComponentsConfigFile.configuration.enabledComponentsVariables.add[2].value		# Is portal component enabled

generateBackupVersionBeginXml

if($isDatabase -eq $true) {
	databaseBackup $destinationFolder $portalDatabaseVariables[1] $oldVersion
} else {
	generateBackupVersionContentXml "portalReportingLatestReportingFile" ""
}

if($isReporting -eq $true) {
	reportingBackup $destinationFolder $portalReportingVariables[1] $oldVersion
} else {
	generateBackupVersionContentXml "portalReportingLatestBackupFile" ""
}

if($isPortal -eq $true) {
	portalBackup $destinationFolder $portalPortalVariables[1] $oldVersion
} else {
	generateBackupVersionContentXml "portalPortalLatestBackupFile" ""
}

generateBackupVersionEndXml








