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
