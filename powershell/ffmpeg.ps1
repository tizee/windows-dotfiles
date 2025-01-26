function Fix-YouTubeVideo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$file,

        [Parameter(Mandatory=$true)]
        [string]$output
    )
    
    try {
        $absolutePath = Resolve-Path $file -ErrorAction Stop
        $file = $absolutePath.Path
        Write-Host "Processing file: $file"
        Write-Host "Output file: $output"
        ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i $file -c:v h264_nvenc -preset medium $output
    } catch {
        Write-Error "Invalid file path: $file"
    }
}

function Compress-Video {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$file,

        [Parameter(Mandatory=$true)]
        [string]$output
    )
    
    try {
        $absolutePath = Resolve-Path $file -ErrorAction Stop
        $file = $absolutePath.Path
        Write-Host "Processing file: $file"
        Write-Host "Output file: $output"
        ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i $file -c:v h264_nvenc -movflags +faststart -preset slow -crf 22 -c:a copy $output
    } catch {
        Write-Error "Invalid file path: $file"
    }
}

function ConvertTo-H265Video {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, HelpMessage = "Path to the input video file.")]
        [string]$InputFileName,

        [Parameter(Mandatory, HelpMessage = "Path to the output H.265 video file.")]
        [string]$OutputFileName,

        [Parameter(HelpMessage = "Desired output frame rate. If not provided, the original frame rate is used.")]
        [int]$Fps
    )

    # Ensure absolute paths
    if (-not (Test-Path $InputFileName)) {
        Write-Error "Input file '$InputFileName' not found."
        return
    }

    $InputFullName = (Resolve-Path -Path $InputFileName -ErrorAction Stop).Path

    if (-not (Test-Path (Split-Path $OutputFileName -Parent))) {
        Write-Error "The directory for the output file does not exist."
        return
    }

    # Check if output file already exists
    if (Test-Path $OutputFileName) {
        $overwrite = Read-Host "Output file '$OutputFullName' already exists. Do you want to overwrite it? (Y/N)"
        if ($overwrite -ne "Y") {
            Write-Warning "Operation cancelled. File exists and overwrite denied."
            return
        }
    }

    # Build FFmpeg command string


    try {
        # Run FFmpeg with the constructed command
	if ($Fps) {
	    & ffmpeg -i $InputFullName -vcodec hevc -map_metadata 0 -vf yadif -crf 20 -preset medium -r $Fps $OutputFileName
	} else {
	    & ffmpeg -i $InputFullName -vcodec hevc -map_metadata 0 -vf yadif -crf 20 -preset medium $OutputFileName
	}

        if ($?) {
            Write-Output "Video compression to H.265 successful. Output saved as '$OutputFileName'."
        } else {
            Write-Error "FFmpeg operation failed. Check the command for errors."
        }
    } catch {
        Write-Error "An unexpected error occurred: $_"
    }
}
