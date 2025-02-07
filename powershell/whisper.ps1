$env:WHISPER_MODEL="E:\AI-models\whisper\models\ggml-large-v3.bin"

# huggingface
Add-EnvironmentVariable -VariableName "HF_HOME" -VariableValue "E:\HuggingfaceCache" -Scope "User"
Add-EnvironmentVariable -VariableName "HF_ENDPOINT" -VariableValue "https://huggingface.co" -Scope "User"
Add-EnvironmentVariable -VariableName "TORCH_HOME" -VariableValue "E:\TorchHome" -Scope "User"
$env:HF_HOME="E:\HuggingfaceCache"
# mirror https://hf-mirror.com
# official https://huggingface.co
$env:HF_ENDPOINT="https://huggingface.co"

# pytorch
$env:TORCH_HOME="E:\TorchHome"

# Generate lyrics/subtitles using Whisper
function Generate-WhisperSubtitles {
    param (
        [string]$Language,
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
function Generate-WhisperXSubtitles {
    param (
        [Parameter(Mandatory=$true, HelpMessage="The language of audio file(en, fr, de, es, it, ja, zh, nl, uk, pt)")]
        [string]$Language,
        [string]$InputFile,
        [string]$OutputDirectory
    )

    $absolutePath = Resolve-Path -Path $InputFile -ErrorAction SilentlyContinue
    if ($absolutePath) {
        $InputFile = $absolutePath.Path
        $OutputDirectory = Join-Path -Path (Get-Location) -ChildPath $OutputDirectory
        Write-Host "WAV file: $InputFile"
        Write-Host "Output directory: $OutputDirectory"
        conda activate whisperx
        whisperx --language $Language --output_format srt --output_dir $OutputDirectory --compute_type float32 --highlight_words True --model large-v3 --model_dir $env:HF_HOME --chunk_size 4 --device cuda $InputFile
    }
    else {
        Write-Error "Invalid file path: $InputFile"
        return
    }
}

# Extract audio file and convert to format supported by Whisper models
function ConvertTo-WhisperWav {
    param (
        [string]$InputFile,
        [string]$OutputFile
    )

    $absolutePath = Resolve-Path -Path $InputFile -ErrorAction SilentlyContinue
    if ($absolutePath) {
        $InputFile = $absolutePath.Path
        $OutputFile = Join-Path -Path (Get-Location) -ChildPath $OutputFile
        Write-Host "Input file: $InputFile"
        Write-Host "WAV file: $OutputFile.wav"
        ffmpeg -hwaccel cuda -i $InputFile -acodec pcm_s16le -ac 1 -ar 16000 "$OutputFile.wav"
    }
    else {
        Write-Error "Invalid file path: $InputFile"
        return
    }
}
