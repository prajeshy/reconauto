# reconauto
This tool is a bash script for performing comprehensive security assessment on a target domain.

Usage
To use this tool, simply provide the target domain name as a command-line argument. For example:

<script>
Copy code
./security_assessment.sh example.com
</script>

Requirements
Amass
Sublist3r
Subfinder
Httpx
Nmap
Gobuster
SSLscan
Dnsrecon
Dirbuster
Ffuf
Shodan API key
Nuclei
Aquatone
Installation
To install the required tools, please refer to their respective documentation. Once all the tools are installed, simply clone this repository and make the script executable:

<script>
Copy code
git clone https://github.com/yourusername/security_assessment.git
cd security_assessment
chmod +x security_assessment.sh
</script>

#Functionality
This tool performs the following security assessment steps on the target domain:

Subdomain enumeration using Amass and Sublist3r.
Port scanning using Nmap.
HTTP enumeration using Gobuster.
SSL enumeration using SSLscan.
DNS enumeration using Dnsrecon.
Directory bruteforcing using Dirbuster and Ffuf.
Shodan search using the Shodan API key.
Key finding using Nuclei.
Git discovery using Amass and Aquatone.

#Results
The results of each step are stored in separate text files in a directory named after the target domain. The directory is created automatically by the script.
