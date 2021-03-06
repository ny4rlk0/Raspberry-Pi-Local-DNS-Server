#!/bin/bash
echo "Installing pi hole..."
sudo git clone --depth 1 https://github.com/pi-hole/pi-hole.git Pi-hole
sudo cd "Pi-hole/automated install/"
sudo bash basic-install.sh
echo "Installing unbound..."
sudo apt-get install unbound
echo "Downloading Internets main root servers ip and writing to file. (/var/lib/unbound/root.hints)"
wget https://www.internic.net/domain/named.root -qO- | sudo tee /var/lib/unbound/root.hints
echo "Giving ownership of root.hints to unbound:unbound"
sudo chown unbound:unbound /var/lib/unbound/root.hints
echo "Writing unbound settings to /etc/unbound/unbound.conf.d/pi-hole.conf"
sudo tee -a /etc/unbound/unbound.conf.d/pi-hole.conf > /dev/null <<EOT
server:
    root-hints: "/var/lib/unbound/root.hints"
    # If no logfile is specified, syslog is used
    # logfile: "/var/log/unbound/unbound.log"
    verbosity: 0

    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes

    # May be set to yes if you have IPv6 connectivity
    do-ip6: no

    # You want to leave this to no unless you have *native* IPv6. With 6to4 and
    # Terredo tunnels your web browser should favor IPv4 for the same reasons
    prefer-ip6: no

    # Use this only when you downloaded the list of primary root servers!
    # If you use the default dns-root-data package, unbound will find it automatically
    #root-hints: "/var/lib/unbound/root.hints"

    # Trust glue only if it is within the server's authority
    harden-glue: yes

    # Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
    harden-dnssec-stripped: yes

    # Don't use Capitalization randomization as it known to cause DNSSEC issues sometimes
    # see https://discourse.pi-hole.net/t/unbound-stubby-or-dnscrypt-proxy/9378 for further details
    use-caps-for-id: no

    # Reduce EDNS reassembly buffer size.
    # Suggested by the unbound man page to reduce fragmentation reassembly problems
    edns-buffer-size: 1472

    # Perform prefetching of close to expired message cache entries
    # This only applies to domains that have been frequently queried
    prefetch: yes

    # One thread should be sufficient, can be increased on beefy machines. In reality for most users running on small networks or on a single machine, it should be unnecessary to seek performance enhancement by increasing num-threads above 1.
    num-threads: 1

    # Ensure kernel buffer is large enough to not lose messages in traffic spikes
    so-rcvbuf: 1m

    # Ensure privacy of local IP ranges
    private-address: 192.168.0.0/16
    private-address: 169.254.0.0/16
    private-address: 172.16.0.0/12
    private-address: 10.0.0.0/8
    private-address: fd00::/8
    private-address: fe80::/10
EOT
echo "Writing custom settings to /etc/dnsmasq.d/05-customadditions.conf"
sudo tee -a /etc/dnsmasq.d/05-customadditions.conf > /dev/null <<EOT
#Uncomment below to add dns server
#You are currently using pi as DNS server.
#server=1.1.1.1 8.8.8.8
min-cache-ttl=3600
domain-needed
bogus-priv
EOT
sudo service dnsmasq restart
sudo service unbound restart
sudo service pihole restart
sudo service dhcpcd restart
echo "Operation Finished!"
echo "Now you need to open web panel (pi ip address) Settings > DNS > remove all other dns servers and tick Custom 1 and write 127.0.0.1#5335 exactly as it is. save and exit."
echo "Now only thing left is remove your dns server in your modem (eg:192.168.1.1) and add ip you set while installing pi-hole."
echo "Do not add any other fallback dns as it will use that if you add."
echo "If it requires 2 just type same addresses again."
echo "This goes without  saying but you should update your dns servers at the least once in six months by running the update_dns_servers script as root."
