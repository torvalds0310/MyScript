#!/bin/bash
# Author: Yaning
# Vserion: 0.1
# Desc: Will tune  linux OS after installed OS.

# Disabled used service.
for i in (at,autofs,bluetooth,cups,crond,iptables,ip6tables):
do
	/etc/init.d/$i stop
	chkconfig $i off
do

echo "Disabled unused service."

# Setup Yum repository.
# Backup current repos
mkdir /etc/yum.repos.d/bak/
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak/
echo "Current yum repos backup to dir /etc/yum.repos.d/bak/."

# Get yum repo from web server.
wget http://yourserver/repos/reponame -C /etc/yum.repos.d/

# Add yum repo by scirpt.
cat > /etc/yum.repos.d/reponame.repo <<EOF
[zabbix]
name=DZabbix Official Repository - $basearch
baseurl=http://repo.zabbix.com/zabbix/2.2/rhel/6/$basearch/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
EOF

# Install epel repo:
wget http://mirrors.ustc.edu.cn/fedora/epel//5/x86_64/epel-release-5-4.noarch.rpm -C /root/
rpm -ivh /root/epel-release-5-4.noarch.rpm

# Configure NTP service.
yum -y install ntp

echo "01 01 * * * /usr/sbin/ntpdate ntp.api.bz    >> /dev/null 2>&1" >> /etc/crontab
ntpdate ntp.api.bz
service crond restart

# Configure limits.conf
ulimit -SHn 65535
echo "ulimit -SHn 65535" >> /etc/rc.local
cat >> /etc/security/limits.conf << EOF
*                     soft     nofile             60000
*                     hard     nofile             65535
EOF

# Tune kernel parametres
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 1024 65535
EOF
/sbin/sysctl -p

# Disable control-alt-delete
# For RHEL/CentOS 5.
sed -i 's@ca::ctrlaltdel:/sbin/shutdown -t3 -r now@#ca::ctrlaltdel:/sbin/shutdown -t3 -r now@' /etc/inittab

# For RHEL/CentOS 6.
sed -i 's@start on control-alt-delete@#start on control-alt-delete@' /etc/init/control-alt-delete.conf
sed -i 's@exec /sbin/shutdown -r now "Control-Alt-Delete pressed"@#exec /sbin/shutdown -r now "Control-Alt-Delete pressed"@' /etc/init/control-alt-delete.conf

# Disable selinux.
sed -i 's@SELINUX=enforcing@SELINUX=disabled@' /etc/selinux/config

# Tune SSH servcie.
sed -i -e '74 s/^/#/' -i -e '76 s/^/#/' /etc/ssh/sshd_config
sed -i 's@#UseDNS yes@UseDNS no@' /etc/ssh/sshd_config
service sshd restart

# Disable IPv6.
# For RHEL/CentOS 5.
cat >> /etc/modprobe.conf <<EOF
alias net-pf-10 off
alias ipv6 off
install ipv6 /bin/true
EOF
echo "IPV6INIT=no" >> /etc/sysconfig/network
sed -i 's@NETWORKING_IPV6=yes@NETWORKING_IPV6=no@'    /etc/sysconfig/network
/etc/init.d/network restart
rmmod ipv6

# For RHEL/CentOS 6.
cat > /etc/modprobe.d/ipv6off.conf <<EOF
alias net-pf-10 off
options ipv6 disable=1
EOF
echo "IPV6INIT=no" >> /etc/sysconfig/network
sed -i 's@NETWORKING_IPV6=yes@NETWORKING_IPV6=no@'    /etc/sysconfig/network
/etc/init.d/network restart
rmmod ipv6

# Configure vim editor. 
cat > /root/.vimrc <<EOF
syntax on
set nocompatible
set showmatch
set hls
set incsearch
set shiftwidth=4
set ts=4
set ruler
set mousehide
set mouse=v
set encoding=utf-8
set fileencodings=utf-8,chinese,latin-1
set visualbell
if has("gui_running")
	set cursorline
	colorscheme murphy
	set background=dark
	set guifont=YaHei\ Consolas\ Hybrid:h14
	highlight Cursorline guibg=grey15
	set guioptions-=T
	set fileformat=unix
	set lines=49
	set columns=140
	set mouse=a
endif
EOF


# Set history parameters.

