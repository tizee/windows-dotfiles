# ollama
Add-EnvironmentVariable -VariableName "OLLAMA_HOST" -VariableValue "localhost" -Scope "User"
Add-EnvironmentVariable -VariableName "OLLAMA_MODELS" -VariableValue "E:\Ollama_models" -Scope "User"

# the number of loaded models
Add-EnvironmentVariable -VariableName "OLLAMA_MAX_LOADED_MODELS" -VariableValue 3 -Scope "User"
# Maximum parallel requests at the same time
Add-EnvironmentVariable -VariableName "OLLAMA_NUM_PARALLEL" -VariableValue 4 -Scope "User"
# Maximum queued requests
Add-EnvironmentVariable -VariableName "OLLAMA_MAX_QUEUE" -VariableValue 512 -Scope "User"
