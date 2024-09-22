# Start k8s cluster
minikube start

# Pull the image (from Docker Hub)
kubectl create deployment hello-go --image=tonytech/kube-101-go:latest

# check the pod (more debuging information)
kubectl describe pod -l app=hello-go

# check the pod with less output
kubectl get deployment hello-go

# Expose the image, because it is not visible outside clister
kubectl expose deployment hello-go --port=80 --target-port=8180 --type=NodePort

# check the port
kubectl get service hello-go

# check the minikube ip
minikube ip

# Open browser with `ip:port` from commands output (Working on MacOS)

# For linux open separate terminal and run
minikube service hello-go

# In browser open `http://127.0.0.1:42071`, port may be different.

# To have mode replicas of app you should edit deployment of app
kubectl edit deploymnet hello-go

# change under `spec` replicas (default is 1)

# check the new status
kubectl get deployment hello-go
# output
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
hello-go   3/3     3            3           36m

# Other way to check the new status
kubectl get pods -l app=hello-go
# output
NAME                        READY   STATUS    RESTARTS   AGE
hello-go-77845d7854-9t4hl   1/1     Running   0          37m
hello-go-77845d7854-j479g   1/1     Running   0          2m31s
hello-go-77845d7854-vbn54   1/1     Running   0          2m31s

# check if requests are splited to diferent pods
kubectl logs -f -l app=hello-go --prefix=true

# delete pod. The pod will be deleted, but on its place will be created new one to satisfy setted replicas (in our case 3).
kubectl delete pod hello-go-77845d7854-vbn54

# get the output in YAML
kubectl get service hello-go -o yaml

### Update the app
# 1. Edit the deployment app
# For example if you are using `tonytech/kube-101-go:1.0.0`, just change it to `tonytech/kube-101-go:1.0.1`
kubectl edit deploymnet hello-go

# 2. Change it with command
kubectl set image deployment/hello-go kube-101-go=tonytech/kube-101-go:1.0.1

# Check wath happen with pods (there should be new pods and old should be terminated).
watch kubectl get pods -l app=hello-go

### Roling back Deployment

# check the versions of deploymnet
kubectl rollout history deployment hello-go

# Go back to previous version
kubectl rollout undo deployment hello-go
