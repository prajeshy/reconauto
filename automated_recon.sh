#!/bin/bash
set -e
# Check if the required command-line arguments are provided
if [[ $# -eq 0 ]] ; then
    echo 'Please provide the target domain as the command-line argument'
    exit 1
fi

# Store the target domain name
TARGET_DOMAIN=$1

# Create a directory for the target domain
mkdir $TARGET_DOMAIN
cd $TARGET_DOMAIN

# Perform subdomain enumeration using Amass and Sublist3r
#amass enum -active -d $TARGET_DOMAIN -o amass.txt

subfinder -d "$1" -o subdomains.txt
subfinder -d "$1" | httpx | nuclei "$1" -es info | tee nuclei-subfinder.txt -nc && cat nuclei-subfinder.txt

# # Remove duplicates from the results of Amass and Sublist3r
#sort -u -o amass.txt amass.txt
#sort -u -o "$1".txt "$1".txt

# # Combine the results from both tools
sort -u > subdomains.txt


# Perform port scanning using Nmap
nmap -iL subdomains.txt -T4 -sS -p- -oN nmap.txt

# Perform HTTP enumeration using Gobuster
gobuster -w raft-large-directories.txt -u https://$TARGET_DOMAIN -e -k -t 50 -x php,txt,html -o gobuster.txt

# Perform SSL enumeration using SSLscan
sslscan $TARGET_DOMAIN | tee sslscan.txt

# Perform DNS enumeration using Dnsrecon
dnsrecon -d $TARGET_DOMAIN -t std,axfr -D ~/SecLists/Discovery/DNS/deepmagic.com-prefixes-top50000.txt -o dnsrecon.txt

# Perform directory bruteforcing using Dirbuster and ffuf
ffuf -w raft-large-directories.txt -u https://$TARGET_DOMAIN/FUZZ -e .php,.txt,.html -o ffuf.txt -t 100

# Perform Shodan search using the Shodan API key
curl "https://api.shodan.io/shodan/host/search?key=XzF4CTgkoDdkSNIHV8qRWr4uu8QZP8FU&query=$TARGET_DOMAIN&facets={port}" -o shodan.txt

# Perform key finding using Nuclei
nuclei -I heap.txt -t ~/nuclei-templates/file/keys/ -l subdomains.txt -o nuclei.txt


# Perform Git discovery using Amass and Aquatone
amass enum -active -d $TARGET_DOMAIN -brute -w ~/SecLists/Discovery/DNS/subdomains-top1million-110000.txt -o amass.txt
cat amass.txt | aquatone -ports xlarge -out aqua_$TARGET_DOMAIN
nuclei -l aqua_$TARGET_DOMAIN/aquatone_urls.txt -t ~/nuclei-templates -es info -o nuclei_$TARGET_DOMAIN.txt

# Nuclei 

subfinder -d "$1" | httpx | nuclei "$1" -es info | tee "$1".txt -nc && cat "$1".txt -nc

subfinder -d "$1" | tee "$1".txt -subs && cat "$1".txt subs
