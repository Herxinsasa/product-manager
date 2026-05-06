<#
.SYNOPSIS
  Pre-commit check hook
.DESCRIPTION
  每次 git commit 之前自动运行编译检查，编译不通过直接阻止提交。
  自动检测项目语言，运行对应的编译/检查命令。

  安装方式：复制到 .git/hooks/pre-commit（无扩展名），或设置：
    git config core.hooksPath .claude/hooks
#>

$ErrorActionPreference = "Continue"
$rootDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

$hasPackageJson = Test-Path "$rootDir\package.json"
$hasCsproj      = Get-ChildItem "$rootDir" -Filter "*.csproj" -Recurse -ErrorAction SilentlyContinue
$hasSln         = Get-ChildItem "$rootDir" -Filter "*.sln" -ErrorAction SilentlyContinue
$hasCargoToml   = Test-Path "$rootDir\Cargo.toml"
$hasGoMod       = Test-Path "$rootDir\go.mod"
$hasPyProject   = Test-Path "$rootDir\pyproject.toml" -or (Test-Path "$rootDir\setup.py")

$buildFailed = $false

if ($hasPackageJson) {
  Write-Host "[pre-commit] 检测到 Node.js 项目，运行编译检查..."
  if (Test-Path "$rootDir\node_modules") {
    if (Get-Content "$rootDir\package.json" | Select-String -Pattern '"build"') {
      & npm --prefix "$rootDir" run build 2>&1 | Out-Host
      if ($LASTEXITCODE -ne 0) { $buildFailed = $true }
    } elseif (Get-Content "$rootDir\package.json" | Select-String -Pattern '"typecheck"') {
      & npm --prefix "$rootDir" run typecheck 2>&1 | Out-Host
      if ($LASTEXITCODE -ne 0) { $buildFailed = $true }
    } else {
      & npx --prefix "$rootDir" tsc --noEmit 2>&1 | Out-Host
      if ($LASTEXITCODE -ne 0) { $buildFailed = $true }
    }
  }
} elseif ($hasCargoToml) {
  Write-Host "[pre-commit] 检测到 Rust 项目，运行编译检查..."
  & cargo build --manifest-path "$rootDir\Cargo.toml" 2>&1 | Out-Host
  if ($LASTEXITCODE -ne 0) { $buildFailed = $true }
} elseif ($hasGoMod) {
  Write-Host "[pre-commit] 检测到 Go 项目，运行编译检查..."
  & go build ./... 2>&1 | Out-Host
  if ($LASTEXITCODE -ne 0) { $buildFailed = $true }
} elseif ($hasCsproj -or $hasSln) {
  Write-Host "[pre-commit] 检测到 .NET 项目，运行编译检查..."
  & dotnet build "$rootDir" 2>&1 | Out-Host
  if ($LASTEXITCODE -ne 0) { $buildFailed = $true }
} elseif ($hasPyProject) {
  Write-Host "[pre-commit] 检测到 Python 项目，运行语法检查..."
  & python -m compileall "$rootDir" -q 2>&1 | Out-Host
  if ($LASTEXITCODE -ne 0) { $buildFailed = $true }
} else {
  Write-Host "[pre-commit] 未检测到已知项目类型，跳过编译检查"
}

if ($buildFailed) {
  Write-Host "[pre-commit] 编译检查未通过，提交已阻止。请修复编译错误后重新提交。"
  exit 1
} else {
  Write-Host "[pre-commit] 编译检查通过"
  exit 0
}
