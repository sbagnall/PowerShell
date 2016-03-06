$drive = 'd:'
$data = $drive + '\\data'
$code = $drive + '\\code'
set-location $code

function Prompt {
   [Console]::ResetColor()
   write-host $([char]0x0015) -n -f $([ConsoleColor]::Gray)
   write-host '{' -n -f $([ConsoleColor]::DarkGray)
   write-host (path-prefix (pwd).Path) -n -f $([ConsoleColor]::DarkCyan)
   write-host (shorten-path (pwd).Path) -n -f $([ConsoleColor]::DarkCyan)
   write-host '}' -n -f $([ConsoleColor]::DarkGray)
   return '>'
}

function path-prefix([String] $path) {
   if ($path.Contains($HOME)) {
      return '~'
   }

   if ($path.IndexOf($drive + '\code', [StringComparison]::OrdinalIgnoreCase) -ge 0) {
      return '#'
   }

   if ($path.IndexOf($drive + '\data', [StringComparison]::OrdinalIgnoreCase) -ge 0) {
      return '&'
   }
}

function shorten-path([string] $path) { 
   $loc = $path.Replace($HOME, '')  
   $loc = [System.Text.RegularExpressions.Regex]::Replace($loc, $code, '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
   $loc = [System.Text.RegularExpressions.Regex]::Replace($loc, $data, '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
   # remove prefix for UNC paths 
   $loc = $loc -replace '^[^:]+::', '' 
   # make path shorter like tabs in Vim, 
   # handle paths starting with \\ and . correctly 
   return ($loc -replace '\\(\.?)([^\\]{3})[^\\]*(?=\\)','\$1$2') 
}