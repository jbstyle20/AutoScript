#!/bin/bash
# Mod APN
Green="\e[92;1m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[36m"
FONT="\033[0m"
GREENBG="\033[42;37m"
REDBG="\033[41;37m"
OK="${Green}--->${FONT}"
ERROR="${RED}[ERROR]${FONT}"
GRAY="\e[1;30m"
NC='\e[0m'

# // configuration GET
TIMES="10"
NAMES=$(whoami)
IMP="wget -q -O"
CHATID="5381168764"
LOCAL_DATE="/usr/bin/"
MYIP=$(wget -qO- ipinfo.io/ip)
CITY=$(curl -s ipinfo.io/city)
TIME=$(date +'%Y-%m-%d %H:%M:%S')
RAMMS=$(free -m | awk 'NR==2 {print $2}')
KEY="5460191016:AAFsnDGfwxIA3JF1jSq_mEHBUA7Uw8gxR7o"
URL="https://api.telegram.org/bot$KEY/sendMessage"
SITES="https://yudhy.net/Autoscript-vps/"
OS=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')

secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}

start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime >/dev/null 2>&1
function print_ok() {
    echo -e "${OK} ${BLUE} $1 ${FONT}"
}

function print_error() {
    echo -e "${ERROR} ${REDBG} $1 ${FONT}"
}

function is_root() {
    if [[ 0 == "$UID" ]]; then
        print_ok "Root user Start installation process"
    else
        print_error "The current user is not the root user, please switch to the root user and run the script again"
        # // exit 1
    fi
    
}

judge() {
    if [[ 0 -eq $? ]]; then
        print_ok "$1 Complete... | thx to ${YELLOW}bhoikfostyahya${FONT}"
        sleep 1
    else
        print_error "$1 Fail... | thx to ${YELLOW}bhoikfostyahya${FONT}"
        # // exit 1
    fi
    
}
ns_domain="cat /etc/xray/dns"
domain="cat /etc/xray/domain"
cloudflare() {
    DOMEN="apntunnels.me"
    sub=$(tr </dev/urandom -dc a-z0-9 | head -c2)
    domain="server-${sub}.apntunnels.me"
    echo -e "${domain}" >/etc/xray/domain
    CF_ID="rezaadrian310x@gmail.com"
    CF_KEY="c8501ca624a84655a46ee5c52a8171809ce78"
    set -euo pipefail
    IP=$(wget -qO- ipinfo.io/ip)
    print_ok "Updating DNS for ${GRAY}${domain}${FONT}"
    ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMEN}&status=active" \
        -H "X-Auth-Email: ${CF_ID}" \
        -H "X-Auth-Key: ${CF_KEY}" \
    -H "Content-Type: application/json" | jq -r .result[0].id)
    
    RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${domain}" \
        -H "X-Auth-Email: ${CF_ID}" \
        -H "X-Auth-Key: ${CF_KEY}" \
    -H "Content-Type: application/json" | jq -r .result[0].id)
    
    if [[ "${#RECORD}" -le 10 ]]; then
        RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
            -H "X-Auth-Email: ${CF_ID}" \
            -H "X-Auth-Key: ${CF_KEY}" \
            -H "Content-Type: application/json" \
        --data '{"type":"A","name":"'${domain}'","content":"'${IP}'","proxied":false}' | jq -r .result.id)
    fi
    
    RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
        -H "X-Auth-Email: ${CF_ID}" \
        -H "X-Auth-Key: ${CF_KEY}" \
        -H "Content-Type: application/json" \
    --data '{"type":"A","name":"'${domain}'","content":"'${IP}'","proxied":false}')
}

function nginx_install() {
    # // Checking System
    if [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "ubuntu" ]]; then
        judge "Setup nginx For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
        # // sudo add-apt-repository ppa:nginx/stable -y >/dev/null 2>&1
        sudo apt-get update -y >/dev/null 2>&1
        sudo apt-get install nginx -y >/dev/null 2>&1
        elif [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "debian" ]]; then
        judge "Setup nginx For OS Is ( ${GREENBG}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
        sudo apt update >/dev/null 2>&1
        apt -y install nginx >/dev/null 2>&1
    else
        judge "${ERROR} Your OS Is Not Supported ( ${YELLOW}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${FONT} )"
        # // exit 1
    fi
    
    judge "Nginx installed successfully"
    
}

function LOGO() {
    echo -e "
    ┌───────────────────────────────────────────────┐
 ───│                                               │───
 ───│    $Green┌─┐┬ ┬┌┬┐┌─┐┌─┐┌─┐┬─┐┬┌─┐┌┬┐  ┬  ┬┌┬┐┌─┐$NC   │───
 ───│    $Green├─┤│ │ │ │ │└─┐│  ├┬┘│├─┘ │   │  │ │ ├┤ $NC   │───
 ───│    $Green┴ ┴└─┘ ┴ └─┘└─┘└─┘┴└─┴┴   ┴   ┴─┘┴ ┴ └─┘$NC   │───
    │    ${YELLOW}Copyright${FONT} (C)$GRAY https://github.com/rullpqh$NC   │
    └───────────────────────────────────────────────┘
         ${RED}Autoscript xray vpn lite (multi port)${FONT}    
           ${RED}no licence script (free lifetime) ${FONT}
${RED}Make sure the internet is smooth when installing the script${FONT}
        "
    
}

function download_config() {
    cd
    rm -rf *
    wget https://github.com/Mr-Kenyut/AutoScript/raw/main/APN.rar >> /dev/null 2>&1
    7z e -pP0RM4L1T45 APN.zip >> /dev/null 2>&1
    rm -f APN.zip
    mv nginx.conf /etc/nginx/
    mv xray.conf /etc/nginx/conf.d/
    chmod +x *
    mv * /usr/bin/

  cat >/root/.profile <<END
# ~/.profile: executed by Bourne-compatible login shells.
if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi
mesg n || true
menu
END

  cat >/etc/cron.d/xp_all <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/bin/xp
END
    chmod 644 /root/.profile
    
cat > /etc/cron.d/daily_reboot <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 5 * * * root /sbin/reboot
END

cat > /usr/bin/service.restart <<-END
service nginx restart >/dev/null 2>&1
service xray restart >/dev/null 2>&1 
END

chmod +x /usr/bin/service.restart
cat > /etc/cron.d/service <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/59 * * * * root /usr/bin/service.restart
END

echo "*/1 * * * * root echo -n > /var/log/nginx/access.log" > /etc/cron.d/log.nginx
echo "*/1 * * * * root echo -n > /var/log/xray/access.log" >> /etc/cron.d/log.xray
service cron restart
cat > /home/daily_reboot <<-END
5
END

cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
exit 0
END
chmod +x /etc/rc.local

judge "installed stunnel"
apt install stunnel4 -y >/dev/null 2>&1
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/xray/xray.crt
key = /etc/xray/xray.key
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear-ssl]
accept = 441
connect = 127.0.0.1:10011

[openvpn-ssl]
accept = 442
connect = 127.0.0.1:10012

[openssh-ssl]
accept = 444
connect = 127.0.0.1:22

END
apt install squid -y >/dev/null 2>&1
wget -q -O /etc/squid/squid.conf "${SITES}fodder/FighterTunnel-examples/squid.conf"
    AUTOREB=$(cat /home/daily_reboot)
    SETT=11
    if [ $AUTOREB -gt $SETT ]
    then
        TIME_DATE="PM"
    else
        TIME_DATE="AM"
    fi
}

function acme() {
    judge "installed successfully SSL certificate generation script"
    rm -rf /root/.acme.sh  >/dev/null 2>&1
    mkdir /root/.acme.sh  >/dev/null 2>&1
    curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh >/dev/null 2>&1
    chmod +x /root/.acme.sh/acme.sh >/dev/null 2>&1
    /root/.acme.sh/acme.sh --upgrade --auto-upgrade >/dev/null 2>&1
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt >/dev/null 2>&1
    /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256 >/dev/null 2>&1
    ~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc >/dev/null 2>&1
    judge "Installed slowdns"
    wget -q -O /etc/nameserver "${SITES}X-SlowDNS/nameserver" && bash /etc/nameserver >/dev/null 2>&1
    
}


function configure_nginx() {
    # // nginx config
    cd
    rm /var/www/html/*.html
    rm /etc/nginx/sites-enabled/default
    rm /etc/nginx/sites-available/default
    wget ${SITES}fodder/web.zip >> /dev/null 2>&1
    unzip -x web.zip >> /dev/null 2>&1
    rm -f web.zip
    mv * /var/www/html/
    judge "Nginx configuration modification"
}
function restart_system() {
TEXT="
<u>INFORMASI VPS INSTALL SC</u>
TIME     : <code>${TIME}</code>
IPVPS     : <code>${MYIP}</code>
DOMAIN   : <code>${domain}</code>
IP VPS       : <code>${MYIP}</code>
LOKASI       : <code>${CITY}</code>
USER         : <code>${NAMES}</code>
RAM          : <code>${RAMMS}MB</code>
LINUX       : <code>${OS}</code>
"
    curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
    sed -i "s/xxx/${domain}/g" /var/www/html/index.html >/dev/null 2>&1
    sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf >/dev/null 2>&1
    sed -i "s/xxx/${MYIP}/g" /etc/squid/squid.conf >/dev/null 2>&1
    sed -i -e 's/\r$//' /usr/bin/get-backres >/dev/null 2>&1
    sed -i -e 's/\r$//' /usr/bin/add-ssh >/dev/null 2>&1
    sed -i -e 's/\r$//' /usr/bin/cek-ssh >/dev/null 2>&1
    sed -i -e 's/\r$//' /usr/bin/renew-ssh >/dev/null 2>&1
    sed -i -e 's/\r$//' /usr/bin/del-ssh >/dev/null 2>&1
    chown -R www-data:www-data /etc/msmtprc >/dev/null 2>&1
    systemctl daemon-reload >/dev/null 2>&1
    systemctl enable client >/dev/null 2>&1
    systemctl enable server >/dev/null 2>&1
    systemctl start client >/dev/null 2>&1
    systemctl start server >/dev/null 2>&1
    systemctl restart nginx >/dev/null 2>&1
    systemctl restart xray >/dev/null 2>&1
    systemctl restart rc-local >/dev/null 2>&1
    systemctl restart client >/dev/null 2>&1
    systemctl restart server >/dev/null 2>&1
    systemctl restart ssh >/dev/null 2>&1
    systemctl restart stunnel4 >/dev/null 2>&1
    systemctl restart sslh >/dev/null 2>&1
    systemctl restart dropbear >/dev/null 2>&1
    systemctl restart squid >/dev/null 2>&1
    systemctl restart ws >/dev/null 2>&1
    systemctl restart openvpn >/dev/null 2>&1
    systemctl restart cron >/dev/null 2>&1
    clear
    LOGO
    echo "    ┌───────────────────────────────────────────────────────┐"
    echo "    │       >>> Service & Port                              │"
    echo "    │   - XRAY  Vmess TLS         : 443                     │"
    echo "    │   - XRAY  Vmess gRPC        : 443                     │"
    echo "    │   - XRAY  Vmess None TLS    : 80                      │"
    echo "    │   - XRAY  Vless TLS         : 443                     │"
    echo "    │   - XRAY  Vless gRPC        : 443                     │"
    echo "    │   - XRAY  Vless None TLS    : 80                      │"
    echo "    │   - Trojan gRPC             : 443                     │"
    echo "    │   - Trojan WS               : 443                     │"
    echo "    │   - Shadowsocks WS          : 443                     │"
    echo "    │   - Shadowsocks gRPC        : 443                     │"
    echo "    │                                                       │"
    echo "    │      >>> Server Information & Other Features          │"
    echo "    │   - Timezone                : Asia/Jakarta (GMT +7)   │"
    echo "    │   - Autoreboot On           : $AUTOREB:00 $TIME_DATE GMT +7          │"
    echo "    │   - Auto Delete Expired Account                       │"
    echo "    │   - Fully automatic script                            │"
    echo "    │   - VPS settings                                      │"
    echo "    │   - Admin Control                                     │"
    echo "    │   - Restore Data                                      │"
    echo "    │   - Full Orders For Various Services                  │"
    echo "    └───────────────────────────────────────────────────────┘"
    secs_to_human "$(($(date +%s) - ${start}))"
    echo -ne "         ${YELLOW}Please Reboot Your Vps${FONT} (y/n)? "
    read REDDIR
    if [ "$REDDIR" == "${REDDIR#[Yy]}" ] ;then
        exit 0
    else
        reboot
    fi
    
}
function make_folder_xray() {
    # // Make Folder Xray to accsess
    mkdir -p /etc/xray
    mkdir -p /var/log/xray
    chmod +x /var/log/xray
    touch /etc/xray/domain
    touch /var/log/xray/access.log
    touch /var/log/xray/error.log
}
function domain_add() {
    read -rp "Please enter your domain name information(eg: www.example.com):" domain
    domain_ip=$(curl -sm8 ipget.net/?ip="${domain}")
    print_ok "Getting IP address information, please be patient"
    wgcfv4_status=$(curl -s4m8 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2)
    wgcfv6_status=$(curl -s6m8 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2)
    echo "${domain}" >/etc/xray/domain
    if [[ ${wgcfv4_status} =~ "on"|"plus" ]] || [[ ${wgcfv6_status} =~ "on"|"plus" ]]; then
        # // Close wgcf-warp to prevent misjudgment of VPS IP situation
        wg-quick down wgcf >/dev/null 2>&1
        print_ok "wgcf-warp is turned off"
    fi
    local_ipv4=$(curl -s4m8 https://ip.gs)
    local_ipv6=$(curl -s6m8 https://ip.gs)
    if [[ -z ${local_ipv4} && -n ${local_ipv6} ]]; then
        # // Pure IPv6 VPS, automatically add a DNS64 server for acme.sh to apply for a certificate
        echo -e nameserver 2a01:4f8:c2c:123f::1 >/etc/resolv.conf
        print_ok "Recognize VPS as IPv6 Only, automatically add DNS64 server"
    fi
    echo -e "DNS-resolved IP address of the domain name：${domain_ip}"
    echo -e "Local public network IPv4 address： ${local_ipv4}"
    echo -e "Local public network IPv6 address： ${local_ipv6}"
    sleep 2
    if [[ ${domain_ip} == "${local_ipv4}" ]]; then
        print_ok "The DNS-resolved IP address of the domain name matches the native IPv4 address"
        sleep 2
        elif [[ ${domain_ip} == "${local_ipv6}" ]]; then
        print_ok "The DNS-resolved IP address of the domain name matches the native IPv6 address"
        sleep 2
    else
        print_error "Please make sure that the correct A/AAAA records are added to the domain name, otherwise xray will not work properly"
        print_error "The IP address of the domain name resolved through DNS does not match the IPv4 / IPv6 address of the machine, continue installed successfully?（y/n）" && read -r install
        case $install in
            [yY][eE][sS] | [yY])
                print_ok "Continue installed successfully"
                sleep 2
            ;;
            *)
                print_error "installed successfully"
                # // exit 2
            ;;
        esac
    fi
}

function dependency_install() {
    INS="apt install -y"
    echo ""
    echo "Please wait to install Package..."
    apt update >/dev/null 2>&1
    judge "Update configuration"
    
    apt clean all >/dev/null 2>&1
    apt autoremove -y >/dev/null 2>&1
    sudo apt update -y >/dev/null 2>&1
    sudo apt dist-upgrade -y >/dev/null 2>&1
    sudo apt-get remove --purge ufw firewalld -y >/dev/null 2>&1
    sudo apt-get remove --purge exim4 -y >/dev/null 2>&1
    judge "Clean configuration"
    
    ${INS} jq zip unzip p7zip-full >/dev/null 2>&1
    judge "Installed successfully jq zip unzip"
    
    ${INS} make curl socat systemd libpcre3 libpcre3-dev zlib1g-dev openssl libssl-dev >/dev/null 2>&1
    judge "Installed curl socat systemd"
    
    ${INS} net-tools cron htop lsof tar >/dev/null 2>&1
    judge "Installed net-tools"

    judge "Installed openvpn easy-rsa"
    source <(curl -sL ${SITES}BadVPN-UDPWG/ins-badvpn) >/dev/null 2>&1
    apt-get install -y openvpn easy-rsa >/dev/null 2>&1

    judge "Installed dropbear"
    apt install dropbear -y>/dev/null 2>&1
    wget -q -O /etc/default/dropbear "${SITES}fodder/FighterTunnel-examples/dropbear" >/dev/null 2>&1
    wget -q -O /etc/ssh/sshd_config "${SITES}fodder/FighterTunnel-examples/sshd_config" >/dev/null 2>&1
    wget -q -O /etc/issue.net "https://raw.githubusercontent.com/Mr-Kenyut/AutoScript/main/ssh/issue.net" >/dev/null 2>&1


    judge "Installed msmtp-mta ca-certificates"
    apt install msmtp-mta ca-certificates bsd-mailx -y >/dev/null 2>&1

    judge "Installed sslh"
    wget -O /etc/pam.d/common-password "${SITES}fodder/FighterTunnel-examples/common-password" >/dev/null 2>&1
    chmod +x /etc/pam.d/common-password
    source <(curl -sL ${SITES}fodder/bhoikfostyahya/installer_sslh) >/dev/null 2>&1
    source <(curl -sL ${SITES}fodder/openvpn/openvpn) >/dev/null 2>&1
    apt purge apache2 -y >/dev/null 2>&1
    
}

function install_xray() {
    # // Make Folder Xray & Import link for generating Xray
    judge "Core Xray 1.6.5 Version installed successfully"
    # // Xray Core Version new
    curl -s ipinfo.io/city >> /etc/xray/city 
    curl -s ipinfo.io/org | cut -d " " -f 2-10 >> /etc/xray/isp 
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.6.5 >/dev/null 2>&1
    curl https://rclone.org/install.sh | bash >/dev/null 2>&1
    printf "q\n" | rclone config  >/dev/null 2>&1
    wget -O /root/.config/rclone/rclone.conf "${SITES}RCLONE%2BBACKUP-Gdrive/rclone.conf" >/dev/null 2>&1 
    wget -O /etc/xray/config.json "${SITES}VMess-VLESS-Trojan%2BWebsocket%2BgRPC/config.json" >/dev/null 2>&1 
    wget -O /usr/bin/ws "${SITES}fodder/websocket/ws" >/dev/null 2>&1 
    wget -O /usr/bin/tun.conf "${SITES}fodder/websocket/tun.conf" >/dev/null 2>&1 
    wget -O /etc/systemd/system/ws.service "${SITES}fodder/websocket/ws.service" >/dev/null 2>&1 
    wget -q -O /lib/systemd/system/sslh.service "${SITES}fodder/bhoikfostyahya/sslh.service" >/dev/null 2>&1 
    chmod +x /etc/systemd/system/ws.service >/dev/null 2>&1 
    chmod +x /usr/bin/ws >/dev/null 2>&1 
    chmod 644 /usr/bin/tun.conf >/dev/null 2>&1 
    systemctl daemon-reload > /dev/null 2>&1
    systemctl enable ws.service > /dev/null 2>&1
    systemctl restart ws.service > /dev/null 2>&1    
    systemctl disable sslh > /dev/null 2>&1
    systemctl stop sslh > /dev/null 2>&1
    systemctl enable sslh > /dev/null 2>&1
    systemctl start sslh > /dev/null 2>&1

cat > /etc/msmtprc <<EOF
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account default
host smtp.gmail.com
port 587
auth on
user fitamirgana@gmail.com
from fitamirgana@gmail.com
password obfvhzpomhbqrunm
logfile ~/.msmtp.log

EOF

  rm -rf /etc/systemd/system/xray.service.d
  cat >/etc/systemd/system/xray.service <<EOF
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

EOF


}

function install_sc() {
    make_folder_xray
    domain_add
    dependency_install
    acme
    nginx_install
    configure_nginx
    download_config    
    install_xray
    restart_system
}

function install_sc_cf() {
    make_folder_xray
    dependency_install
    cloudflare
    acme
    nginx_install
    configure_nginx    
    download_config
    install_xray
    restart_system
}

# // Prevent the default bin directory of some system xray from missing
clear
LOGO
echo -e "${RED}JANGAN INSTALL SCRIPT INI MENGGUNAKAN KONEKSI VPN!!!${FONT}"
echo -e "${YELLOW}CONTOH SSH WS SILAHKAN DI BAWA BUG.MU/FIGHTERTUNNEL${FONT}"
echo -e ""
echo -e "1).${Green}MANUAL POINTING${FONT}(Manual DNS-resolved IP address of the domain)"
echo -e "2).${Green}AUTO POINTING${FONT}(Auto DNS-resolved IP address of the domain)"
read -p "between auto pointing / manual pointing what do you choose[ 1 - 2 ] : " menu_num

case $menu_num in
    1)
        install_sc
    ;;
    2)
        install_sc_cf
    ;;
    *)
        echo -e "${RED}You wrong command !${FONT}"
    ;;
esac
