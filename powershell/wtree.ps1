# Define the path to your wtree.exe
$wtreePath = "E:\Miniconda3\Scripts\wtree.exe"

# Function to call wtree.exe with arguments
function Wtree {
    param (
        [string]$directory = (Get-Location).Path,
        [string[]]$exclude = @(".git"),
        [int]$depth,
        [switch]$all
    )

    # Build the argument list for wtree.exe
    $arguments = @()

    if ($directory) {
        $arguments += $directory
    }

    if ($exclude) {
        $arguments += "--exclude"
        $arguments += $exclude
    }

    if ($depth) {
        $arguments += "--depth"
        $arguments += $depth
    }

    if ($all) {
        $arguments += "--all"
    }

    # Call wtree.exe with the arguments
    & $wtreePath @arguments
}
