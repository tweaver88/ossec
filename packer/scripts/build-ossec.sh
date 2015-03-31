#!/bin/bash

cd /tmp

apt-get -q -y install build-essential libssl-dev

echo "Download OSSEC"
curl -o ossec-hids-2.8.1.tar.gz http://www.ossec.net/files/ossec-hids-2.8.1.tar.gz
tar -xzf ossec-hids-2.8.1.tar.gz
cd ossec-hids-2.8.1

cat > etc/preloaded-vars.conf <<ENDL
# preloaded-vars.conf, Daniel B. Cid (dcid @ ossec.net).
#
# Use this file to customize your installations.
# It will make the install.sh script pre-load some
# specific options to make it run automatically
# or with less questions.

# PLEASE NOTE:
# When we use "n" or "y" in here, it should be changed
# to "n" or "y" in the language your are doing the
# installation. For example, in portuguese it would
# be "s" or "n".


# USER_LANGUAGE defines to language to be used.
# It can be "en", "br", "tr", "it", "de" or "pl".
# In case of an invalid language, it will default
# to English "en"
USER_LANGUAGE="en"     # For english
#USER_LANGUAGE="br"     # For portuguese


# If USER_NO_STOP is set to anything, the confirmation
# messages are not going to be asked.
USER_NO_STOP="y"


# USER_INSTALL_TYPE defines the installation type to
# be used during install. It can only be "local",
# "agent" or "server".
#USER_INSTALL_TYPE="local"
USER_INSTALL_TYPE="agent"
#USER_INSTALL_TYPE="server"


# USER_DIR defines the location to install ossec
USER_DIR="/var/ossec"


# If USER_DELETE_DIR is set to "y", the directory
# to install OSSEC will be removed if present.
USER_DELETE_DIR="y"


# If USER_ENABLE_ACTIVE_RESPONSE is set to "n",
# active response will be disabled.
USER_ENABLE_ACTIVE_RESPONSE="n"


# If USER_ENABLE_SYSCHECK is set to "y",
# syscheck will be enabled. Set to "n" to
# disable it.
USER_ENABLE_SYSCHECK="y"


# If USER_ENABLE_ROOTCHECK is set to "y",
# rootcheck will be enabled. Set to "n" to
# disable it.
USER_ENABLE_ROOTCHECK="y"


# If USER_UPDATE is set to anything, the update
# installation will be done.
#USER_UPDATE="y"

# If USER_UPDATE_RULES is set to anything, the
# rules will also be updated.
#USER_UPDATE_RULES="y"

# If USER_BINARYINSTALL is set, the installation
# is not going to compile the code, but use the
# binaries from ./bin/
#USER_BINARYINSTALL="x"


### Agent Installation variables. ###

# Specifies the IP address or hostname of the
# ossec server. Only used on agent installations.
# Choose only one, not both.
USER_AGENT_SERVER_IP="127.0.0.1"
# USER_AGENT_SERVER_NAME


# USER_AGENT_CONFIG_PROFILE specifies the agent's config profile
# name. This is used to create agent.conf configuration profiles
# for this particular profile name. Only used on agent installations.
# Can be any string. E.g. LinuxDBServer or WindowsDomainController
USER_AGENT_CONFIG_PROFILE="generic"



### Server/Local Installation variables. ###

# USER_ENABLE_EMAIL enables or disables email alerting.
#USER_ENABLE_EMAIL="y"

# USER_EMAIL_ADDRESS defines the destination e-mail of the alerts.
#USER_EMAIL_ADDRESS="dcid@test.ossec.net"

# USER_EMAIL_SMTP defines the SMTP server to send the e-mails.
#USER_EMAIL_SMTP="test.ossec.net"


# USER_ENABLE_SYSLOG enables or disables remote syslog.
#USER_ENABLE_SYSLOG="y"


# USER_ENABLE_FIREWALL_RESPONSE enables or disables
# the firewall response.
#USER_ENABLE_FIREWALL_RESPONSE="y"


# Enable PF firewall (OpenBSD, FreeBSD and Darwin only)
#USER_ENABLE_PF="y"


# PF table to use (OpenBSD, FreeBSD and Darwin only).
#USER_PF_TABLE="ossec_fwtable"


# USER_WHITE_LIST is a list of IPs or networks
# that are going to be set to never be blocked.
#USER_WHITE_LIST="192.168.2.1 192.168.1.0/24"


#### exit ? ###
ENDL

echo "Build and install OSSEC"
./install.sh

cat > /var/ossec/etc/ossec.conf <<ENDL
<ossec_config>
  <client>
    <server-ip>10.101.8.99</server-ip>
  </client>

  <syscheck>
    <!-- Frequency that syscheck is executed - default to every 22 hours -->
    <frequency>79200</frequency>
    
    <!-- Directories to check  (perform all possible verifications) -->
    <directories check_all="yes">/etc,/usr/bin,/usr/sbin</directories>
    <directories check_all="yes">/bin,/sbin</directories>

    <!-- Files/directories to ignore -->
    <ignore>/etc/mtab</ignore>
    <ignore>/etc/mnttab</ignore>
    <ignore>/etc/hosts.deny</ignore>
    <ignore>/etc/mail/statistics</ignore>
    <ignore>/etc/random-seed</ignore>
    <ignore>/etc/adjtime</ignore>
    <ignore>/etc/httpd/logs</ignore>
    <ignore>/etc/utmpx</ignore>
    <ignore>/etc/wtmpx</ignore>
    <ignore>/etc/cups/certs</ignore>
    <ignore>/etc/dumpdates</ignore>
    <ignore>/etc/svc/volatile</ignore>

    <!-- Windows files to ignore -->
    <ignore>C:\WINDOWS/System32/LogFiles</ignore>
    <ignore>C:\WINDOWS/Debug</ignore>
    <ignore>C:\WINDOWS/WindowsUpdate.log</ignore>
    <ignore>C:\WINDOWS/iis6.log</ignore>
    <ignore>C:\WINDOWS/system32/wbem/Logs</ignore>
    <ignore>C:\WINDOWS/system32/wbem/Repository</ignore>
    <ignore>C:\WINDOWS/Prefetch</ignore>
    <ignore>C:\WINDOWS/PCHEALTH/HELPCTR/DataColl</ignore>
    <ignore>C:\WINDOWS/SoftwareDistribution</ignore>
    <ignore>C:\WINDOWS/Temp</ignore>
    <ignore>C:\WINDOWS/system32/config</ignore>
    <ignore>C:\WINDOWS/system32/spool</ignore>
    <ignore>C:\WINDOWS/system32/CatRoot</ignore>
  </syscheck>

  <rootcheck>
    <rootkit_files>/var/ossec/etc/shared/rootkit_files.txt</rootkit_files>
    <rootkit_trojans>/var/ossec/etc/shared/rootkit_trojans.txt</rootkit_trojans>
    <system_audit>/var/ossec/etc/shared/system_audit_rcl.txt</system_audit>
    <system_audit>/var/ossec/etc/shared/cis_debian_linux_rcl.txt</system_audit>
    <system_audit>/var/ossec/etc/shared/cis_rhel_linux_rcl.txt</system_audit>
    <system_audit>/var/ossec/etc/shared/cis_rhel5_linux_rcl.txt</system_audit>
  </rootcheck>

  <active-response>
    <disabled>yes</disabled>
  </active-response>

  <!-- Files to monitor (localfiles) -->

  <localfile>
    <log_format>syslog</log_format>
    <location>/var/log/auth.log</location>
  </localfile>

  <localfile>
    <log_format>syslog</log_format>
    <location>/var/log/syslog</location>
  </localfile>

  <localfile>
    <log_format>syslog</log_format>
    <location>/var/log/dpkg.log</location>
  </localfile>

  <localfile>
    <log_format>syslog</log_format>
    <location>/var/log/iptables.log</location>
  </localfile>

  <localfile>
    <log_format>syslog</log_format>
    <location>/var/log/audit/audit.log</location>
  </localfile>

  <localfile>
    <log_format>command</log_format>
    <command>df -h</command>
  </localfile>

  <localfile>
    <log_format>full_command</log_format>
    <command>netstat -tan |grep LISTEN |grep -v 127.0.0.1 | sort</command>
  </localfile>

  <localfile>
    <log_format>full_command</log_format>
    <command>last -n 5</command>
  </localfile>
</ossec_config>
ENDL


echo "

runcmd:
  - [ /bin/bash, /var/ossec/bin/initial-setup.sh ]
" >> /etc/cloud/cloud.cfg

exit 0
