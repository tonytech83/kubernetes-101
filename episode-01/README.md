# Episode 1 - Hello, Kubernetes!

Outline:

  - Installing Minikube
  - Running our first app on Kubernetes
  - Where to get help, and where to find community

## Instructions for Minikube

Showed how to use [Minikube](https://minikube.sigs.k8s.io/docs/) and [`kubectl`](https://kubernetes.io/docs/tasks/tools/install-kubectl/) to build local Kubernetes cluster:

  1. Install Minikube: `winget install Kubernetes.minikube` (on a Windows)
  2. Install kubectl: `winget install Kubernetes.kubectl`
  3. Start a Minikube cluster: `minikube start`

Then you can check on the cluster's state, to make sure all the nodes—in this case, just one `master` node—are running and ready:

```powershell
kubectl get nodes
# Output:
NAME       STATUS   ROLES    AGE   VERSION
minikube   Ready    master   91s   v1.19.4
```

Now that we have a running cluster, it's time to deploy a lightweight application to it, just to make sure it's working:

```powershell
kubectl create deployment hello-k8s --image=geerlingguy/kube101:intro
# Output
deployment.apps/hello-k8s created
```

It seems like it's deploying correctly, so the next step is to make it so we can access the deployed application from outside the cluster. By default, Kubernetes sets up an internal network, but does not expose any of your applications to the outside world. Here's how to 'expose' the deployment to the outside using a Kubernetes service:

```powershell
kubectl expose deployment hello-k8s --type=NodePort --port=80
# Output
service/hello-k8s exposed
```

We'll get into what `NodePort` means later, but for now, we should be able to access the deployment from our computer. Minikube has a handy command that will open up the service in a web browser directly:

```powershell
minikube service hello-k8s
# Output
<should launch your web browser>
```

But you could also find the IP address for the cluster using `minikube ip`, then pair that with the high-numbered port that is returned when you run `kubectl get services hello-k8s`.

When you're finished using the cluster, run `minikube halt` to stop it, or `minikube delete` to delete the cluster.

## Building the example Docker image

There is a `Dockerfile` in this directory.

That image is used to demonstrate a simple Kubernetes deployment.

If you want to build the image on your own, locally, you can run:
```powershell
docker build -t tonytech83/kube101:intro .
```
And to run the image on its own, run:
```powershell
docker run -d -p 80:80 tonytech83/kube101:intro
```
Once it's running, you can access the demo page on http://localhost
