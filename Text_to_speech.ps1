Function New-TextToSpeechMessage {
    <#
    .SYNOPSIS
        This will use Powershell to have a message read out loud through your computer speakers.


    .NOTES
        Name: New-TextToSpeechMessage
        Author: theSysadminChannel
        Version: 1.0
        DateCreated: 2021-Feb-28

    .LINK
        https://thesysadminchannel.com/powershell-text-to-speech-how-to-guide/

    .EXAMPLE
        New-TextToSpeechMessage -Message 'This is the text I want to have read out loud' -Voice Zira
#>

    [CmdletBinding()]
    param(
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [string]$Message,

        [Parameter(
            Position = 1,
            Mandatory = $false
        )]
        [ValidateSet('David', 'Zira')]
        [string]$Voice
    )

    BEGIN {

        if (-not ([appdomain]::currentdomain.GetAssemblies() | Where-Object { $_.Location -eq 'C:\Windows\Microsoft.Net\assembly\GAC_MSIL\System.Speech\v4.0_4.0.0.0__31bf3856ad364e35\System.Speech.dll' })) {
            Add-Type -AssemblyName System.Speech
        }

    }

    PROCESS {

        try {
            $SpeechSynthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer

            switch ($Voice) {
                'Zira' { $SpeechSynthesizer.SelectVoice("Microsoft Zira Desktop"); break }
                'David' { $SpeechSynthesizer.SelectVoice("Microsoft David Desktop"); break }
                Default {}
            }

            $SpeechSynthesizer.Speak($Message)

        }
        catch { Write-Error $_.Exception.Message }
    }

    END {}
}

New-TextToSpeechMessage 'Enter some letters to make a word and press the Enter button to hear me say it' 'Zira'
$MessageArray = @()

while ($true) {

    $Key = $Host.UI.RawUI.ReadKey("IncludeKeyDown")

    switch ($Key.VirtualKeyCode) {
        13 {
            Write-Host ''
            New-TextToSpeechMessage ($MessageArray -join '') 'Zira'
            $MessageArray = @()
            break
        }
        27 { New-TextToSpeechMessage 'Good bye' 'Zira'; Write-Host ""; return }

        Default {
            if ($Key.Character) {
                $MessageArray += $Key.Character
            }
            else {
                New-TextToSpeechMessage 'Please try to use a letter or number' 'Zira'
            }
        }
    }

}