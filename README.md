# Raspberry-Pi-Pi-hole-Unbound-Private-DNS-Server-Setup
* Not tested use at your own risk.
* Update your dns servers once in 6 month.
* Set static ip address while setting up pi-hole.

* Install:
```sh
  git clone --depth 1 https://github.com/ny4rlk0/Raspberry-Pi-Pi-hole-Unbound-Private-DNS-Server-Setup.git nyarlko
  cd "nyarlko/"
  sudo bash pi_hole_and_unbound_setup.sh
 ```
* Update:
```sh
  cd "nyarlko/"
  sudo bash update_dns_server.sh
 ```
* Make sure add your pi ip to your router as only DNS server.
* You can also disable your routers DHCP server and let pi handle it. 
* In that case you should first activate pi-hole's DHCP server then disable the DHCP server in your router.
