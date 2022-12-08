#!/bin/bash

date

## Read the configuration

if [ "$1" != "" ] && [ -r $1 ];
then
        conf=$1
else
        # Possible (ordered) location for configuration files
        conf_check=(./dyndns-update.conf ~/.config/dyndns-update/dyndns-update.conf /usr/local/etc/dyndns-update/dyndns-update.conf /etc/dyndns-update/dyndns-update.conf)

        # If no config file is provided look for config files in the system and
        # pick the first one found:
        for c in "${conf_check[@]}"; do
                if [ -r $c ];
                then
                        conf=$c
                        break
                fi
        done
fi

if [ "$conf" != "" ];
then
	source $conf
	echo " Config: $conf"
else
	echo " Error: No conf file provided/found. Exiting"
	exit 1
fi

## Start Bash Script

# Get public IP Address
ipv4=$(curl -s "$v4_get_url")
ipv6=$(curl -s "$v6_get_url")

# Get current hostname IP address
host_ipv4=$(dig @$test_dns_server +short -t a $hostname | head -n 1)
host_ipv6=$(dig @$test_dns_server +short -t aaaa $hostname | head -n 1)

echo " Current public IPv4: $ipv4"
echo " Current DNS IPv4:    $host_ipv4"
if [ $enable_ipv6 = true -a -n "$ipv6" ]; then
  echo " Current public IPv6: $ipv6"
  echo " Current DNS IPv6:    $host_ipv6"
fi

# Update DynDNS IP if not correct
if [ $enable_ipv6 = true -a -n "$ipv6" ]; then
  if [ "$host_ipv4" != "$ipv4" -o "$host_ipv6" != "$ipv6" ]; then
    echo -n " Updating IPv4 and IPv6 ... ("
    curl --user $username:$password "${dyndns_update_url}myip=${ipv4}&myipv6=${ipv6}"
    echo ")"
  fi
else
  if [ "$host_ipv4" != "$ipv4" ]; then
    echo -n " Updating IPv4 only ... ("
    curl --user $username:$password "${dyndns_update_url}myip=${ipv4}"
    echo ")"
  fi
fi

echo ""

