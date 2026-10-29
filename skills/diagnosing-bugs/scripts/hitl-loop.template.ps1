# Human-in-the-loop reproduction loop - Windows-native PowerShell port.
# Copy this file, edit the steps below, and run it.
# The agent runs the script; the user follows prompts in their terminal.
#
# Usage:
#   pwsh -File hitl-loop.template.ps1            # PowerShell 7+
#   powershell.exe -File hitl-loop.template.ps1  # Windows PowerShell 5.1
#
# Unattended run (an agent supplies one line per prompt):
#   @('', 'y', 'boom') | pwsh -NoProfile -File hitl-loop.template.ps1
#   The first empty line is the Enter that ends `step`.
#
# Two helpers:
#   step "<instruction>"          -> show instruction, wait for Enter
#   capture NAME "<question>"     -> show question, read response into NAME
#
# At the end, captured values are printed as KEY=VALUE for the agent to parse.
#
# `capture` prints its value back to the terminal, where the agent reads it,
# so capture observations, and leave signing in to the user as a `step`.
# Each captured value is also available as a script-scope variable ($ERRORED)
# and in the ordered hashtable $Captured['ERRORED'].

$ErrorActionPreference = 'Stop'

$script:Captured = [ordered]@{}

function Read-HitlLine {
  param([Parameter(Mandatory)][string]$Prompt)
  # Redirected input (agent-run, piped answers) cannot use Read-Host,
  # so read the console stream directly; a terminal keeps Read-Host's echo.
  if ([Console]::IsInputRedirected) {
    [Console]::Out.Write($Prompt)
    $line = [Console]::In.ReadLine()
    if ($null -eq $line) {
      throw 'Input ended before the loop completed.'
    }
    [Console]::Out.WriteLine()
    return $line
  }
  return Read-Host $Prompt
}

function step {
  param([Parameter(Mandatory)][string]$Instruction)
  Write-Output ''
  Write-Output ">>> $Instruction"
  [void](Read-HitlLine '    [Enter when done] ')
}

function capture {
  param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$Question
  )
  Write-Output ''
  Write-Output ">>> $Question"
  $answer = Read-HitlLine '    > '
  Set-Variable -Name $Name -Value $answer -Scope Script
  $script:Captured[$Name] = $answer
}

# --- edit below ---------------------------------------------------------

step 'Open the app at http://localhost:3000 and sign in.'

capture ERRORED "Click the 'Export' button. Did it throw an error? (y/n)"

capture ERROR_MSG "Paste the error message (or 'none'):"

# --- edit above ---------------------------------------------------------

Write-Output ''
Write-Output '--- Captured ---'
foreach ($key in $script:Captured.Keys) {
  Write-Output ('{0}={1}' -f $key, $script:Captured[$key])
}
