# generate lyrics/subtitles using whisper
function whis($lang, $file, $output) {
	$absolutePath = Resolve-Path $file -ErrorAction SilentlyContinue
        if ($absolutePath) {
		$file = $absolutePath.Path
		$output = Join-Path -Path (Get-Location) -ChildPath $output
		Write-Host "wav file: $file"
		Write-Host "srt file: $output"
		whisper -l $lang -m E:\AI-models\whisper\models\ggml-large-v3.bin -f $file -osrt -of $output
	    }
	    else {
		Write-Error "Invalid file path: $file"
		return
	    }
}

# generate lyrics/subtitles using whisperx
function whisx($lang, $file, $output_dir) {
	$absolutePath = Resolve-Path $file -ErrorAction SilentlyContinue
        if ($absolutePath) {
		$file = $absolutePath.Path
		$output = Join-Path -Path (Get-Location) -ChildPath $output
		Write-Host "wav file: $file"
		Write-Host "output dir: $output"
		conda activate whisperx
		whisperx --language $lang --output_format srt --output_dir $output_dir --compute_type float32 --highlight_words True --model large-v3 --model_dir E:\HuggingfaceCache --chunk_size 4 --device cuda $file
	    }
	    else {
		Write-Error "Invalid file path: $file"
		return
	    }
}

# extract audio file and convert to format supported by whisper models
function gen_whisper_wav($file, $output) {
	$absolutePath = Resolve-Path $file -ErrorAction SilentlyContinue
        if ($absolutePath) {
		$file = $absolutePath.Path
		$output = Join-Path -Path (Get-Location) -ChildPath $output
		Write-Host "input file: $file"
		Write-Host "wav file: $output.wav"
		ffmpeg -hwaccel cuda -i $file -acodec pcm_s16le -ac 1 -ar 16000 "$output.wav"
	    }
	    else {
		Write-Error "Invalid file path: $file"
		return
	    }
}

