#!/bin/bash
clear
echo "  #####################################################"
echo "  #     GRUPAMENTO DE APOIO DE SÃO PAULO (GAP-SP)     #"
echo "  #   Assessoria de Tecnologia da Informaçào (ATI)    #"
echo "  #             Criado pelo S2 L. Giovani             #"
echo "  #                                                   #"
echo "  #            Script de configuração para            #"
echo "  #             Ubuntu 18.04 LTS (bionic)             #"
echo "  #                                                   #"
echo "  #  - Integrado ao SAMBA4                   __       #"
echo "  #  - Firefox-ESR                          <o )      #"
echo "  #  -                                      /\|\      #"
echo "  #  - LibreOffice                         _\_V/      #"
echo "  #                                                   #"
echo "  #                                    V1.0 30/04/17  #"
echo "  #####################################################"
echo ""
sleep 2

if test `whoami` = root
then
if test `arch` = amd64
then


echo " ##########################################"
echo " #   Definindo variáveis do script        #"
echo " ##########################################"
HOSTNAME=`cat /etc/hostname`				# Nome da máquina
DATA=`date +%d%m%Y`					# Data formato dd/mm/aaaa
ETH=`ifconfig | awk '{print $1}' | head -n1 | tail -1`	# Nome da interface de rede
echo -n "Digite seu usuário admin (Ex. leonardor):";read ADM_USER		#Usuário
cd


echo " ##########################################"
echo " # Desativando Rel. de erros - apport     #"
echo " ##########################################"
sleep 2
service apport stop
apt-get purge -yq apport* whoopsie*


echo " ##########################################"
echo " # Configurando tabela de nome - hosts    #"
echo " ##########################################"
sleep 2
cp /etc/hosts /etc/hosts.$DATA
cat > /etc/hosts << EOF
127.0.0.1	localhost
127.0.1.1	`hostname`.corp.drconsulta.com	`hostname`
EOF


echo " ##########################################"
echo " # Configurando DNS - resolv.conf         #"
echo " ##########################################"
sleep 2
# Obs.: Os dados do resolv.conf serão
# substituido ao reniciar pelas
# informações que o DHCPD prover
cp /etc/resolv.conf /etc/resolv.conf.$DATA
cat > /etc/resolv.conf << EOF
nameserver 104.41.41.126
nameserver 104.41.52.149
domain corp.drconsulta.com
search corp.drconsulta.com
EOF


echo " ##########################################"
echo " # Configurando Permissão sudo - sudoers  #"
echo " ##########################################"
sleep 2
cp /etc/sudoers /etc/sudoers.$DATA
cat > /etc/sudoers << EOF
#
# This file MUST be edited with the 'visudo' command as root.
#
# Please consider adding local content in /etc/sudoers.d/ instead of
# directly modifying this file.
#
# See the man page for details on how to write a sudoers file.
#
Defaults	env_reset
Defaults	mail_badpass
Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root	ALL=(ALL:ALL) ALL
suporte	ALL=(ALL) ALL

# Members of the admin group may gain root privileges
%admin	ALL=(ALL) ALL
%Administrators	ALL=(ALL) ALL

# Allow members of group sudo to execute any command
%sudo	ALL=(ALL:ALL) ALL

# See sudoers(5) for more information on "#include" directives:

#includedir /etc/sudoers.d
EOF


echo " ##########################################"
echo " # Configurando Repositório e Atualizando #"
echo " ##########################################"
sleep 2
#Apaga os arquivos que bloqueiam o apt-get
rm -rf /var/lib/apt/lists/lock
rm -rf /var/lib/dpkg/lock
rm -rf /var/cache/apt/archives/lock
#Atualiza lista de pacotes e atualiza o sistema
apt-get update
apt-get -yq upgrade


echo " ##########################################"
echo " # Instalando pacotes necessários         #"
echo " ##########################################"
sleep 2
apt-get install -yq ntpdate vim openssh-server aptitude mc cifs-utils traceroute


echo " ##########################################"
echo " # Configurando Atualização Hora - NTP    #"
echo " ##########################################"
sleep 2
cp /etc/default/ntpdate /etc/default/ntpdate.$DATA
sed -i 's/=yes/=no/g' /etc/default/ntpdate
sed -i 's/b.ntp.br c.ntp.br 0.br.pool.ntp.org/g' /etc/default/ntpdate
timedatectl set-ntp no
ntpdate-debian 104.41.41.126
hwclock -w


echo " ##########################################"
echo " #  Instalando e Configurando o Chrome    #"
echo " ##########################################"
sleep 2
#Remove o Firefox
apt-get purge -yq firefox*
#Instalação
cat > /etc/apt/sources.list.d/google-chrome.list << EOF
deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main
EOF
wget https://dl.google.com/linux/linux_signing_key.pub
apt-key add linux_signing_key.pub
apt-get update
apt-get install google-chrome-stable

wget --no-check-certificate --content-disposition https://github.com/leonardogiovani/drc/blob/master/s2.png -O /usr/share/icons/hicolor/48x48/apps/s2.png


cat > /usr/share/applications/s2.desktop <<EOF
#! /usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Terminal=false
Type=Application
Name=dr.consulta - S2
Exec=/opt/google/chrome/google-chrome --app=https://s2.drconsulta.com
Icon=/usr/share/icons/hicolor/48x48/apps/s2.png
StartupWMClass=crx_dimhekkiknakfiofbgibaoebmgkjddj
EOF


cd


echo " ##########################################"
echo " # Instalando pacotes úteis ao usuário    #"
echo " ##########################################"
sleep 2
#Pacotes Diversos
apt-get install -yq ubuntu-restricted-extras pdfsam adobe-flashplugin ssvnc psutils caja-image-converter glabels pinta

cd
#Download e instalação do Adobe Reader 9.5.5
cd /etc/opt
wget -c --no-check-certificate --content-disposition https://github.com/leonardogiovani/drc/blob/master/AdbeRdr9.5.5-1_i386linux_enu.deb
dpkg -i AdbeRdr9.5.5-1_i386linux_enu.deb
cd
#pacotes de idioma
apt-get install -yq language-pack-gnome-pt language-pack-gnome-pt-base language-pack-pt language-pack-pt-base hunspell-pt-br hunspell-en-gb hunspell-en-au thunderbird-locale-en-gb hyphen-en-gb mythes-en-au hyphen-pt-pt libreoffice-l10n-en-gb hunspell-pt-pt libreoffice-help-en-gb mythes-pt-pt libreoffice-l10n-en-za hyphen-en-ca hyphen-pt-br hunspell-en-ca hunspell-en-za thunderbird-locale-pt-pt

echo " ##########################################"
echo " # Configurando Impressao - Cups          #"
echo " ##########################################"
sleep 2
service cups stop
service cups-browsed stop
apt-get purge -yq avahi-daemon
sed -i 's/dnssd cups/none/g' /etc/cups/cups-browsed.conf
service cups start
service cups-browsed start
apt-get install -yq cups-pdf gtklp python-smbc
cd
service cups restart


echo " ##########################################"
echo " # Configurando ícones do painel do mate  #"
echo " ##########################################"
sleep 2
#adicionando ícones na area de trabalho para novos usuarios
#firefox. libreoffice, calculadora, ferramenta de busca,
#impressoras, screenshot e atalho para o hercules
mkdir -p /etc/skel/Área\ de\ Trabalho/
cd /etc/skel/Área\ de\ Trabalho/
cp /usr/share/applications/s2.desktop /etc/skel/Área\ de\ Trabalho/
chmod 777 *.desktop
cd

#removendo e desativando o bluetooth
systemctl disable bluetooth.service
apt-get purge -yq blueman
#definindo papel de parede PAMASP
wget --no-check-certificate --content-disposition https://github.com/leonardogiovani/drc/blob/master/fundo.png -O /usr/share/backgrounds/fundo.png
mv /usr/share/backgrounds/ubuntu-mate-common/Green-Wall-Logo.png /usr/share/backgrounds/ubuntu-mate-common/Green-Wall-Logo-Original.png
cp /usr/share/backgrounds/fundo.png /usr/share/backgrounds/ubuntu-mate-common/fundo.png
cp /usr/share/backgrounds/fundo.png /usr/share/backgrounds/ubuntu-mate-common/Green-Wall-Logo.png
dbus-launch gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/fundo.png
dbus-launch gsettings set org.mate.background picture-filename file:///usr/share/backgrounds/fundo.png
cd


echo " ##########################################"
echo " #  Criando Script de logon - getlogon    #"
echo " ##########################################"
sleep 2
#download e configuranção do getlogon
cp /etc/init.d/getlogon /root/getlogon.$DATA
wget repositorio.pamasp.intraer/logon/getlogon -O /etc/init.d/getlogon
chmod 755 /etc/init.d/getlogon
#inclui getlogon no init.d
update-rc.d getlogon defaults


echo " ##########################################"
echo " #  Instalando pacotes para autenticação  #"
echo " ##########################################"
sleep 2
apt-get install -yq krb5-user krb5-config libpam-krb5 samba samba-common winbind libpam-ccreds libpam-winbind libpam-mount libnss-winbind auth-client-config smbclient python3-smbc


echo " ##########################################"
echo " #  Configurando autenticação no Samba4   #"
echo " ##########################################"
sleep 2
#configurando kerberus
cp /etc/krb5.conf /etc/krb5.conf.$DATA
cat > /etc/krb5.conf << EOF
[libdefaults]
	default_realm	=	CORP.DRCONSULTA.COM

[realms]
	PAMASP.INTRAER	=	{
		kdc	=	104.41.41.126
		kdc	=	104.41.52.149
		master_kdc	=	104.41.41.126
		admin_server	=	104.41.41.126
		default_domain	=	CORP.DRCONSULTA.COM
	}

[domain_realm]
	.corp.drconsulta.com	=	CORP.DRCONSULTA.COM
	corp.drconsulta.com	=	CORP.DRCONSULTA.COM
EOF

#configurando smb.conf
cp /etc/samba/smb.conf /etc/samba/smb.conf.$DATA
cat > /etc/samba/smb.conf << EOF
[global]
security = ADS
workgroup = DRCONSULTA
realm = CORP.DRCONSULTA.COM
log file = /var/log/samba/%m.log
log level = 1
max log size = 1000
idmap config * : backend = tdb
idmap config * : range = 10000-20000
server string = %h - %u - %i (Ubuntu18)
encrypt passwords = yes
dns proxy = no
load printers = no
printcap name = cups
printing = cups
disable spoolss = No
show add printer wizard = yes
winbind enum users = yes
winbind enum groups = yes
winbind use default domain = yes
winbind refresh tickets = yes
winbind offline logon = true
server role = member server
template homedir = /home/%U
template shell = /bin/bash
usershare max shares = 100
usershare owner only = false
client use spnego = yes
client ntlmv2 auth = yes
restrict anonymous = 2
EOF

#configurando nsswitch.conf
cp /etc/nsswitch.conf /etc/nsswitch.conf.$DATA
cat > /etc/nsswitch.conf << EOF
passwd:         compat winbind
group:          compat winbind
shadow:         compat
gshadow:        files

hosts:          files mdns4_minimal dns wins
networks:       files

protocols:      db files
services:       db files
ethers:         db files
rpc:            db files

netgroup:       nis
EOF

#configurando common-account
cp /etc/pam.d/common-account /etc/pam.d/common-account.$DATA
cat > /etc/pam.d/common-account << EOF
account	[success=2 new_authtok_reqd=done default=ignore]	pam_winbind.so
account	[success=1 new_authtok_reqd=done default=ignore]	pam_unix.so
account	requisite	pam_deny.so
account	required	pam_permit.so
account	required	pam_krb5.so minimum_uid=1000
EOF

#configurando common-session
cp /etc/pam.d/common-session /etc/pam.d/common-session.$DATA
cat > /etc/pam.d/common-session << EOF
session	[default=1]	pam_permit.so
session	requisite	pam_deny.so
session	required	pam_permit.so
session	required	pam_unix.so
session	required	pam_mkhomedir.so silent umask=0077 skel=/etc/skel
session	optional	pam_umask.so
session	optional	pam_krb5.so minimum_uid=1000
session	optional	pam_winbind.so
session	optional	pam_mount.so
session	optional	pam_systemd.so
EOF

#configurando lightdm.conf para autenticaçào gráfica
cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.$DATA
cat > /etc/lightdm/lightdm.conf << EOF
[Seat:*]
greeter-session=slick-greeter
greeter-hide-users=true
greeter-show-manual-login=true
user-session=mate
allow-guest=false
EOF

cp /usr/share/lightdm/lightdm.conf.d/50-slick-greeter.conf /usr/share/lightdm/lightdm.conf.d/50-slick-greeter.conf.$DATA
cp /etc/lightdm/lightdm.conf /usr/share/lightdm/lightdm.conf.d/50-slick-greeter.conf

#desabilitando o cache de usuarios
cp /usr/share/glib-2.0/schemas/com.canonical.indicator.session.gschema.xml /usr/share/glib-2.0/schemas/com.canonical.indicator.session.gschema.xml.$DATA
sed -i 's/true/false/g' /usr/share/glib-2.0/schemas/com.canonical.indicator.session.gschema.xml
glib-compile-schemas /usr/share/glib-2.0/schemas/

#restartando serviços
service smbd restart
service nmbd restart
net ads leave -U $ADM_USER
net ads join -U $ADM_USER
service smbd restart
service nmbd restart
service winbind restart



echo " ##########################################"
echo " #  Executando o Script de Logon 1a vez   #"
echo " ##########################################"
sleep 2
/etc/init.d/getlogon start


echo ""
echo " ######################"
echo " #                    #"
echo " #  SCRIPT CONCLUÍDO  #"
echo " #                    #"
echo " ######################"
echo ""

### FONTES:
### https://www.samba.org/samba/docs/man/manpages/smb.conf.5.html
### https://wiki.samba.org/index.php/Troubleshooting_Samba_Domain_Members
### http://almirjr-narede.blogspot.com.br/2015/09/como-ingressar-linux-ubuntu-1504-no-ad.html
### https://www.vivaolinux.com.br/artigo/Ubuntu-1204-autenticando-no-Active-Directory-com-SambaKerberosWinbind?pagina=1
### http://ubuntuforum-br.org/index.php?topic=119716.0
### https://www.vivaolinux.com.br/topico/Redes/Ingressar-estacao-linux-em-samba-server-ubuntu
### https://www.vivaolinux.com.br/topico/vivaolinux/Ingressando-maquina-com-Ubuntu-1604LTS-em-Dominio-com-DC-Windows
### https://wiki.ubuntu.com/LightDM
### http://www.edivaldobrito.com.br/como-instalar-o-adobe-reader-ubuntu-14-04/
### http://www.pdfhacks.com/
### https://askubuntu.com/questions/835886/ubuntu-16-04-1-unity-still-showing-user-list-on-indicator-menu
### https://askubuntu.com/questions/366386/how-do-i-change-the-color-of-the-screen-that-is-displayed-before-the-login-scree
### https://askubuntu.com/questions/797845/how-do-i-change-the-login-screen-in-ubuntu-16-04
### http://cesarakg.freeshell.org/sed-2.html
### http://aurelio.net/sed/sed-HOWTO/
### https://www.freedesktop.org/software/polkit/docs/latest/polkit.8.html
### https://web.mit.edu/kerberos/krb5-1.12/doc/admin/conf_files/krb5_conf.html
### https://www.systutorials.com/docs/linux/man/5-nsswitch.conf/
### http://www.tuxradar.com/content/how-pam-works
### https://support.mozilla.org/en-US/questions/1067995
### http://kb.mozillazine.org/Editing_configuration
### http://kb.mozillazine.org/About:config
### http://kb.mozillazine.org/About_protocol_links


else
	echo "+---------------------------------------------------+"
	echo "|                   ** ATENÇÃO **                   |"
	echo "| DETECTADO SO 32BITS. REINSTALE UMA VERSÃO 64 BITS |"
	echo "+---------------------------------------------------+"
fi
else
	echo "+---------------------------------------------------+"
	echo "|    FAVOR LOGAR COMO ROOT PARA EXECUTAR O SCRIPT   |"
	echo "|    Use: sudo su                                   |"
	echo "+---------------------------------------------------+"
fi
