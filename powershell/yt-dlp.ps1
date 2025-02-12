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
    [string]$browser="firefox",   # make use of brower cookies
    [switch]$Playlist   # Flag to indicate if the URL is a playlist
  )

  # Check if yt-dlp is installed
  if (Get-Command yt-dlp -ErrorAction SilentlyContinue) {
    # Determine whether to include the playlist argument
    $playlist_arg = if ($Playlist) { "--yes-playlist" } else { "" }

    # Construct the yt-dlp command
    $command = "yt-dlp --no-mtime $playlist_arg --audio-format best --format `'bestvideo[height=1080]+bestaudio/best[height<=1080]/best'` --merge-output-format mp4 $VideoUrl --cookies-from-browser $browser"

    Invoke-Expression $command
  } else {
    # Display an error message if yt-dlp is not installed
    Write-Error "yt-dlp is not installed. Please install it before using this function."
  }
}
