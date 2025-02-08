function Download-Ytb {
  <#
  .SYNOPSIS
  Downloads YouTube videos in 1080p with best audio quality using yt-dlp.

  .DESCRIPTION
  This function checks if yt-dlp is installed, then downloads a YouTube video or playlist
  in 1080p resolution with the best available audio quality.

  .PARAMETER VideoUrl
  The URL of the YouTube video or playlist.

  .PARAMETER Playlist
  A switch parameter indicating whether the URL is a playlist. If present, the entire playlist will be downloaded.

  .EXAMPLE
  Download-Ytb -VideoUrl "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  Downloads the single video with the specified URL.

  .EXAMPLE
  Download-Ytb -VideoUrl "https://www.youtube.com/watch?v=dQw4w9WgXcQ&list=PLE0hg-LdSfycrpTtMImPSqFLle4yYNzWD" -Playlist
  Downloads the entire playlist with the specified URL.
  #>
  param (
    [string]$VideoUrl,  # The URL of the YouTube video or playlist
    [switch]$Playlist   # Flag to indicate if the URL is a playlist
  )

  # Check if yt-dlp is installed
  if (Get-Command yt-dlp -ErrorAction SilentlyContinue) {
    # Determine whether to include the playlist argument
    $playlist_arg = if ($Playlist) { "--yes-playlist" } else { "" }

    # Construct the yt-dlp command
    $yt_dlp_command = "yt-dlp --no-mtime $playlist_arg --audio-format best --format `"bestvideo[height=1080]+bestaudio/best[height<=1080]/best`" --merge-output-format mp4 $VideoUrl"

    # Execute the yt-dlp command
    Invoke-Expression $yt_dlp_command
  } else {
    # Display an error message if yt-dlp is not installed
    Write-Error "yt-dlp is not installed. Please install it before using this function."
  }
}

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
