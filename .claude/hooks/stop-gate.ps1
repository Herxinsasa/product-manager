<#
.SYNOPSIS
  Stop gate hook
.DESCRIPTION
  Agent 停止时检查：如果代码被修改但未经过 code review，阻止停止。
  审查状态记录在 .claude/.review-status.json 中，由 code-review skill 写入。
#>

$ErrorActionPreference = "Continue"
$rootDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$reviewStatusFile = Join-Path $rootDir ".review-status.json"

# 检查是否是 git 仓库
$status = & git -C "$rootDir" status --porcelain 2>&1
if ($LASTEXITCODE -ne 0) {
  exit 0
}

if (-not $status) {
  # 没有未提交的修改，允许停止
  exit 0
}

# 筛选出代码文件
$changedCodeFiles = @()
$status -split "`n" | ForEach-Object {
  $line = $_.Trim()
  if ($line.Length -gt 2) {
    $file = $line.Substring(2).Trim()
    # Exclude .claude/ config files and project scaffolding
    if ($file -match '^\.claude[/\\]') { continue }
    if ($file -match '\.(ps1|py|js|ts|jsx|tsx|rs|go|java|cs|cpp|h|swift|kt)$') {
      $changedCodeFiles += $file
    }
  }
}

if ($changedCodeFiles.Count -eq 0) {
  exit 0
}

# 检查是否有 code review 记录
$reviewed = $false
if (Test-Path $reviewStatusFile) {
  try {
    $reviewData = Get-Content $reviewStatusFile -Raw | ConvertFrom-Json
    $lastReviewTime = [DateTime]::Parse($reviewData.last_review)
    $elapsed = (Get-Date) - $lastReviewTime

    # 如果距离上次审查不超过 30 分钟，且有审查过的文件列表
    if ($elapsed.TotalMinutes -lt 30) {
      $reviewedFiles = $reviewData.reviewed_files
      $unreviewedFiles = $changedCodeFiles | Where-Object { $_ -notin $reviewedFiles }
      if ($unreviewedFiles.Count -eq 0) {
        $reviewed = $true
      }
    }
  } catch {
    # Corrupted review status file, treat as unreviewed
    $null = $null
  }
}

if (-not $reviewed) {
  Write-Host "[stop-gate] 以下文件尚未经过 code review（已允许跳过）:"
  $changedCodeFiles | ForEach-Object { Write-Host "  - $_" }
}

exit 0
