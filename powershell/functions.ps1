# reload powershell configuration
function psreload() {
 . $profile
}

# Safer link creation with validation
function make-link {
    param(
        [Parameter(Mandatory)][string]$source,
        [Parameter(Mandatory)][string]$link
    )
    # Expand relative source path to absolute path
    if (-not [System.IO.Path]::IsPathRooted($source)) {
        $source = Join-Path -Path (Get-Location).Path -ChildPath $source
    }

    # Expand relative link path to absolute path
    if (-not [System.IO.Path]::IsPathRooted($link)) {
        $link = Join-Path -Path (Get-Location).Path -ChildPath $link
    }
    if (!(Test-Path $source)) {
        Write-Error "Source file does not exist."
        return
    }
    if (Test-Path $link) {
        $choice = Read-Host "Target file already exists. Do you want to overwrite it? (y/n)"
        if ($choice -ne "y") {
            Write-Host "Operation canceled."
            return
        }
	# use https://www.powershellgallery.com/packages/Recycle/1.0.2
        Remove-ItemSafely $link -Force
    }
    New-Item -Path $link -ItemType SymbolicLink -Value $source
    Write-Host "Symbolic link created: $link -> $source"
}

# which command for finding location of an executable command
function which ($tool) {
    Get-Command -Name $tool -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
    # use where from cmd.exe
    # cmd /c where $tool
}

function touch($filename) {
	if($filename -eq $null) {
		throw "No filename"
	}

	if(Test-Path $filename){
		(Get-ChildItem $filename).LastWriteTime = Get-Date
	}
	else {
		 Set-Content $filename -Value $null -Force
	}
}

function Reload-EnvVarUser {
     # Define the registry path for user environment variables
    $registryPath = 'HKCU:\Environment'

    # Get the environment variables from the registry
    $registryVariables = Get-ItemProperty -Path $registryPath

    foreach ($registryVariable in $registryVariables.PSObject.Properties) {
        $variableName = $registryVariable.Name
        $registryValue = $registryVariable.Value

        # Get the current value of the environment variable in the session
        $currentValue = [Environment]::GetEnvironmentVariable($variableName, "User")

        # Check if the value has changed
        if ($currentValue -ne $registryValue) {
            Write-Warning "update $variableName from $currentValue to $registryValue"
            # Update the environment variable in the current session
            [Environment]::SetEnvironmentVariable($variableName, $registryValue, "User")
        }
    }
}
