$nginxPath = (scoop which nginx) -replace "\\nginx.exe$", ""
Add-EnvironmentVariable -VariableName "NGINX_HOME" -VariableValue $nginxPath -Scope "User"
