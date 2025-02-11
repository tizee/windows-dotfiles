if (-not (Get-Command llm -ErrorAction SilentlyContinue)) {
    Write-Error "llm not installed" -ErrorAction Stop
    exit 1
}
# python llm cli
$env:LLM_USER_PATH="E:\AI-models\io.datasette.llm"
$env:DEEPSEEK_API_KEY = (Get-Content $env:LLM_USER_PATH\keys.json -Raw | jq ".deepseek" -r)
$env:DOUBAO_API_KEY = (Get-Content $env:LLM_USER_PATH\keys.json -Raw | jq ".doubao" -r)

function ToggleLLMGitCommitMsg {
    if ($env:SKIP_LLM_GITHOOK) {
        # If the environment variable is set, unset it
        Remove-Item Env:\SKIP_LLM_GITHOOK
        Write-Host 'Unset $env:SKIP_LLM_GITHOOK'
    } else {
        # If the environment variable is unset, set it to 1
        $env:SKIP_LLM_GITHOOK=1
        Write-Host 'Set $env:SKIP_LLM_GITHOOK=1'
    }
}
