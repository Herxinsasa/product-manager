<#
.SYNOPSIS
  Detect feedback signal hook
.DESCRIPTION
  Claude Code：stdin JSON（字段 prompt）。本地验证推荐在同一 PowerShell 会话中：
    & "$PSScriptRoot\detect-feedback-signal.ps1" -UserInput (Get-Content .\hook.json -Raw -Encoding utf8)
  不要用嵌套的 `powershell -File ... -UserInput "<很长 JSON>"`，进程参数解析可能截断。
  管道传入脚本时，顶层 `$input` 可能为空；Claude Code 使用进程 stdin，不依赖 PowerShell 管道。
#>

param([string]$UserInput = "")

$ErrorActionPreference = "Continue"

$rawJson = $UserInput
if ([string]::IsNullOrWhiteSpace($rawJson)) {
  $piped = @($input)
  if ($piped.Count -gt 0) {
    $rawJson = ($piped | ForEach-Object { "$_" }) -join ""
  }
  elseif ([Console]::IsInputRedirected) {
    try {
      if ([Console]::In.Peek() -ne -1) {
        $rawJson = [Console]::In.ReadToEnd()
      }
    } catch {
      $rawJson = ""
    }
  }
}

$promptText = ""
if (-not [string]::IsNullOrWhiteSpace($rawJson)) {
  try {
    $obj = $rawJson | ConvertFrom-Json
    if ($null -ne $obj.prompt) {
      $promptText = [string]$obj.prompt
    }
  } catch {
    $promptText = ""
  }
}

$promptText = $promptText.Trim()
if ([string]::IsNullOrWhiteSpace($promptText)) {
  exit 0
}

$keywords = @{
  "改一下"   = "correction"
  "改成"     = "correction"
  "换成"     = "correction"
  "换一种"   = "correction"
  "不对"     = "correction"
  "错了"     = "correction"
  "不太对"   = "correction"
  "不是"     = "correction"
  "不是这样" = "correction"
  "重新"     = "correction"
  "修改"     = "correction"
  "重写"     = "correction"
  "不好"     = "dissatisfaction"
  "不满意"   = "dissatisfaction"
  "不要"     = "dissatisfaction"
  "不用"     = "dissatisfaction"
  "不行"     = "dissatisfaction"
  "丑"       = "dissatisfaction"
  "太丑"     = "dissatisfaction"
  "难用"     = "dissatisfaction"
  "麻烦"     = "dissatisfaction"
  "应该"     = "preference"
  "更喜欢"   = "preference"
  "最好是"   = "preference"
  "想要"     = "preference"
  "希望"     = "preference"
  "需要"     = "preference"
  "能不能"   = "preference"
  "可不可以" = "preference"
  "建议"     = "suggestion"
  "改进"     = "suggestion"
  "优化"     = "suggestion"
  "简化"     = "suggestion"
  "想法"     = "suggestion"
  "以后"     = "suggestion"
  "记得"     = "preference"
}

$detectedSignals = @()

foreach ($kw in $keywords.Keys) {
  if ($promptText -match [regex]::Escape($kw)) {
    $detectedSignals += @{
      keyword = $kw
      type    = $keywords[$kw]
    }
  }
}

if ($detectedSignals.Count -gt 0) {
  $claudeDir = Split-Path -Parent $PSScriptRoot
  $signalFile = Join-Path $claudeDir "feedback\.signal.tmp"

  $content = @{
    timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ss")
    signals   = @($detectedSignals)
    raw_input = $promptText.Substring(0, [Math]::Min(200, $promptText.Length))
  } | ConvertTo-Json -Compress -Depth 6

  $content | Out-File -FilePath $signalFile -Encoding utf8 -Force

  $signalTypes = ($detectedSignals | ForEach-Object { $_.type } | Select-Object -Unique) -join ", "
  Write-Host "[feedback-signal] 检测到反馈信号 (类型: $signalTypes)，已写入 .signal.tmp"
}

exit 0
