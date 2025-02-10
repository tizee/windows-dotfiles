function ConvertVideo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, HelpMessage = "Path to the input video file.")]
        [string]$file,

        [Parameter(Mandatory, HelpMessage = "Path to the output H.265(hevc)/H.264 video file.")]
        [string]$output,

        [ValidateSet("h264", "h265")]
        [string]$format="h264",

        [ValidateSet("ultrafast", "superfast", "veryfast", "faster", "fast", "medium", "slow", "slower", "veryslow")]
        [string]$quality = "medium"
    )
    $absolutePath = Resolve-Path $file -ErrorAction Stop
    $file = $absolutePath.Path
    Write-Host "Processing file: $file"
    Write-Host "Output file: $output"

    # Check if output file already exists
    if (Test-Path $output) {
        $overwrite = Read-Host "Output file '$output' already exists. Do you want to overwrite it? (Y/N)"
        if ($overwrite -ne "Y") {
            Write-Warning "Operation cancelled. File exists and overwrite denied."
            return
        }
    }

    # check CUDA
    $cudaAvailable = $false
    try {
        $cudaInfo = ffmpeg -hide_banner -hwaccels 2>&1
        if ($cudaInfo -match "cuda") {
            $cudaAvailable = $true
        }
    } catch {
        Write-Warning "Failed to check CUDA availability. Falling back to software encoding."
    }

    $codec = ""
    if ($cudaAvailable) {
      $codec = "h264"
      if ($format -match "h265")
      {
          $codec = "hevc"
      }
      $codec = $codec + "_nvenc"
    } else {
      $codec = "264"
      if ($format -match "h265")
      {
          $codec = "265"
      }
      $codec = "libx" + $codec
    }

    if ($cudaAvailable) {
        Write-Host "Using CUDA hardware acceleration."
        # hardware encode
        try {
            ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i $file -c:v $codec -preset $quality $output
        } catch {
            Write-Warning "Hardware encoding failed. Falling back to software encoding."
            # fallback to software encode
            ffmpeg -i $file -c:v $codec -preset $quality $output
        }
    } else {
        Write-Host "CUDA hardware acceleration not available. Using software encoding."
        # software encode & transcode to h264 (for example, webm -> h264 mp4)
        ffmpeg -i $file -c:v $codec -preset $quality $output
    }
}

function Compress-Video {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$file,

        [Parameter(Mandatory=$true)]
        [string]$output,

        [ValidateSet("ultrafast", "superfast", "veryfast", "faster", "fast", "medium", "slow", "slower", "veryslow")]
        [string]$quality = "slow"
    )
    
    try {
        $absolutePath = Resolve-Path $file -ErrorAction Stop
        $file = $absolutePath.Path
        Write-Host "Processing file: $file"
        Write-Host "Output file: $output"
        ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i $file -c:v h264_nvenc -movflags +faststart -preset $quality -crf 22 -c:a copy $output
    } catch {
        Write-Error "Invalid file path: $file"
    }
}

function RenderSubtitle {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, HelpMessage = "Path to the input video file.")]
        [string]$file,

        [Parameter(Mandatory, HelpMessage = "Path to the source lang subtitle file")]
        [string]$SRC_SRT = "src.srt",

        [Parameter(Mandatory, HelpMessage = "Path to the translated lang subtitle file")]
        [string]$TRANS_SRT = "trans.srt",

        [Parameter(HelpMessage = "video width")]
        [int]$TARGET_WIDTH = 1920,

        [Parameter(HelpMessage = "video height")]
        [int]$TARGET_HEIGHT = 1080,

        [Parameter(Mandatory, HelpMessage = "Path to the output H.265(hevc)/H.264 video file.")]
        [string]$output,

        [ValidateSet("ultrafast", "superfast", "veryfast", "faster", "fast", "medium", "slow", "slower", "veryslow")]
        [string]$quality = "medium"
    )
    $absolutePath = Resolve-Path $file -ErrorAction Stop
    $file = $absolutePath.Path
    Write-Host "Processing file: $file"
    Write-Host "Output file: $output"

    $SRC_FONT_COLOR = '&HFFFFFF'
    $SRC_OUTLINE_COLOR = '&H000000'
    $SRC_OUTLINE_WIDTH = 1
    $SRC_SHADOW_COLOR = '&H80000000'
    $TRANS_FONT_COLOR = '&H00FFFE'
    $TRANS_OUTLINE_COLOR = '&H000000'
    $TRANS_OUTLINE_WIDTH = 1 
    $TRANS_BACK_COLOR = '&H33000000'
    $TRANS_BORDER_STYLE = 1

    $SRC_FONT_SIZE = 15
    $TRANS_FONT_SIZE = 17
    $FONT_NAME = 'Arial'
    $TRANS_FONT_NAME = 'LXGW WenKai'

$filterGraph = @"
scale=${TARGET_WIDTH}:${TARGET_HEIGHT}:force_original_aspect_ratio=decrease,
pad=${TARGET_WIDTH}:${TARGET_HEIGHT}:(ow-iw)/2:(oh-ih)/2,
subtitles=${SRC_SRT}:force_style='FontSize=${SRC_FONT_SIZE},FontName=${FONT_NAME},PrimaryColour=${SRC_FONT_COLOR},OutlineColour=${SRC_OUTLINE_COLOR},OutlineWidth=${SRC_OUTLINE_WIDTH}, ShadowColour=${SRC_SHADOW_COLOR},BorderStyle=1',
subtitles=${TRANS_SRT}:force_style='FontSize=${TRANS_FONT_SIZE},FontName=${TRANS_FONT_NAME}, PrimaryColour=${TRANS_FONT_COLOR},OutlineColour=${TRANS_OUTLINE_COLOR},OutlineWidth=${TRANS_OUTLINE_WIDTH}, BackColour=${TRANS_BACK_COLOR},Alignment=2,MarginV=27,ShadowColour=${SRC_SHADOW_COLOR},BorderStyle=${TRANS_BORDER_STYLE}'
"@
    Write-Host "filterGraph: $filterGraph"


    # Check if output file already exists
    if (Test-Path $output) {
        $overwrite = Read-Host "Output file '$output' already exists. Do you want to overwrite it? (Y/N)"
        if ($overwrite -ne "Y") {
            Write-Warning "Operation cancelled. File exists and overwrite denied."
            return
        }
    }

    # check CUDA
    $cudaAvailable = $false
    try {
        $cudaInfo = ffmpeg -hide_banner -hwaccels 2>&1
        if ($cudaInfo -match "cuda") {
            $cudaAvailable = $true
        }
    } catch {
        Write-Warning "Failed to check CUDA availability. Falling back to software encoding."
    }

    if ($cudaAvailable) {
      try {
          ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i $file -c:v h264_nvenc -vf "$filterGraph" -preset $quality $output
        }
        catch {
            Write-Warning "Hardware encoding failed. Falling back to software encoding."
          ffmpeg -i $file -c:v libx264 -vf "$filterGraph" -preset $quality $output
          }
    } else {
          Write-Warning "Falling back to software encoding."
          ffmpeg -i $file -c:v libx264 -vf "$filterGraph" -preset $quality $output
    }
}
