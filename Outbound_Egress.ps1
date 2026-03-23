# Setup
$target = "portquiz.net"
$ports  = @(21, 22, 53, 80, 443, 445, 1433, 3306, 3389, 5985, 8080, 9001)

Clear-Host
Write-Host "`n[!] HOST IDENTIFICATION" -F Yellow
Write-Host "------------------------------------------------" -F Gray
Write-Host "HOSTNAME : " -NoNewline; hostname
# Pulls only active IPv4 addresses to keep the screenshot clean
Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" } | Select-Object -ExpandProperty IPAddress | ForEach-Object { Write-Host "LOCAL IP : $_" }

Write-Host "`n[#] OUTBOUND EGRESS ASSESSMENT: ${target}" -F Cyan
Write-Host "------------------------------------------------" -F Gray

# 1. TCP Port Check
foreach ($p in $ports) {
    try {
        $r = Invoke-WebRequest "http://${target}:$p" -TimeoutSec 2 -ErrorAction Stop
        $ip = ($r.Content -split "Your IP: ")[1].Split("<")[0].Trim()
        Write-Host "Port $($p.ToString().PadRight(5)) : [ SUCCESS ] - Source NAT: $ip" -F Green
    }
    catch {
        Write-Host "Port $($p.ToString().PadRight(5)) : [ BLOCKED ]" -F Red
    }
}

Write-Host "------------------------------------------------" -F Gray

# 2. Verbose ICMP (Ping) Check
Write-Host "[!] TESTING ICMP LAYER 3 REACHABILITY..." -F Yellow
$ping = Test-Connection -ComputerName 8.8.8.8 -Count 1 -ErrorAction SilentlyContinue

if ($ping) {
    Write-Host "RESULT   : [ VULNERABLE ]" -F Green
    Write-Host "TARGET   : 8.8.8.8 (Google DNS)" -F Gray
    Write-Host "LATENCY  : $($ping.ResponseTime)ms" -F Gray
    Write-Host "EVIDENCE : Unrestricted ICMP allows for Layer 3 tunneling/C2." -F Gray
} else {
    Write-Host "RESULT   : [ SECURE ]" -F Red
    Write-Host "DETAILS  : Outbound ICMP Echo Requests are filtered." -F Gray
}

Write-Host "------------------------------------------------`n" -F Gray
