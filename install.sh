#!/usr/bin/env bash

main() {
  sudo pacman -S qemu libvirt ebtables dnsmasq bridge-utils openbsd-netcat minikube kubectl dmidecode
  sudo usermod -a -G libvirt "$USER"
  sudo systemctl enable libvirtd.service
  sudo systemctl start libvirtd.service
  local sed_expr="s/YOUR_USERNAME/$USER/g"
  sed "$sed_expr" minikube.service | sudo tee /etc/systemd/system/minikube.service > /dev/null
  sudo systemctl enable minikube.service

  echo "To start, run: sudo systemctl start minikube.service"
}

main "$@"

