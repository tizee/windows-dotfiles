# $env:GOPATH="C:\Users\tizee\go"
$env:GOPATH="D:\go"
# $env:GOCACHE="C:\Users\tizee\AppData\Local\go-build"
$env:GOCACHE="D:\go-build"
Add-EnvironmentVariable -VariableName "GOPATH" -VariableValue $env:GOPATH -Scope "User"
Add-EnvironmentVariable -VariableName "GOCACHE" -VariableValue $env:GOCACHE -Scope "User"
# set GOPROXY=https://proxy.golang.org,direct
$env:GO111MODULE="on"
$env:GOPROXY="https://goproxy.io,direct"
Add-EnvironmentVariable -VariableName "GOPROXY" -VariableValue $env:GOPROXY -Scope "User"

