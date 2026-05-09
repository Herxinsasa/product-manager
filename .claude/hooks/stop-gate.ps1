<#
.SYNOPSIS
  Stop gate hook（Claude Code Stop）
.DESCRIPTION
  stdin JSON（含 stop_hook_active）；若存在未审查代码变更则 stdout 输出 {"decision":"block","reason":"..."}。
  审查文件：`.claude/.review-status.json`。stop_hook_active 为 true 时放行以免死循环。
  参考：https://docs.claude.com/en/docs/claude-code/hooks#stop
#>

$ErrorActionPreference = "Continue"
$rootDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$claudeDir = Split-Path -Parent $PSScriptRoot
$reviewStatusFile = Join-Path $claudeDir ".review-status.json"

$stdinRaw = ""
$piped = @($input)
if ($piped.Count -gt 0) {
  $stdinRaw = ($piped | ForEach-Object { "$_" }) -join ""
}
elseif ([Console]::IsInputRedirected) {
  try {
    if ([Console]::In.Peek() -ne -1) {
      $stdinRaw = [Console]::In.ReadToEnd()
    }
  } catch {
    $stdinRaw = ""
  }
}

$stopHookActive = $false
if (-not [string]::IsNullOrWhiteSpace($stdinRaw)) {
  try {
    $hookIn = $stdinRaw | ConvertFrom-Json
    if ($null -ne $hookIn.stop_hook_active -and [bool]$hookIn.stop_hook_active) {
      $stopHookActive = $true
    }
  } catch {
    $stopHookActive = $false
  }
}

if ($stopHookActive) {
  exit 0
}

$status = & git -C "$rootDir" status --porcelain 2>&1
if ($LASTEXITCODE -ne 0) {
  exit 0
}

if (-not $status) {
  exit 0
}

$changedCodeFiles = @()
foreach ($lineRaw in ($status -split "`n")) {
  $line = $lineRaw.Trim()
  if ($line.Length -le 2) { continue }
  $file = $line.Substring(2).Trim()
  if ($file -match '^\.claude[/\\]') { continue }
  if ($file -match '\.(ps1|py|js|ts|jsx|tsx|rs|go|java|cs|cpp|h|swift|kt)$') {
    $changedCodeFiles += $file
  }
}

if ($changedCodeFiles.Count -eq 0) {
  exit 0
}

$reviewed = $false
if (Test-Path $reviewStatusFile) {
  try {
    $reviewData = Get-Content $reviewStatusFile -Raw | ConvertFrom-Json
    $lastReviewTime = [DateTime]::Parse($reviewData.last_review)
    $elapsed = (Get-Date) - $lastReviewTime

    if ($elapsed.TotalMinutes -lt 30) {
      $reviewedFiles = @($reviewData.reviewed_files)
      $unreviewedFiles = $changedCodeFiles | Where-Object { $_ -notin $reviewedFiles }
      if ($unreviewedFiles.Count -eq 0) {
        $reviewed = $true
      }
    }
  } catch {
    $reviewed = $false
  }
}

if ($reviewed) {
  exit 0
}

$preview = ($changedCodeFiles | Select-Object -First 10) -join ", "
$suffix = ""
if ($changedCodeFiles.Count -gt 10) {
  $suffix = " （另有 $($changedCodeFiles.Count - 10) 个文件）"
}
$reason = "存在未审查的代码变更，请先完成 code review 或更新 .claude/.review-status.json。文件示例：$preview$suffix"
$payload = @{ decision = "block"; reason = $reason } | ConvertTo-Json -Compress -Depth 5
[Console]::Out.WriteLine($payload)
exit 0
