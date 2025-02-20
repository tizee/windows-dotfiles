function z {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )
    # Update this path to the location of your zpy executable
    $zScript = "E:\Miniconda3\Scripts\zpy.exe"

    if ($Args.Count -eq 0) {
        Write-Host "Usage: z [--add|--list|-l|other flags and query]" -ForegroundColor Yellow
        return
    }

    # Handle --add mode
    if ($Args[0] -eq "--add") {
        if ($Args.Count -gt 1) {
            & $zScript --add $Args[1] | Out-Null
        }
        else {
            & $zScript --add (Get-Location) | Out-Null
        }
        return
    }

    # Handle list mode (--list or -l)
    if (($Args[0] -eq "--list") -or ($Args[0] -eq "-l")) {
        & $zScript @Args
        return
    }

    # Pass all arguments to the zpy script for query/other flags.
    $result = & $zScript @Args
    $result = $result.Trim()

    # If the result contains newlines, assume it's list output; output it raw.
    if ($result -match "\n") {
        Write-Output $result
        return
    }

    # If no match is found, try to treat the entire query as a directory path.
    if ([string]::IsNullOrEmpty($result) -or $result -eq "not found") {
        $query = $Args -join " "
        if (Test-Path $query -PathType Container) {
            try {
                Set-Location $query
                & $zScript --add (Get-Location) | Out-Null
            }
            catch {
                Write-Host "Failed to change directory to: $query" -ForegroundColor Yellow
            }
        }
        else {
            Write-Host "Not valid path: $query" -ForegroundColor Yellow
        }
    }
    else {
        try {
            Set-Location $result
            & $zScript --add (Get-Location) | Out-Null
        }
        catch {
            Write-Host "Failed to change directory to: $result" -ForegroundColor Yellow
        }
    }
}

# Proxy for Set-Location: hook directory changes to update the z database.
function Set-Location {
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        $Path
    )
    # Use the original Set-Location from Microsoft.PowerShell.Management to avoid recursion.
    Microsoft.PowerShell.Management\Set-Location @PSBoundParameters
    # After a successful directory change, update the history.
    $zScript = "E:\Miniconda3\Scripts\zpy.exe"
    & $zScript --add (Get-Location) | Out-Null
}

# Override the built-in cd by removing any previous alias and re-aliasing it to our new Set-Location.
Remove-Item alias:cd -ErrorAction SilentlyContinue
Set-Alias cd Set-Location
