if (-not (Get-Command llm -ErrorAction SilentlyContinue)) {
    Write-Error "llm not installed" -ErrorAction Stop
    exit 1
}
$env:LLM_USER_PATH="E:\AI-models\io.datasette.llm"
$env:DEEPSEEK_API_KEY = (Get-Content $env:LLM_USER_PATH\keys.json -Raw | jq ".deepseek" -r)
$env:DOUBAO_API_KEY = (Get-Content $env:LLM_USER_PATH\keys.json -Raw | jq ".doubao" -r)
