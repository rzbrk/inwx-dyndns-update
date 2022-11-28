#!/bin/bash

## Read the configuration

source ./dyndns-update.conf

## Start Bash Script

# Get public IP Address
ipv4=$(curl -s "$v4_get_url")
ipv6=$(curl -s "$v6_get_url")

# Get current hostname IP address
host_ipv4=$(dig @$test_dns_server +short -t a $hostname | head -n 1)
host_ipv6=$(dig @$test_dns_server +short -t aaaa $hostname | head -n 1)

date
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

