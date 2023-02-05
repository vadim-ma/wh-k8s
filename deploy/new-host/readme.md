```bash
ssh-copy-id k-master1
ssh k-master1
sudo visudo

    %sudo   ALL=(ALL:ALL) ALL
    vadim	ALL=(ALL) NOPASSWD: ALL
```

```bash
sudo apt update
sudo apt upgrade
sudo dpkg-reconfigure locales
    us
    ru
```

# Installing kubeadm
    Unique hostname, MAC address, and product_uuid for every node.
        You can get the MAC address of the network interfaces using the command 
        ```bash
        ip link
        ```
        or
        ```bash
        ifconfig -a
        ```

        The product_uuid can be checked by using the command `sudo cat /sys/class/dmi/id/product_uuid`


    Swap disabled. You MUST disable swap in order for the kubelet to work properly.
    ```bash
    sudo swapoff --all

    sudo vi /etc/fstab

        ##UUID=ed909753-9773-41c5-aaea-bdf2cdcbd9e7 none            swap    sw              0       0
    ```

## Install a container runtime and kubeadm on all the hosts.    
### container runtime
#### containerd
##### Option 2: From apt-get or dnf
```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
```

Install using the repository
```bash
sudo apt-get install \
ca-certificates \
curl \
gnupg \
lsb-release
```
```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```
```bash
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
```
sudo apt-get update
```
```
sudo apt-get install containerd.io
```
the containerd.io package contains runc too, but does not contain CNI plugins. ????

## Configuring the systemd cgroup driver
```bash
sudo mv /etc/containerd/config.toml /etc/containerd/config.toml.bak

sudo bash <<EOF
    containerd config default > /etc/containerd/config.toml
EOF
```

```bash
sudo vi /etc/containerd/config.toml
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
    ...
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
        SystemdCgroup = true                    
```
```bash
sudo systemctl restart containerd
```
## Install and configure prerequisites
```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf > /dev/null
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf > /dev/null
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
```

## Installing kubeadm, kubelet and kubectl 
```
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

sudo apt update
sudo apt install kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```
# Troubleshooting kubeadm
# Creating a cluster with kubeadm
## Initializing your control-plane node
!!!!!!!! ip a
```bash
sudo kubeadm init \
    --control-plane-endpoint wh-k8s \
    --pod-network-cidr 10.1.0.0/16
    # --service-cidr 10.0.0.0/16
```

```
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join wh-k8s:6443 --token itno12.rvcq9sjy6xv2abmn \
        --discovery-token-ca-cert-hash sha256:9082fe0724c103801b53066271457e24e6dc34f15282a7eb53908d854190e228 \
        --control-plane

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join wh-k8s:6443 --token itno12.rvcq9sjy6xv2abmn \
        --discovery-token-ca-cert-hash sha256:9082fe0724c103801b53066271457e24e6dc34f15282a7eb53908d854190e228```
check
```
sudo kubeadm config print init-defaults --component-configs KubeletConfiguration
sudo kubeadm config print join-defaults --component-configs KubeletConfiguration
```
cgroupDriver: systemd

## Installing a Pod network add-on
### Install Calico networking and network policy for on-premises deployments
#### requirements
#### installing
```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/tigera-operator.yaml

curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/custom-resources.yaml -O
vi custom-resources.yaml
  cidr: 10.1.0.0/16

kubectl create -f custom-resources.yaml

rm custom-resources.yaml
```
