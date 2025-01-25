if (-not (Get-Command llm -ErrorAction SilentlyContinue)) {
    Write-Error "llm not installed" -ErrorAction Stop
    exit 1
}
# $env:DEEPSEEK_API_KEY = (llm keys get deepseek).Trim()
$env:DEEPSEEK_API_KEY = (Get-Content $env:APPDATA\io.datasette.llm\keys.json -Raw | jq ".deepseek" -r)
# $env:DOUBAO_API_KEY = (llm keys get doubao).Trim()
$env:DOUBAO_API_KEY = (Get-Content $env:APPDATA\io.datasette.llm\keys.json -Raw | jq ".doubao" -r)
