# Raspberry-Pi-Pi-hole-Unbound-Private-DNS-Server-Setup
Not tested use at your own risk. Update your dns servers once in 6 month.
Uses Ethernet with ip of 192.168.1.5 to serve dns/adblock server.
Usage:
sudo chmod +x filename
sudo ./filename
Make sure add your pi ip to your router as only DNS server.
You can also disable your routers dhcp server and let pi handle dhcp. 
In that case you should first activate pi-hole's DHCP server then disable the DHCP server in your router.
