function Get-BluetoothRegistry {
  # Retrieve connected Bluetooth devices with a status of "OK"
$btDevices = Get-PnpDevice -Class Bluetooth | Where-Object { $_.Status -eq 'OK' }

if ($btDevices.Count -eq 0) {
    Write-Host "No connected Bluetooth devices found."
    exit
}

foreach ($device in $btDevices) {
    Write-Host "Device: $($device.FriendlyName)"
    Write-Host "Instance ID: $($device.InstanceId)"
    
    # Construct the registry key path based on the Instance ID.
    $regKey = "HKLM\SYSTEM\CurrentControlSet\Enum\$($device.InstanceId)"
    Write-Host "Registry Key Path: $regKey"
    Write-Host "Dumping registry values..."
    
    # Check that the registry key exists before querying it.
    if (Test-Path "Registry::$regKey") {
        # Query the registry recursively
        $regOutput = reg query "$regKey" /s 2>&1
        
        foreach ($line in $regOutput) {
            $trimmedLine = $line.TrimEnd()
            if ($trimmedLine -match "^\s*HKEY") {
                # Lines starting with a registry key path: print as-is.
                Write-Host $trimmedLine
            }
            elseif ($trimmedLine -match "^\s*$") {
                # Skip blank lines.
                continue
            }
            else {
                # Assume this line is a property/value line; indent for clarity.
                Write-Host "    $trimmedLine"
            }
        }
    }
    else {
        Write-Host "Registry key not found: $regKey"
    }
    
    Write-Host ("-" * 60)  # Print a separator line for readability.
}
}
