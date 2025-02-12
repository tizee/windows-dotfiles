$env:WHISPER_MODEL="E:\AI-models\whisper\models\ggml-large-v3.bin"

# huggingface
Add-EnvironmentVariable -VariableName "HF_HOME" -VariableValue "E:\HuggingfaceCache" -Scope "User"
Add-EnvironmentVariable -VariableName "HF_ENDPOINT" -VariableValue "https://huggingface.co" -Scope "User"
$env:HF_HOME="E:\HuggingfaceCache"
$env:HF_HUB="E:\HuggingfaceCache\hub"
# mirror https://hf-mirror.com
# official https://huggingface.co
$env:HF_ENDPOINT="https://huggingface.co"
function HFMirror {
  $env:HF_ENDPOINT="https://hf-mirror.com"
}

# pytorch
$env:TORCH_HOME="E:\TorchHome"
Add-EnvironmentVariable -VariableName "TORCH_HOME" -VariableValue "E:\TorchHome" -Scope "User"

# Generate lyrics/subtitles using Whisper
function Generate-WhisperSubtitles {
    param (
        [ValidateSet("en", "fr", "de", "es", "it", "ja", "zh", "nl", "uk", "pt")]
        [string]$Language="en",
        [string]$InputFile,
        [string]$OutputFile
    )

    $absolutePath = Resolve-Path -Path $InputFile -ErrorAction SilentlyContinue
    if ($absolutePath) {
        $InputFile = $absolutePath.Path
        $OutputFile = Join-Path -Path (Get-Location) -ChildPath $OutputFile
        Write-Host "WAV file: $InputFile"
        Write-Host "SRT file: $OutputFile"
        whisper -l $Language -m $env:WHISPER_MODEL -f $InputFile -osrt -of $OutputFile
    }
    else {
        Write-Error "Invalid file path: $InputFile"
        return
    }
}

# Generate lyrics/subtitles using WhisperX
# version 3.3.1
function Generate-WhisperXSubtitles {
    param (
        [ValidateSet("en", "fr", "de", "es", "it", "ja", "zh", "nl", "uk", "pt")]
        [string]$Language="en",
        [string]$InputFile,
        [string]$OutputDirectory,
        [ValidateSet("tiny.en", "tiny", "base.en", "base", "small.en", "small", "medium.en", "medium", "large-v1", "large-v2", "large-v3", "large", "distil-large-v2", "distil-medium.en", "distil-small.en", "distil-large-v3", "large-v3-turbo", "turbo")]
        [string]$model="distil-large-v3"
    )

    $absolutePath = Resolve-Path -Path $InputFile -ErrorAction SilentlyContinue
    if ($absolutePath) {
        $InputFile = $absolutePath.Path
        $OutputDirectory = Join-Path -Path (Get-Location) -ChildPath $OutputDirectory
        Write-Host "Input wav file: $InputFile"
        Write-Host "Output directory: $OutputDirectory"
        conda activate whisperx
        # $model = "deepdml/faster-whisper-large-v3-turbo-ct2"
        whisperx --language $Language --output_format srt --output_dir $OutputDirectory --compute_type float32 --highlight_words True --model $model  --model_dir $env:HF_HUB --chunk_size 4 --device cuda $InputFile --print_progress True
    }
    else {
        Write-Error "Invalid file path: $InputFile"
        Write-Error "Invalid file path: $absolutePath"
        return
    }
}

# Extract audio file and convert to format supported by Whisper models
function Extract-WhisperWav {
    param (
        [string]$InputFile,
        [string]$OutputFile
    )

    $absolutePath = Resolve-Path -Path $InputFile -ErrorAction SilentlyContinue
    if ($absolutePath) {
        $InputFile = $absolutePath.Path
        Write-Host "Input file: $InputFile"
        ffmpeg -hide_banner -hwaccel cuda -i $InputFile -acodec pcm_s16le -ac 1 -ar 16000 -af aresample=async=1 "$OutputFile.wav"
        Write-Host "WAV file: $OutputFile.wav"
    }
    else {
        Write-Error "Invalid file path: $InputFile"
        return
    }
}

function Generate-SubtitlesFromVideo {
    param (
        [ValidateSet("en", "fr", "de", "es", "it", "ja", "zh", "nl", "uk", "pt")]
        [string]$Language = "en",
        [Parameter(Mandatory=$true)]
        [string]$InputFile,
        [Parameter(Mandatory=$true)]
        [string]$OutputDirectory
    )

    if (-not (Test-Path -Path $InputFile)) {
        Write-Error "Input file does not exist: $InputFile"
        return
    }
    if (-not (Test-Path -Path $OutputDirectory)) {
        Write-Error "Output directory does not exist: $OutputDirectory"
        return
    }

    try {
        Extract-WhisperWav -InputFile $InputFile -OutputFile "__output__"
    } catch {
        Write-Error "Failed to extract WAV file: $_"
        return
    }

    try {
        Generate-WhisperXSubtitles -Language $Language -InputFile "__output__.wav" -OutputDirectory $OutputDirectory
        Write-Host "Subtitles generated successfully and saved to: $OutputDirectory"
    } catch {
        Write-Error "Failed to generate subtitles: $_"
        return
    }

}
