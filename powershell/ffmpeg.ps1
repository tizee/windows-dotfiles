function fix_ytb_video($file, $output){
$absolutePath = Resolve-Path $file -ErrorAction SilentlyContinue
if ($absolutePath) {
	$file = $absolutePath.Path
	$output = Join-Path -Path (Get-Location) -ChildPath $output
	Write-Host "file: $file"
	Write-Host "output dir: $output"
	ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i $file -c:v h264_nvenc -preset medium $output
    }
    else {
	Write-Error "Invalid file path: $file"
	return
    }
}

function compress_video($file, $output)
{
	$absolutePath = Resolve-Path $file -ErrorAction SilentlyContinue
	if ($absolutePath) {
		$file = $absolutePath.Path
		$output = Join-Path -Path (Get-Location) -ChildPath $output
		Write-Host "file: $file"
		Write-Host "output dir: $output"
		ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i $file -c:v h264_nvenc -movflags +faststart  -preset slow -crf 22 -c:a copy $output
	    }
	    else {
		Write-Error "Invalid file path: $file"
		return
	    }
}
