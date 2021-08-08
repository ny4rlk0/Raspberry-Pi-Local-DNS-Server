#!/bin/bash
wget https://www.internic.net/domain/named.root -qO- | sudo tee /var/lib/unbound/root.hints
sudo chown unbound:unbound /var/lib/unbound/root.hints
sudo service unbound restart
