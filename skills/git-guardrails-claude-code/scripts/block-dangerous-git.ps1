<#
.SYNOPSIS
Blocks dangerous git commands before they run - PowerShell port of block-dangerous-git.sh.

.DESCRIPTION
Checks one command string against the same pattern list as the bash hook and
exits 2 with a BLOCKED message on stderr when it matches. Exit 0 allows.

Two ways to call it:
  -Command "<shell command>"   check that literal command
  (no argument)                read a Claude Code hook payload on stdin and
                               check .tool_input.command

Differences from the bash original, both deliberate:
  - Matching is case-insensitive (.NET -match), so `GIT PUSH` is blocked too.
  - An unparseable stdin payload fails closed (exit 2); the bash version
    failed open with an empty command.

.EXAMPLE
pwsh -File block-dangerous-git.ps1 -Command "git push --force"

.EXAMPLE
'{"tool_input":{"command":"git reset --hard"}}' | pwsh -File block-dangerous-git.ps1
#>
[CmdletBinding()]
param(
  [Parameter(Position = 0)][string]$Command
)

$ErrorActionPreference = 'Stop'

$Patterns = @(
  'git push',
  'git reset --hard',
  'git clean -fd',
  'git clean -f',
  'git branch -D',
  'git checkout \.',
  'git restore \.',
  'push --force',
  'reset --hard'
)

if (-not $PSBoundParameters.ContainsKey('Command')) {
  $raw = [Console]::In.ReadToEnd()
  if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
  try {
    $Command = ($raw | ConvertFrom-Json).tool_input.command
  } catch {
    [Console]::Error.WriteLine("BLOCKED: hook payload could not be parsed ($($_.Exception.Message)); failing closed.")
    exit 2
  }
}

if ([string]::IsNullOrWhiteSpace($Command)) { exit 0 }

foreach ($pattern in $Patterns) {
  if ($Command -match $pattern) {
    [Console]::Error.WriteLine("BLOCKED: '$Command' matches dangerous pattern '$pattern'. The user has prevented you from doing this.")
    exit 2
  }
}

exit 0
