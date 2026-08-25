## Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
## Install-Module -Name posh-git -Scope CurrentUser -AllowClobber -Force

## Security update
[Net.ServicePointManager]::SecurityProtocol =
[Net.ServicePointManager]::SecurityProtocol -bor
[Net.SecurityProtocolType]::Tls12

# PSReadLine
Set-PSReadLineOption -BellStyle Visual
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -HistorySavePath $Env:USERPROFILE\_PSReadLineHistory

$psreadline = Get-Module PSReadLine
if ($psreadline.Version -gt [version]'2.0.0')
{
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -Colors @{
        Emphasis               = "$([char]0x1b)[1;94m"
        Error                  = "$([char]0x1b)[1;91m"
        ListPredictionSelected = "$([char]0x1b)[48;5;47m"
    }
}

if ($PSVersionTable.PSVersion.Major -lt 7)
{
    # https://superuser.com/questions/593987/change-directory-to-previous-directory-in-powershell
    function custom_cd
    {
        if ($args.Count -eq 0)
        {
            $tmp_path = $Env:USERPROFILE
        } elseif ($args[0] -eq '-')
        {
            $tmp_path = $OLDPWD;
        } else
        {
            $tmp_path = $args[0];
        }
        if ($tmp_path)
        {
            Set-Variable -Name OLDPWD -Value $PWD -Scope global;
            Set-Location $tmp_path;
        }
    }
    Set-Alias cd  custom_cd -Option AllScope
} else
{
    # i.e., pwsh 7.x or greater
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
}

# Git stuff
Import-Module posh-git
$GitPromptSettings.DefaultPromptPrefix.Text = "`nPS "

Function Set-PathVariable {
    # https://www.powershellgallery.com/packages/fscps.tools/1.1.314/content/internal/functions/set-pathvariable.ps1
    param (
        [string]$AddPath,
        [string]$RemovePath,
        [ValidateSet('Process', 'User', 'Machine')]
        [string]$Scope = 'Process'
    )
    $regexPaths = @()
    if ($PSBoundParameters.Keys -contains 'AddPath') {
        $regexPaths += [regex]::Escape($AddPath)
    }

    if ($PSBoundParameters.Keys -contains 'RemovePath') {
        $regexPaths += [regex]::Escape($RemovePath)
    }

    $arrPath = [System.Environment]::GetEnvironmentVariable('PATH', $Scope) -split ';'
    foreach ($path in $regexPaths) {
        $arrPath = $arrPath | Where-Object { $_ -notMatch "^$path\\?" }
    }
    $value = ($arrPath + $addPath) -join ';'
    [System.Environment]::SetEnvironmentVariable('PATH', $value, $Scope)
}

function gitpull
{
    git pull $args
}
function gitpush
{
    git push $args
}
Set-Alias gl gitpull -Force -Option Constant,AllScope
Set-Alias gp gitpush -Force -Option Constant,AllScope
function ga
{
    git add $args
}
function gaa
{
    git add --all $args
}
function gc!
{
    git commit -v --amend $args
}
function gcam
{
    git commit -a -m $args
}
function gcmsg
{
    git commit -m $args
}
function gcp
{
    git commit --patch $args
}
function gd
{
    git diff $args
}
function glog
{
    git log --oneline --decorate --color --graph $args
}
function gpr
{
    git pull --rebase $args
}
function gst
{
    git status $args
}

Set-Alias mydiff $Env:LOCALAPPDATA\Programs\Vim\diff.exe
Set-Alias activate .\.venv\Scripts\activate.ps1
Set-Alias less $Env:LOCALAPPDATA\Programs\Git\usr\bin\less.exe
Set-Alias more less
Set-Alias m less
Set-Alias mygrep $Env:LOCALAPPDATA\Programs\Git\usr\bin\grep.exe
Set-Alias grep mygrep -Force -Option Constant,AllScope
Set-Alias g mygrep
Set-Alias openssl $Env:LOCALAPPDATA\Programs\Git\usr\bin\openssl.exe
Set-Alias diff mydiff -Force -Option Constant,AllScope
function d {
    mydiff -u $args
}

function mycurl
{
    curl.exe --ssl-revoke-best-effort $args
}
Set-Alias curl mycurl -Force -Option Constant,AllScope

function Get-HardLinks
{
    fsutil.exe hardlink list $args
}

function Get-Pass
{
    -join (48..57 + 65..90 + 97..122 | ForEach-Object { [char]$_ } | Get-Random -C 20)
}

function Get-PubIP
{
    (Invoke-WebRequest http://ifconfig.me/ip ).Content
}

function Get-UTC
{
    Get-Date -Format U
}

function dns
{
    Resolve-DnsName -DnsOnly $args
}

function l
{
    Get-ChildItem -Name .*
}

function rmrf
{
    Remove-Item -Recurse -Force $args
}

function ll
{
    Get-ChildItem -Exclude (Get-ChildItem -Name .*)
}

function lla
{
    Get-ChildItem | Sort-Object Length, Name
}

function  vi
{
    vim -u NONE -U NONE
}

function which($name)
{
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function mklink($original, $new)
{
    New-Item -ItemType HardLink -Path $new -Target $original
}
Set-Alias ln mklink

function mkjunction($original, $new)
{
    New-Item -ItemType Junction -Path $new -Target $original
}

function md5sum($fileName)
{
    $hashResult = Get-FileHash -Path $fileName -Algorithm MD5
    Write-Host "$($hashResult.Hash.ToLower())  $fileName"
}

function sha1sum($filename)
{
    $hashResult = Get-FileHash -Path $fileName -Algorithm SHA1
    Write-Host "$($hashResult.Hash.ToLower())  $fileName"
}

function sha256sum($filename)
{
    $hashResult = Get-FileHash -Path $fileName -Algorithm SHA256
    Write-Host "$($hashResult.Hash.ToLower())  $fileName"
}

function sha384sum($filename)
{
    $hashResult = Get-FileHash -Path $fileName -Algorithm SHA384
    Write-Host "$($hashResult.Hash.ToLower())  $fileName"
}

function sha512sum($filename)
{
    $hashResult = Get-FileHash -Path $fileName -Algorithm SHA512
    Write-Host "$($hashResult.Hash.ToLower())  $fileName"
}

function myhistory([int]$Count = 100)
{
    Get-Content -LiteralPath (Get-PSReadLineOption).HistorySavePath | Select-Object -Last $Count -Unique
}
Set-Alias history myhistory -Force -Option Constant, AllScope

function tail
{
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]$FilePath,
        [int]$Lines = 10
    )
    process
    {
        $content = Get-Content $FilePath
        $totalLines = $content.Count
        if ($totalLines -lt $Lines)
        {
            $content
        } else
        {
            $content | Select-Object -Last $Lines
        }
    }
}

function head
{
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]$FilePath,
        [int]$Lines = 10
    )
    process
    {
        $content = Get-Content $FilePath
        $totalLines = $content.Count
        if ($totalLines -lt $Lines)
        {
            $content
        } else
        {
            $content | Select-Object -First $Lines
        }
    }
}

function time
{
    $Command = $MyInvocation.Line -Replace ("^$($MyInvocation.MyCommand) ", "")
    Measure-Command { Invoke-Expression $Command | Out-Default }
}

function cdh
{
    Set-Location $Env:USERPROFILE
}
Set-Alias c   cdh

### these functions were written by AI (ugh)
function wg
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [int]$inputValue
    )
    $SECOND = [math]::floor($inputValue / 256)
    $THIRD = $inputValue % 256
    return "10.$SECOND.$THIRD.0"
}

function 2wg
{
    param (
        [string]$IPAddress
    )
    $Parts = $IPAddress.Split(".")
    if ($Parts.Count -eq 4)
    {
        $INT = [int]$Parts[1] * 256 + [int]$Parts[2]
        return $INT
    } else
    {
        Write-Host "Invalid IP address format."
        return $null
    }
}

function d2b
{
    param (
        [int]$Value
    )
    $BinaryString = [Convert]::ToString($Value, 2)
    Write-Host $BinaryString
}

function d2h
{
    param (
        [int]$Value
    )
    $HexString = "{0:x}" -f $Value
    Write-Host $HexString
}

function d2o
{
    param (
        [int]$Value
    )
    $OctalString = [Convert]::ToString($Value, 8)
    Write-Host $OctalString
}

function h2b
{
    param (
        [string]$HexValue
    )
    $DecimalValue = [Convert]::ToInt32($HexValue, 16)
    $BinaryString = [Convert]::ToString($DecimalValue, 2)
    Write-Host $BinaryString
}

function h2d
{
    param (
        [string]$HexValue
    )
    $DecimalValue = [Convert]::ToInt32($HexValue, 16)
    Write-Host $DecimalValue
}

function h2o
{
    param (
        [string]$HexValue
    )
    $DecimalValue = [Convert]::ToInt32($HexValue, 16)
    $OctalString = [Convert]::ToString($DecimalValue, 8)
    Write-Host $OctalString
}

function o2b
{
    param (
        [string]$OctalValue
    )
    $DecimalValue = [Convert]::ToInt32($OctalValue, 8)
    $BinaryString = [Convert]::ToString($DecimalValue, 2)
    Write-Host $BinaryString
}

function o2d
{
    param (
        [string]$OctalValue
    )
    $DecimalValue = [Convert]::ToInt32($OctalValue, 8)
    Write-Host $DecimalValue
}

function o2h
{
    param (
        [string]$OctalValue
    )
    $DecimalValue = [Convert]::ToInt32($OctalValue, 8)
    $HexadecimalString = "{0:x}" -f $DecimalValue
    Write-Host $HexadecimalString
}

# ascii to ...
function a2b
{
    param (
        [string]$asciiChar
    )
    if ([string]::IsNullOrEmpty($asciiChar) -or $asciiChar.Length -ne 1)
    {
        Write-Host "Input is empty, null, or not a single character."
        return
    }
    $asciiValue = [int][char]$asciiChar
    $binaryString = [Convert]::ToString($asciiValue, 2).PadLeft(8, '0')
    return $binaryString
}

function a2d
{
    param (
        [string]$asciiChar
    )
    if ([string]::IsNullOrEmpty($asciiChar) -or $asciiChar.Length -ne 1)
    {
        Write-Host "Input is empty, null, or not a single character."
        return
    }
    $asciiValue = [int][char]$asciiChar
    return $asciiValue
}

function a2h
{
    param (
        [string]$asciiChar
    )
    if ([string]::IsNullOrEmpty($asciiChar) -or $asciiChar.Length -ne 1)
    {
        Write-Host "Input is empty, null, or not a single character."
        return
    }
    $asciiValue = [int][char]$asciiChar
    $hexString = [Convert]::ToString($asciiValue, 16).ToUpper()
    return $hexString
}

function a2o
{
    param (
        [string]$asciiChar
    )
    if ([string]::IsNullOrEmpty($asciiChar) -or $asciiChar.Length -ne 1)
    {
        Write-Host "Input is empty, null, or not a single character."
        return
    }
    $asciiValue = [int][char]$asciiChar
    $octalString = [Convert]::ToString($asciiValue, 8)
    return $octalString
}

# ... to ascii
function b2a
{
    param (
        [string]$binaryValue
    )
    if ([string]::IsNullOrEmpty($binaryValue))
    {
        Write-Host "Input is empty or null."
        return
    }
    $asciiChar = [char][Convert]::ToInt32($binaryValue, 2)
    return $asciiChar
}

function d2a
{
    param (
        [int]$decimalValue
    )
    $asciiChar = [char]$decimalValue
    return $asciiChar
}

function h2a
{
    param (
        [string]$hexValue
    )
    if ([string]::IsNullOrEmpty($hexValue))
    {
        Write-Host "Input is empty or null."
        return
    }
    $decimalValue = [Convert]::ToInt32($hexValue, 16)
    $asciiChar = [char]$decimalValue
    return $asciiChar
}

function o2a
{
    param (
        [string]$octalValue
    )
    if ([string]::IsNullOrEmpty($octalValue))
    {
        Write-Host "Input is empty or null."
        return
    }
    $decimalValue = [Convert]::ToInt32($octalValue, 8)
    $asciiChar = [char]$decimalValue
    return $asciiChar
}

function Get-OnesComplement
{
    <#
    .SYNOPSIS
    Calculates the ones' complement of a binary number.

    .DESCRIPTION
    Takes a binary string and returns its ones' complement by flipping all bits (0→1, 1→0).

    .PARAMETER BinaryNumber
    A string containing only binary digits (0 and 1).

    .EXAMPLE
    Get-OnesComplement -BinaryNumber "1010"
    Returns: "0101"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidatePattern('^[01]+$', ErrorMessage = "Input must contain only binary digits (0 and 1).")]
        [string]$BinaryNumber
    )

    process
    {
        $onesComplement = -join ($BinaryNumber.ToCharArray() | ForEach-Object {
                if ($_ -eq '0')
                {
                    '1'
                } else
                {
                    '0'
                }
            })

        return $onesComplement
    }
}

function Get-TwosComplement
{
    <#
    .SYNOPSIS
    Calculates the two's complement of a binary number.

    .DESCRIPTION
    Takes a binary string and returns its two's complement by flipping all bits and adding 1.

    .PARAMETER BinaryNumber
    A string containing only binary digits (0 and 1).

    .EXAMPLE
    Get-TwosComplement -BinaryNumber "1010"
    Returns: "0110"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidatePattern('^[01]+$')]
        [string]$BinaryNumber
    )

    process
    {
        # Step 1: Get ones' complement (flip all bits)
        $onesComplement = -join ($BinaryNumber.ToCharArray() | ForEach-Object {
                if ($_ -eq '0')
                {
                    '1'
                } else
                {
                    '0'
                }
            })

        # Step 2: Add 1 to the ones' complement (as binary string addition)
        # $bitWidth = $BinaryNumber.Length
        $carry = 1
        $result = New-Object System.Text.StringBuilder

        for ($i = $onesComplement.Length - 1; $i -ge 0; $i--)
        {
            $bit = [int]$onesComplement[$i].ToString()
            $sum = $bit + $carry

            if ($sum -eq 2)
            {
                [void]$result.Insert(0, '0')
                $carry = 1
            } elseif ($sum -eq 1)
            {
                [void]$result.Insert(0, '1')
                $carry = 0
            } else
            {
                [void]$result.Insert(0, '0')
                $carry = 0
            }
        }

        return $result.ToString()
    }
}

function ConvertTo-DecimalIP
{
    <#
    .SYNOPSIS
    Converts a dotted decimal IP address to a 32-bit decimal integer.

    .DESCRIPTION
    Takes an IPv4 address in dotted decimal notation and converts it to its
    numeric representation using network byte order (big-endian).

    .PARAMETER IPAddress
    A string containing a valid IPv4 address (e.g., "192.168.1.1").

    .EXAMPLE
    ConvertTo-DecimalIP -IPAddress "192.168.1.1"
    Returns: 3232235777

    .EXAMPLE
    "10.0.0.1" | ConvertTo-DecimalIP
    Returns: 167772161
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript({
                if ($_ -match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$')
                {
                    $octets = $_.Split('.')
                    $valid = $true
                    foreach ($octet in $octets)
                    {
                        if ([int]$octet -lt 0 -or [int]$octet -gt 255)
                        {
                            $valid = $false
                            break
                        }
                    }
                    if (-not $valid)
                    {
                        throw "Each octet must be between 0 and 255."
                    }
                    return $true
                } else
                {
                    throw "Invalid IP address format. Must be xxx.xxx.xxx.xxx"
                }
            })]
        [string]$IPAddress
    )

    process
    {
        $octets = $IPAddress.Split('.') | ForEach-Object { [int]$_ }

        # Convert using network byte order (big-endian)
        # Use [uint32] for each octet to avoid signed integer issues
        [uint32]$decimal = ([uint32]$octets[0] -shl 24) -bor
        ([uint32]$octets[1] -shl 16) -bor
        ([uint32]$octets[2] -shl 8) -bor
        ([uint32]$octets[3])

        return $decimal
    }
}

function ConvertTo-HexIP
{
    <#
    .SYNOPSIS
    Converts a dotted decimal IP address to hexadecimal format.

    .DESCRIPTION
    Takes an IPv4 address in dotted decimal notation and converts it to
    hexadecimal representation.

    .PARAMETER IPAddress
    A string containing a valid IPv4 address (e.g., "192.168.1.1").

    .PARAMETER Prefix
    Optional prefix for the hex output (default: "0x").

    .EXAMPLE
    ConvertTo-HexIP -IPAddress "192.168.1.1"
    Returns: "0xC0A80101"

    .EXAMPLE
    ConvertTo-HexIP "255.255.255.255" -Prefix ""
    Returns: "FFFFFFFF"

    .EXAMPLE
    "10.0.0.1" | ConvertTo-HexIP
    Returns: "0x0A000001"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript({
                if ($_ -match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$')
                {
                    $octets = $_.Split('.')
                    $valid = $true
                    foreach ($octet in $octets)
                    {
                        if ([int]$octet -lt 0 -or [int]$octet -gt 255)
                        {
                            $valid = $false
                            break
                        }
                    }
                    if (-not $valid)
                    {
                        throw "Each octet must be between 0 and 255."
                    }
                    return $true
                } else
                {
                    throw "Invalid IP address format. Must be xxx.xxx.xxx.xxx"
                }
            })]
        [string]$IPAddress,

        [Parameter(Mandatory = $false)]
        [string]$Prefix = "0x"
    )

    process
    {
        $octets = $IPAddress.Split('.') | ForEach-Object { [int]$_ }

        # Convert each octet to 2-digit hex and concatenate
        $hexString = ""
        foreach ($octet in $octets)
        {
            $hexString += "{0:X2}" -f $octet
        }

        return "$Prefix$hexString"
    }
}

function ConvertTo-BinaryIP
{
    <#
    .SYNOPSIS
    Converts a dotted decimal IP address to binary format.

    .DESCRIPTION
    Takes an IPv4 address in dotted decimal notation and converts it to
    binary representation. Each octet is converted to 8-bit binary.

    .PARAMETER IPAddress
    A string containing a valid IPv4 address (e.g., "192.168.1.1").

    .PARAMETER Delimiter
    Optional delimiter between octets (default: "."). Use "" for no delimiter.

    .EXAMPLE
    ConvertTo-BinaryIP -IPAddress "192.168.1.1"
    Returns: "11000000.10101000.00000001.00000001"

    .EXAMPLE
    ConvertTo-BinaryIP "255.255.255.0" -Delimiter ""
    Returns: "11111111111111111111111100000000"

    .EXAMPLE
    "10.0.0.1" | ConvertTo-BinaryIP -Delimiter " "
    Returns: "00001010 00000000 00000000 00000001"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript({
                if ($_ -match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$')
                {
                    $octets = $_.Split('.')
                    $valid = $true
                    foreach ($octet in $octets)
                    {
                        if ([int]$octet -lt 0 -or [int]$octet -gt 255)
                        {
                            $valid = $false
                            break
                        }
                    }
                    if (-not $valid)
                    {
                        throw "Each octet must be between 0 and 255."
                    }
                    return $true
                } else
                {
                    throw "Invalid IP address format. Must be xxx.xxx.xxx.xxx"
                }
            })]
        [string]$IPAddress,

        [Parameter(Mandatory = $false)]
        [string]$Delimiter = "."
    )

    process
    {
        $octets = $IPAddress.Split('.') | ForEach-Object { [int]$_ }

        # Convert each octet to 8-bit binary
        $binaryOctets = @()
        foreach ($octet in $octets)
        {
            $binary = [Convert]::ToString($octet, 2).PadLeft(8, '0')
            $binaryOctets += $binary
        }

        return $binaryOctets -join $Delimiter
    }
}

function ConvertTo-MulticastMAC
{
    <#
    .SYNOPSIS
    Converts a multicast IP address to its corresponding multicast MAC address.

    .DESCRIPTION
    Takes an IPv4 multicast address (224.0.0.0 to 239.255.255.255) and converts
    it to the corresponding multicast MAC address using the 01-00-5E prefix and
    the lower 23 bits of the IP address.

    .PARAMETER IPAddress
    A string containing a valid multicast IPv4 address (224.x.x.x to 239.x.x.x).

    .EXAMPLE
    ConvertTo-MulticastMAC -IPAddress "239.255.1.1"
    Returns: "01-00-5E-7F-01-01"

    .EXAMPLE
    "224.0.1.1" | ConvertTo-MulticastMAC
    Returns: "01-00-5E-00-01-01"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript({
                if ($_ -match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$')
                {
                    $octets = $_.Split('.')
                    $valid = $true
                    foreach ($octet in $octets)
                    {
                        if ([int]$octet -lt 0 -or [int]$octet -gt 255)
                        {
                            $valid = $false
                            break
                        }
                    }
                    if (-not $valid)
                    {
                        throw "Each octet must be between 0 and 255."
                    }
                    # Verify it's a multicast IP (224.0.0.0 to 239.255.255.255)
                    if ([int]$octets[0] -lt 224 -or [int]$octets[0] -gt 239)
                    {
                        throw "IP address must be in multicast range (224.0.0.0 to 239.255.255.255)."
                    }
                    return $true
                } else
                {
                    throw "Invalid IP address format. Must be xxx.xxx.xxx.xxx"
                }
            })]
        [string]$IPAddress
    )

    process
    {
        $octets = $IPAddress.Split('.') | ForEach-Object { [int]$_ }

        # Multicast MAC format: 01-00-5E-xx-xx-xx
        # The last 3 octets come from the lower 23 bits of the IP
        # This means: mask the high bit of octet[1] (AND with 0x7F)

        $octet2 = $octets[1] -band 0x7F  # Mask off the high bit (keep lower 7 bits)
        $octet3 = $octets[2]
        $octet4 = $octets[3]

        # Convert to hex with leading zeros
        $mac = "01-00-5E-{0:X2}-{1:X2}-{2:X2}" -f $octet2, $octet3, $octet4

        return $mac
    }
}

function ConvertFrom-DecimalIP
{
    <#
    .SYNOPSIS
    Converts a 32-bit decimal integer to a dotted decimal IP address.

    .DESCRIPTION
    Takes a decimal integer (0 to 4294967295) and converts it to its
    corresponding IPv4 address in dotted decimal notation.

    .PARAMETER Decimal
    A 32-bit unsigned integer representing an IP address (0 to 4294967295).

    .EXAMPLE
    ConvertFrom-DecimalIP -Decimal 3232235777
    Returns: "192.168.1.1"

    .EXAMPLE
    ConvertFrom-DecimalIP 167772161
    Returns: "10.0.0.1"

    .EXAMPLE
    3232235777 | ConvertFrom-DecimalIP
    Returns: "192.168.1.1"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript({
                if ($_ -lt 0 -or $_ -gt 4294967295)
                {
                    throw "Decimal value must be between 0 and 4294967295 (max 32-bit unsigned integer)."
                }
                return $true
            })]
        [long]$Decimal
    )

    process
    {
        # Convert to uint32 to handle large values properly
        [uint32]$value = $Decimal

        # Extract each octet using bit shifting and masking
        $octet1 = ($value -shr 24) -band 0xFF
        $octet2 = ($value -shr 16) -band 0xFF
        $octet3 = ($value -shr 8) -band 0xFF
        $octet4 = $value -band 0xFF

        return "$octet1.$octet2.$octet3.$octet4"
    }
}

function ConvertFrom-HexIP
{
    <#
    .SYNOPSIS
    Converts a hexadecimal value to a dotted decimal IP address.

    .DESCRIPTION
    Takes a hexadecimal string (with or without 0x prefix) and converts it to
    its corresponding IPv4 address in dotted decimal notation.

    .PARAMETER Hexadecimal
    A hexadecimal string representing an IP address (e.g., "C0A80101" or "0xC0A80101").

    .EXAMPLE
    ConvertFrom-HexIP -Hexadecimal "C0A80101"
    Returns: "192.168.1.1"

    .EXAMPLE
    ConvertFrom-HexIP "0x0A000001"
    Returns: "10.0.0.1"

    .EXAMPLE
    "FFFFFFFF" | ConvertFrom-HexIP
    Returns: "255.255.255.255"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript({
                # Remove 0x prefix if present
                $hexValue = $_ -replace '^0x', ''

                if ($hexValue -notmatch '^[0-9A-Fa-f]{1,8}$')
                {
                    throw "Invalid hexadecimal value. Must be 1-8 hex digits, optionally prefixed with '0x'."
                }
                return $true
            })]
        [string]$Hexadecimal
    )

    process
    {
        # Remove 0x prefix if present and pad to 8 digits
        $hexValue = $Hexadecimal -replace '^0x', ''
        $hexValue = $hexValue.PadLeft(8, '0')

        # Extract each octet (2 hex digits = 1 byte)
        $octet1 = [Convert]::ToInt32($hexValue.Substring(0, 2), 16)
        $octet2 = [Convert]::ToInt32($hexValue.Substring(2, 2), 16)
        $octet3 = [Convert]::ToInt32($hexValue.Substring(4, 2), 16)
        $octet4 = [Convert]::ToInt32($hexValue.Substring(6, 2), 16)

        return "$octet1.$octet2.$octet3.$octet4"
    }
}

function ConvertTo-HexFromAscii
{
    <#
    .SYNOPSIS
    Converts an ASCII string to hexadecimal representation.

    .DESCRIPTION
    Takes an ASCII string and converts it to its hexadecimal representation.
    Optionally includes a prefix (like "0x") and delimiter between bytes.

    .PARAMETER AsciiString
    A string containing ASCII characters to convert to hexadecimal.

    .PARAMETER Prefix
    Optional prefix for the hex output (default: none). Common values: "0x", "\x".

    .PARAMETER Delimiter
    Optional delimiter between hex bytes (default: none). Common values: " ", ":", "-".

    .EXAMPLE
    ConvertTo-HexFromAscii -AsciiString "Hello"
    Returns: "48656C6C6F"

    .EXAMPLE
    ConvertTo-HexFromAscii "Hello World" -Delimiter " "
    Returns: "48 65 6C 6C 6F 20 57 6F 72 6C 64"

    .EXAMPLE
    "Test" | ConvertTo-HexFromAscii -Prefix "0x"
    Returns: "0x54657374"

    .EXAMPLE
    ConvertTo-HexFromAscii "ABC" -Delimiter ":"
    Returns: "41:42:43"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$AsciiString,

        [Parameter(Mandatory = $false)]
        [string]$Prefix = "",

        [Parameter(Mandatory = $false)]
        [string]$Delimiter = ""
    )

    process
    {
        # Convert each character to its hex representation
        $hexBytes = @()
        foreach ($char in $AsciiString.ToCharArray())
        {
            $hexBytes += "{0:X2}" -f [int][char]$char
        }

        # Join with delimiter and add prefix
        $hexString = $hexBytes -join $Delimiter
        return "$Prefix$hexString"
    }
}
# vim:fdm=syntax
