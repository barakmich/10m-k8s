# 10 Minute Kubernetes on CoreOS and DigitalOcean Demo

Steps:

### Create a DigitalOcean account and upload your public SSH key.

### Get the scripts
```
git clone https://github.com/coreos/coreos-kubernetes
git clone https://github.com/barakmich/10m-k8s
cp 10m-k8s/*.sh coreos-kubernetes
cd coreos-kubernetes
```

### Launch a controller
Run the first CoreOS node on DO, with private networking turned on and the user data being 
the cloud config at `10m-k8s/single-etcd-cloud-config.yaml`

Copy the IP address. This is your controller node. Let's pretend it's 10.1.1.1

```console
# Create the SSL certs
./generate-ssls.sh 10.1.1.1
# Provision the controller
./provision-controller.sh 10.1.1.1 
```

Kubernetes is now running!

### Configure `kubectl`

Get kubernetes from the [official builds](https://github.com/kubernetes/kubernetes) and copy `kubectl` to your `$PATH`. `kubectl` is under `platforms/<your_platform>/<your_architecture>`. Then run
```console
./setup-kubectl.sh my_cool_cluster_name 10.1.1.1 
```


### Add a worker (or five)
You can add a new worker node (spin one up on DO, no need for a cloud-config) and get it's IP. Suppose it's 10.2.2.2 . Run the following:

```console
./provision-worker 10.2.2.2 10.1.1.1
```

And you're done!
