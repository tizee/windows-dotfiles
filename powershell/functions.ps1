# reload powershell configuration
function psreload() {
 . $profile
}

function Toggle-Proxy {
    param(
        [Parameter(Mandatory)]
        [string]$port = "7890"
    )

    # Define the proxy URLs with the specified port
    $socksProxy = "socks5://127.0.0.1:$port"
    $httpProxy = "http://127.0.0.1:$port"
    $httpsProxy = "http://127.0.0.1:$port"

    # Check if the proxy is currently set
    if ($env:ALL_PROXY -eq $socksProxy -and $env:HTTP_PROXY -eq $httpProxy -and $env:HTTPS_PROXY -eq $httpsProxy) {
        # If the proxy is set, unset it
        Remove-Item Env:\ALL_PROXY
        Remove-Item Env:\HTTP_PROXY
        Remove-Item Env:\HTTPS_PROXY
        Write-Host "Proxy settings have been disabled."
    } else {
        # If the proxy is not set, enable it
        $env:ALL_PROXY = $socksProxy
        $env:HTTP_PROXY = $httpProxy
        $env:HTTPS_PROXY = $httpsProxy
        Write-Host "Proxy settings have been enabled."
        Write-Host "ALL_PROXY: $env:ALL_PROXY"
        Write-Host "HTTP_PROXY: $env:HTTP_PROXY"
        Write-Host "HTTPS_PROXY: $env:HTTPS_PROXY"
    }
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

function Find-Font {
  param(
    [string]$Name,
    [string]$PartialName,
    [switch]$CaseInsensitive,
    [switch]$ListAll
  )

  if ($ListAll) {
      [System.Drawing.FontFamily]::Families | ForEach-Object { $_.Name }
      return
  }


  $fonts = [System.Drawing.FontFamily]::Families 

  if ($Name) {
      if ($CaseInsensitive) {
         $fonts = $fonts | Where-Object {$_.Name -ceq $Name}
      } else {
         $fonts = $fonts | Where-Object {$_.Name -eq $Name}
      }
  }

  if ($PartialName) {
        $fonts = $fonts | Where-Object { $_.Name -like "*$PartialName*" }
  }

  $fonts | ForEach-Object { $_.Name }
}

function Get-MachineId {
    param (
        [ValidateSet("GUID", "UUID", "BIOS", "Product", "ComputerName")]
        [string]$Name = "GUID"
    )

    switch ($Name) {
        "GUID" {
            $machineGuid = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Cryptography').MachineGuid
            Write-Output "Machine GUID: $machineGuid"
        }
        "UUID" {
            $uuid = (Get-WmiObject -Class Win32_ComputerSystemProduct).UUID
            Write-Output "Machine UUID: $uuid"
        }
        "BIOS" {
            $biosSerial = (Get-WmiObject -Class Win32_BIOS).SerialNumber
            Write-Output "BIOS Serial Number: $biosSerial"
        }
        "Product" {
            $productId = (Get-WmiObject -Class SoftwareLicensingService).OA3xOriginalProductKey
            Write-Output "Windows Product ID: $productId"
        }
        "ComputerName" {
            $computerName = $env:COMPUTERNAME
            Write-Output "Computer Name: $computerName"
        }
        default {
            Write-Output "Invalid parameter value. Please choose from: GUID, UUID, BIOS, Product, ComputerName."
        }
    }
}
