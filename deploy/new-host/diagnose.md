https://habr.com/ru/post/540220/

* Теперь, если все указано верно, то Kubeadm развернет K8S на данном узле. Я рекомендую выполнить перезагрузку узла для того, чтобы убедиться что Control Plane стартует как надо. Убедитесь в этом, запросив список выполняемых задач после перезагрузки узла:
```bash
ps xa  | grep -E '(kube-apiserver|etcd|kube-proxy|kube-controller-manager|kube-scheduler)'
```

* config
    sudo kubeadm config print init-defaults --component-configs KubeletConfiguration
    sudo kubeadm config print join-defaults --component-configs KubeletConfiguration
    sudo kubeadm config print init-defaults --component-configs KubeletConfiguration | grep cgroupDriver
        systemd
    kubectl get cm kubeadm-config -n kube-system -o yaml
    kubectl config view
    kubectl config view --flatten
* services
    sudo systemctl status kubelet
* 
    kubectl get no
    kubectl get nodes -o wide
    kubectl get po -A
*
    kubectl get -oyaml -n kube-system po/<pod-name> 

* calico
    kubectl api-resources | grep '\sprojectcalico.org'
    kubectl get tigerastatus apiserver
    kubectl get -ntigera-operator po tigera-operator-54b47459dd-kk4wl
    kubectl logs -ntigera-operator tigera-operator-54b47459dd-kk4wl
        "error":"Could not resolve CalicoNetwork IPPool and kubeadm configuration: IPPool 192.168.0.0/16 is not within the platform's configured pod network CIDR(s) [10.1.0.0/16]"