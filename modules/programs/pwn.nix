{ config, pkgs, lib, ... }:
let 
  pwnTools = with pkgs; [
	burpsuite
	nmap
	gobuster
	metasploit
	ffuf
	nuclei
	nuclei-templates
	nucleiparser
	netcat
	smbmap
	smbscan
	smbclient-ng
	hashcat
	john
	nikto
	zap
	openvas-scanner
	sqlmap
	xrdp
	tcpdump
  ];
in {
  environment.systemPackages = pwnTools;
}
