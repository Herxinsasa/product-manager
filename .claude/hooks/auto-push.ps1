<#
.SYNOPSIS
  Post-commit auto push hook
.DESCRIPTION
  git commit 成功后自动推送到远程仓库，无需手动 git push。
  如果未配置远程仓库则跳过。

  安装方式：复制到 .git/hooks/post-commit（无扩展名），或设置：
    git config core.hooksPath .claude/hooks
#>

$ErrorActionPreference = "Continue"
$rootDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

$remote = & git -C "$rootDir" remote 2>&1
if (-not $remote) {
  exit 0
}

$branch = & git -C "$rootDir" rev-parse --abbrev-ref HEAD 2>&1
if ($LASTEXITCODE -ne 0) {
  exit 0
}

Write-Host "[auto-push] 自动推送当前分支到 origin/$branch ..."
& git -C "$rootDir" push origin $branch 2>&1 | Out-Host

if ($LASTEXITCODE -eq 0) {
  Write-Host "[auto-push] 推送成功"
} else {
  Write-Host "[auto-push] 推送失败，请手动检查 (git push origin $branch)"
}
exit 0
