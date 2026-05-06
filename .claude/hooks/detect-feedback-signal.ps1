<#
.SYNOPSIS
  Detect feedback signal hook
.DESCRIPTION
  自动检测用户消息中的修正/不满/偏好关键词。
  检测到后写入 .signal.tmp 文件，提醒主 agent 记录反馈。
  反馈记录是半自动的 —— 系统自动捕捉关键词，用户无需手动说"记下来"。
.PARAMETER UserInput
  用户的输入文本
#>

param([string]$UserInput = "")

$ErrorActionPreference = "Continue"

if ([string]::IsNullOrWhiteSpace($UserInput)) {
  exit 0
}

$keywords = @{
  # 修正类
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
  # 不满类
  "不好"     = "dissatisfaction"
  "不满意"   = "dissatisfaction"
  "不要"     = "dissatisfaction"
  "不用"     = "dissatisfaction"
  "不行"     = "dissatisfaction"
  "丑"       = "dissatisfaction"
  "太丑"     = "dissatisfaction"
  "难用"     = "dissatisfaction"
  "麻烦"     = "dissatisfaction"
  # 偏好类
  "应该"     = "preference"
  "更喜欢"   = "preference"
  "最好是"   = "preference"
  "想要"     = "preference"
  "希望"     = "preference"
  "需要"     = "preference"
  "能不能"   = "preference"
  "可不可以" = "preference"
  # 建议类
  "建议"     = "suggestion"
  "改进"     = "suggestion"
  "优化"     = "suggestion"
  "简化"     = "suggestion"
  "想法"     = "suggestion"
  "以后"     = "suggestion"
  # 偏好类（续）
  "记得"     = "preference"
}

$detectedSignals = @()

foreach ($kw in $keywords.Keys) {
  if ($UserInput -match $kw) {
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
    signals   = $detectedSignals
    raw_input = $UserInput.Substring(0, [Math]::Min(200, $UserInput.Length))
  } | ConvertTo-Json -Compress

  $content | Out-File -FilePath $signalFile -Encoding utf8 -Force

  # 输出提醒，主 agent 会在会话中看到
  $signalTypes = ($detectedSignals | ForEach-Object { $_.type } | Select-Object -Unique) -join ", "
  Write-Host "[feedback-signal] 检测到反馈信号 (类型: $signalTypes)，已写入 .signal.tmp"
}

exit 0
