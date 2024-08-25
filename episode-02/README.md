# Episode 2 - Containers

Outline:

  - Why does Kubernetes use containers?
  - How do you build a container?
  - Build a simple Go app
  - Run the Go app directly
  - Run the Go app in a container
  - Push the Go app to an image registry

## Instructions for 'Hello Go' app

There is a very simple Go-based web app that responds to HTTP requests on port 8180 in [`cmd/hello/hello.go`](cmd/hello/hello.go).

After [installing Go](https://golang.org/doc/install), you can run the app directly with the command:
```go
go run cmd/hello/hello.go
```
Or you can build the Go command `hello` binary using:
```go
go build cmd/hello/hello.go
```
And then run it and monitor requests (access `localhost:8180/some-path-here` in a browser):

```powershell
./hello.exe
# Output
2023/10/24 17:30:36 Starting webserver on :8180
2023/10/24 17:30:59 Received request for path: /some-path-here
```

After you're finished, you can remove the binary with `rm hello`.

## Build the 'Hello Go' Docker container image

Next up, we want to set up a container build environment that can build the Go application and then also run it (but without all the Go language cruft) in a trimmed down container image.

There is a `Dockerfile` in this directory containing a multi-stage Docker build layout which first builds the Go app using the official `golang` Docker image, then builds the final container based on Alpine Linux (using the official `alpine` Docker image).

To build the container, run:
```powwershell
docker build -t tonytech/kube-101-go .
```
Once the container is built, you can see it in your list of `docker images`, and you can run it with the command:
```powershell
docker run --rm -p 8180:8180 tonytech/kube-101-go
```
## Push the container image to a private Docker registry

When you're satisfied the container image works correctly, go ahead and push it up to a Docker registry.

For my example, I'm pushing it to a public Docker Hub repository named `tonytech/kube-101-go`:
```powershell
docker push tonytech/kube-101-go
```

## Build the container inside k8s
To switch to Minikube's Docker environment in PowerShell, you should use the following command:
```powershell
minikube -p minikube docker-env | Invoke-Expression
```

To check all images in k8s:
```powershell
docker images
# Output
REPOSITORY                                TAG        IMAGE ID       CREATED          SIZE
tonytech/kube-101-go                      latest     a2e4eff77171   24 seconds ago   15.2MB
registry.k8s.io/kube-apiserver            v1.30.0    c42f13656d0b   4 months ago     117MB
registry.k8s.io/kube-scheduler            v1.30.0    259c8277fcbb   4 months ago     62MB
registry.k8s.io/kube-controller-manager   v1.30.0    c7aad43836fa   4 months ago     111MB
registry.k8s.io/kube-proxy                v1.30.0    a0bf559e280c   4 months ago     84.7MB
registry.k8s.io/etcd                      3.5.12-0   3861cfcd7c04   6 months ago     149MB
registry.k8s.io/coredns/coredns           v1.11.1    cbb01a7bd410   12 months ago    59.8MB
registry.k8s.io/pause                     3.9        e6f181688397   22 months ago    744kB
gcr.io/k8s-minikube/storage-provisioner   v5         6e38f40d628d   3 years ago      31.5MB
```