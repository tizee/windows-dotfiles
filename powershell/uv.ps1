# default C:\Users\tizee\AppData\Local\uv\cache
$env:UV_CACHE_DIR="F:\uv\cache"

# default C:\Users\tizee\AppData\Roaming\uv\tools
$env:UV_TOOL_DIR="F:\uv\tools"
# uv cache directory
Add-EnvironmentVariable -VariableName "UV_CACHE_DIR" -VariableValue $env:UV_CACHE_DIR -Scope "User"
Add-EnvironmentVariable -VariableName "UV_TOOL_DIR" -VariableValue $env:UV_TOOL_DIR -Scope "User"
