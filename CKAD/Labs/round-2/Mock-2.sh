kubectl run my-webapp --image=nginx --labels=tier=frontend --replicas=2

kubectl expose deployment my-webapp --name=front-end-service --type=NodePort --port=80 --dry-run -o yaml > 1.yaml

kubectl taint node node01 app_type=alpha:NoSchedule

  kubectl label nodes node02 app_type=beta
kubectl run whalesay --image=docker/whalesay  --command "cowsay" "I am going to ace CKAD!" --restart=OnFailure --dry-run -o yaml > 7,yaml

  kubectl run beta-apps --image=nginx --replicas=3 --dry-run -o yaml > 3.yaml

kubectl run multi-pod --image=busybox --command "sleep" "4800" --env=type=moon --restart=Never --dry-run -o yaml > 8.yaml






  5.  Rediness probe
      Need to set the initialDelaySeconds > 180 is required.
      Warning  Unhealthy  1s (x3 over 21s)  kubelet, node03  Readiness probe failed: Get http://10.46.0.5:8080/ready: d

  6. readiness probe
    Warning  Unhealthy  5s (x2 over 65s)  kubelet, node03    Liveness probe failed: ls: cannot access '/var/www/html/