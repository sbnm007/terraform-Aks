## Using Azure Cloud for implementing and deploying Istio Open Source based Bookinfo Application - Deployment Using Terraform
# terraform-Aks

1) Connect Azure with Service Principle for terraform

docker run -it --rm -v ${PWD}:/work -w /work --entrypoint /bin/sh mcr.microsoft.com/azure-cli:2.6.0

az login

get tenant id
get subscriptionid
az account set --subscription $SUBSCRIPTION


# My default cloud account doesnt support creating service principle

 region = (Europe) North Europe


#The default is marked with an *; the default tenant is 'Trinity College Dublin' and subscription is 'Azure for Students' (c21f04ba-0c38-4dc8-aaab-788f8c1bfee5).


Problem - Authenticating on a server for my freee account



# Installing and Configuring Booking App

1) Download Istio

curl -L https://istio.io/downloadIstio | sh -
cd istio-1.27.2/
istioctl install --set values.defaultRevision=default -y

k get ns
NAME              STATUS   
default           Active   6m33s
istio-system      Active   31s
kube-node-lease   Active   6m33s
kube-public       Active   6m33s
kube-system       Active   6m33s

 k get pods -n istio-system
NAME                                    READY   STATUS    RESTARTS   AGE
istio-ingressgateway-7788cdd66b-v7md9   1/1     Running   0          23s
istiod-5556f78767-zpbp5                 1/1     Running   0          37s


k get svc -n istio-system
NAME                   TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)                                      AGE
istio-ingressgateway   LoadBalancer   10.1.112.99   ###   15021:31223/TCP,80:31743/TCP,443:31823/TCP   33s
istiod                 ClusterIP      10.1.179.21   <none>           15010/TCP,15012/TCP,443/TCP,15014/TCP        47s



kubectl label namespace default istio-injection=enabled
namespace/default labeled

kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
service/details created

kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
gateway.networking.istio.io/bookinfo-gateway created
virtualservice.networking.istio.io/bookinfo created

k get gateway
NAME               AGE
bookinfo-gateway   10s

k get svc
NAME          TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
details       ClusterIP   10.1.7.24      <none>        9080/TCP   62s
kubernetes    ClusterIP   10.1.0.1       <none>        443/TCP    8m19s
productpage   ClusterIP   10.1.181.238   <none>        9080/TCP   61s
ratings       ClusterIP   10.1.141.81    <none>        9080/TCP   62s
reviews       ClusterIP   10.1.81.4      <none>        9080/TCP   62s

k get ns
NAME              STATUS   AGE
default           Active   8m31s
istio-system      Active   2m29s
kube-node-lease   Active   8m31s
kube-public       Active   8m31s
kube-system       Active   8m31s

k get svc -n istio-system
NAME                   TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)                                      AGE
istio-ingressgateway   LoadBalancer   10.1.112.99   ###   15021:31223/TCP,80:31743/TCP,443:31823/TCP   2m25s
istiod                 ClusterIP      10.1.179.21   <none>           15010/TCP,15012/TCP,443/TCP,15014/TCP        2m39s


Now we can access app with external ip which is azure provisioned loadbalancer 



## Networking

External Request → Load Balancer → Pod (10.0.1.10) ← REAL VNet IP
                                     ↑
Pod A (10.0.1.15) → Service (10.1.5.100) → Pod B (10.0.1.20)
    ↑                   ↑                      ↑
  REAL IP           VIRTUAL IP              REAL IP


V-net range = 10.0.0.0/16
Subnet range = 10.0.0.0/24

Service CIDR = 10.1.0.0/16 - for securing and giving range for kubernetes services


Difference in Azure, is that there is no Overlay - networking by default like EKS, or minikube setup. It has feature of direct VNet integration which means that the invidual pods that run gets a subnet ip and the worker nodes get vpc ip.


## Accessing K8s cluster through az cli
az aks get-credentials --resource-group bookinfo-rg --name bookinfo-aks


curl -L https://istio.io/downloadIstio | sh -




## Step by step plan to execute the desired results

1) Create Azure Resources with Terraform code from local machine- Done 
Without Tests
Time taken to create = approx 5 mins
Time taken to destroy = approx 5 mins

2) Deploy Bookinfo Application, Service Mes Istio into the cluster and able to access via HTTP - Done (locally and on AKS) MANUALLY - Done

  a) Access cluster
    - setupp kubeconfig file

  b) Install Istio
    - Download istio on Node where you'll be deploying from
    - Install Istio on AKS
    - Configure the istio ingress gateway so you can publically access (set up loadbalancer)
  
  c) Deploy the bookinfo app
   - Enable Istio injection to defualt namespace
   - deploy microservices with kubectl apply
   
  d) Get Application URL






Approach based on Limitations seen for CICD

1) I will configure an admin server with my azure credentials and authenticate the server with Azure Cloud
2) I will configure that server as a Github Runner and checkout my repo to it in order to deploy infra

Basically I will work on different branch, once I want to deploy my code, I will make a pr to the main branch and I would already have a github worflow setup on this branch which works as a trigger to the main branch and its written as on: pull_request  and you specify there where you will look for changes, in that case u will mention jobs in this repo which basically valides your code post checkout , post that it will do a security scan and run tests 


Configure Github Runner
1) provision linux server on azure
2) configure your creds
3) install agent



CI Pipeline
Trigger on main branch
checks out code
runs tests
run plan

CD will triger when CI completed for dev

# TO Do Store state file to remote backend blob storage with versioning enabled

Manual approve for prod
CD Pipeline



