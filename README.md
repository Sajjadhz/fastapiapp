## Introduction
This repository include a sample DevOps task in which we are going to install sample python application in different ways by using docker-compose, kubectl command for k8s manifests, helm command for helm chart and using rancher cluster management tool UI. Also we are using Jenkins file to build docker image and push docker image to docker registry.


### Setting up K8s Cluster using LXC/LXD 
> **Note:** For development purpose and not recommended for Production use

#### Installing the LXC on Ubuntu 
```
$ sudo apt-get update && sudo apt-get install lxc -y
$ sudo systemctl status lxc
$ lxd init
```
**Provide default option for all except these:**

Name of the new storage pool [default=default]: local

Name of the storage backend to use (btrfs, ceph, dir, lvm, zfs) [default=zfs]: dir

What should the new bridge be called? [default=lxdbr0]: lxdfan0

What IPv4 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]: 240.235.0.1/24


#### Let's create profile for k8s cluster
Make sure to clone this repo and run these commands moving into lxd-provisioning directory
```
$ lxc profile create k8s
$ cat k8s-profile-config | lxc profile edit k8s
$ lxc profile list
+---------+---------+
|  NAME   | USED BY |
+---------+---------+
| default | 0       |
+---------+---------+
| k8s     | 0       |
+---------+---------+
```

#### It's time to create k8s cluster
```
$ kubelx provision
```

```
$ lxc list
+----------+---------+------------------------+------+-----------+-----------+---------------+
|   NAME   |  STATE  |          IPV4          | IPV6 |   TYPE    | SNAPSHOTS |   LOCATION    |
+----------+---------+------------------------+------+-----------+-----------+---------------+
| kmaster  | RUNNING | 240.235.0.12 (eth0)    |      | CONTAINER | 0         | sajjad-ubuntu |
|          |         | 10.244.0.1 (cni0)      |      |           |           |               |
|          |         | 10.244.0.0 (flannel.1) |      |           |           |               |
+----------+---------+------------------------+------+-----------+-----------+---------------+
| kworker1 | RUNNING | 240.235.0.57 (eth0)    |      | CONTAINER | 0         | sajjad-ubuntu |
|          |         | 10.244.1.1 (cni0)      |      |           |           |               |
|          |         | 10.244.1.0 (flannel.1) |      |           |           |               |
+----------+---------+------------------------+------+-----------+-----------+---------------+
| kworker2 | RUNNING | 240.235.0.243 (eth0)   |      | CONTAINER | 0         | sajjad-ubuntu |
|          |         | 10.244.2.1 (cni0)      |      |           |           |               |
|          |         | 10.244.2.0 (flannel.1) |      |           |           |               |
+----------+---------+------------------------+------+-----------+-----------+---------------+
```

#### Verify
##### Exec into kmaster node
```
$ lxc exec kmaster bash
```
#### Verifying Nodes
```
$ kubectl get nodes
kmaster    Ready    control-plane,master   16d   v1.22.0
kworker1   Ready    <none>                 16d   v1.22.0
kworker2   Ready    <none>                 16d   v1.22.0
```

#### Verifying cluster version
```
$ kubectl cluster-info
Kubernetes control plane is running at https://240.235.0.12:6443
CoreDNS is running at https://240.235.0.12:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

#### Let's deploy sample nginx 
```
$ kubectl create deploy nginx --image nginx
deployment.apps/nginx created

$ kubectl get all
NAME                         READY   STATUS    RESTARTS   AGE
pod/nginx-6799fc88d8-ng7f8   1/1     Running   0          10s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   10m

NAME                    READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx   1/1     1            1           10s

NAME                               DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-6799fc88d8   1         1         1       10s
```

#### Creating Service for deployment nginx
```
$ kubectl expose deploy nginx --port 80 --type NodePort
service/nginx exposed

$ kubectl get service
NAME         TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP   10.96.0.1     <none>        443/TCP        11m
nginx        NodePort    10.96.21.25   <none>        80:30310/TCP   4s
```

#### Exit out from kmaster node
```
$ exit
```
#### Try accessing Nginx through any of the worker node's IP address
```
$ curl -I 240.235.0.243:30310
HTTP/1.1 200 OK
Server: nginx/1.19.3
Date: Mon, 12 Oct 2020 07:56:50 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Tue, 29 Sep 2020 14:12:31 GMT
Connection: keep-alive
ETag: "5f7340cf-264"
Accept-Ranges: bytes
```
##### We can access nginx.. !!!

#### To access k8s cluster without execing into kmaster node

##### Download the kubectl command into your local, I have already present..!
```
$ which kubectl
/usr/bin/kubectl
```
##### Create .kube directory
```
$ mkdir ~/.kube
```
##### copy config from kmaster into .kube directory
```
$ lxc file pull kmaster/etc/kubernetes/admin.conf ~/.kube/config
$ ls -l ~/.kube
total 8
-rw------- 1 root root 5570 Oct 12 08:05 config
```
##### Try to access k8s cluster without execing into kmaster node.
```
$ kubectl get nodes
NAME       STATUS   ROLES                  AGE   VERSION
kmaster    Ready    control-plane,master   16d   v1.22.0
kworker1   Ready    <none>                 16d   v1.22.0
kworker2   Ready    <none>                 16d   v1.22.0
```

### Running app using docker-compose
Move to the directory where docker-compose.yaml belongs.

#### Run docker-compose command
```
$ docker-compose up
[+] Running 1/0
 ⠿ Container fastapiapp-fastapiapp-1  Created                                                                                                                                                         0.0s
Attaching to fastapiapp-fastapiapp-1
fastapiapp-fastapiapp-1  | INFO:     Will watch for changes in these directories: ['/srv']
fastapiapp-fastapiapp-1  | INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
fastapiapp-fastapiapp-1  | INFO:     Started reloader process [1] using StatReload
fastapiapp-fastapiapp-1  | INFO:     Started server process [8]
fastapiapp-fastapiapp-1  | INFO:     Waiting for application startup.
fastapiapp-fastapiapp-1  | INFO:     Application startup complete.
fastapiapp-fastapiapp-1  | INFO:     172.22.0.1:41930 - "GET / HTTP/1.1" 404 Not Found
fastapiapp-fastapiapp-1  | INFO:     172.22.0.1:41930 - "GET /favicon.ico HTTP/1.1" 404 Not Found
```
#### Verify
On your browser go to the http://0.0.0.0:8000/api/v1/checkapi you should see:

```
{
  "message": "Hello World"
}
```
#### Stop and remove the container
Make sure to stop the container.
```
docker-compose down
```

### Deploying app on k8s cluster using kubectl command
In order to deploy the app on k8s cluster first you need to build docker image and push it to your private registry and provide image pull secret for k8s cluster to be able to pull the image and edit k8s manifests for your own docker private registry.

#### Build docker image and push to registry
Replace Your_Docker_Registry with your docker registry name.
```
docker build . -t Your_Docker_Registry/fastapiapp:latest
docker push Your_Docker_Registry/fastapiapp:latest
```
forexample:
```
docker build . -t sajjadhz/fastapiapp:latest
docker push sajjadhz/fastapiapp:latest
```
#### Create k8s secret and provide docker registry credentials as follow
Replace <path/to/.docker/config.json> and give docker config path on your host.
```
kubectl create secret docker-registry regcred --from-file=.dockerconfigjson=<path/to/.docker/config.json>
```
forexample:
```
kubectl create secret docker-registry regcred --from-file=.dockerconfigjson=~/.docker/config.json
```
#### Verify
```
kubectl get secret regcred --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode 
```
#### App deployment
Now edit deployment manifest and replace image registry with your own private registry and run following kubectl commands:

```
kubectl apply -f manifests/deployment-fastapiapp.yaml
kubectl apply -f manifests/service-fastapiapp.yaml
```
#### Verify
```
$ kubeclt get all
pod/fastapiapp-deployment-6d68d7597-5jzl8   1/1     Running     0          2m21s
pod/fastapiapp-deployment-6d68d7597-mswj4   1/1     Running     0          2m21s
pod/fastapiapp-deployment-6d68d7597-s2rbd   1/1     Running     0          2m21s
```

You can also verify your app deployment on your browsert, enter $NODE_IP:30007/api/v1/checkapi forexample http://240.235.0.12:30007/api/v1/checkapi you should see:

```
{
  "message": "Hello World"
}
```

### Installing app by using helmchart
Move to charts directory and edit values and replace image registry with your own private registry and run following command:
#### Get helm template before installing app
You can use helm template command to see what will be deployed on your cluster before installing the app
```
$ helm template fastapiapp ./fastapiapp
```
#### Run helm lint before installing app
You can also use lint command to verify you chart
```
$ helm lint fastapiapp ./fastapiapp/
==> Linting fastapiapp
[INFO] Chart.yaml: icon is recommended

==> Linting ./fastapiapp/
[INFO] Chart.yaml: icon is recommended

2 chart(s) linted, 0 chart(s) failed

```
#### Run helm install with dry-run flag
```
$ helm install fastapiapp ./fastapiapp --dry-run --debug 
```
#### Install app
Now you can install the app
```
$ helm install fastapiapp ./fastapiapp
```

#### Verify
##### Verify by kubectl command
```
$ kubectl get all
pod/fastapiapp-5cd89c79b5-cndq6             1/1     Running     0          6h25m
pod/fastapiapp-5cd89c79b5-ngcwb             1/1     Running     0          6h25m
pod/fastapiapp-5cd89c79b5-z2xg2             1/1     Running     0          6h25m
```
##### Verify on browser
At the end of helm install command helm provides 3 commands to run to get node IP and nodeport as follows:
```
NOTES:
1. Get the application URL by running these commands:
  export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services fastapiapp)
  export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT
```
Run them and at the end you should get something like this: http://240.235.0.12:30007/ go to the http://240.235.0.12:30007/api/v1/checkapi you should see:

```
{
  "message": "Hello World"
}
```

##### Verify by helm test command
Run helm test command as follow, you should see succeeded message:
```
$ helm test fastapiapp
NAME: fastapiapp
LAST DEPLOYED: Fri Aug  4 14:33:48 2023
NAMESPACE: default
STATUS: deployed
REVISION: 3
TEST SUITE:     fastapiapp-test-connection
Last Started:   Fri Aug  4 14:34:00 2023
Last Completed: Fri Aug  4 14:34:06 2023
Phase:          Succeeded

```

and if you run following command you can see status of tes-connection pod as completed is installation steps were OK:

```
$ kubectl get all
NAME                                        READY   STATUS      RESTARTS   AGE
pod/fastapiapp-5cd89c79b5-cndq6             1/1     Running     0          6h25m
pod/fastapiapp-5cd89c79b5-ngcwb             1/1     Running     0          6h25m
pod/fastapiapp-5cd89c79b5-z2xg2             1/1     Running     0          6h25m
pod/fastapiapp-test-connection              0/1     Completed   0          5h4m
```

### To Do Next
- Jenkins-Git configurations
- Jenkins-Docker configurations
- Rancher-Git configurations 
- Rancher installation and configurations
- Jenkins installation and configurations
- Adding stateful app to the cluster
- Backup System (Velero)
- Disaster Recovery
- Adding Ingress
- Adding monitoring (EFK Stack)
- Adding multiple microservices to the cluster and API GW
- Adding configuratin management tool (Ansible)