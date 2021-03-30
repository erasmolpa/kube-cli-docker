# kube-cli-docker
Kubernetes cluster Client with Helm, Kubectl and Helmfile 

# Run

1) Set the Environment variable **KUBECONFIG_PATH** defined in the **.env** with the path of your .kube directory; Eg /Users/you/.kube . 
   This setting is requited to mount a volume.

2) Execute 
    
  ```makefile
 make d-build
```

3) Execute 
  ```makefile
 make d-run
```
