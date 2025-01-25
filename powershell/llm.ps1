if (-not (Get-Command llm -ErrorAction SilentlyContinue)) {
    Write-Error "llm not installed" -ErrorAction Stop
    exit 1
}
# $env:DEEPSEEK_API_KEY = (llm keys get deepseek).Trim()
# $env:DOUBAO_API_KEY = (llm keys get doubao).Trim()
