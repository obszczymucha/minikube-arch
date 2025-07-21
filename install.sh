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

install_linkerd() {
  curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/install | sh
  kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml

  linkerd install --crds | kubectl apply -f -
  linkerd install --set proxyInit.runAsRoot=true | kubectl apply -f -
  linkerd viz install | kubectl apply -f -
  linkerd viz check
}

access_viz_dashboard() {
  kubectl get svc -n linkerd-viz web                                                                                                                                  19:48
  kubectl port-forward -n linkerd-viz svc/web 8084:8084                                                                                                               19:48
}

main "$@"

