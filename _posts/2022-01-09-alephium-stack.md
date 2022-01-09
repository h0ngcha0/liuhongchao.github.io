---
layout: post
category: Bitcoin, Google Cloud Platform, GCP, Blockchain
title: Alephium Stack on GKE
---

[Alephium](https://github.com/alephium/alephium) is the first
operational sharded blockchain that brings scalability, ETH-inspired
smart contracts and dApps capabilities to Bitcoin's proven core
technologies while ensuring better performance and improved energy
efficiency.

The project comes with a docker
[setup](https://github.com/alephium/alephium/tree/master/docker) that
helps to run the entire stack, including the [full
node](https://github.com/alephium/alephium), block explorer
([frontend](https://github.com/alephium/explorer/) &
[backend](https://github.com/alephium/explorer-backend)), [GPU
miner](https://github.com/alephium/gpu-miner), as well as monitoring
(prometheus & grafana). This is especially convenient if you want to
experiment with the entire stack on your local machine. For more
details, please consult the
[documentation](https://github.com/alephium/alephium/blob/master/docker/README.md).

It might also be a good idea to run the Alephium full stack on K8S
cluster. Here are some of the benefits that I can think of

- Expose Alephium stack to the public
- Mining with [rented GPUs](https://cloud.google.com/kubernetes-engine/docs/how-to/gpus) in the cloud
- Develop against remote Alephium stack locally
- Run applications that depends on Alephium full node in production
- Scale different components of the Alephium stack depending on your
  use case
- Leverage managed service such as [CloudSQL for
  Postgres](https://www.google.com/search?client=firefox-b-d&q=cloud+postgres+gcp)
- Ease of operation if you are already familiar with K8S

I have setup the alephium stack on GKE, and exposed the following
sites:

- [Alephium Explorer](https://alephium.hongchao.me) (<span class="image-label">alephium.hongchao.me</span>)
- [Alephium Monitoring](https://grafana.hongchao.me/d/S3eJTo3Mk/alephium-overview?orgId=1&refresh=10s) (<span class="image-label">grafana.hongchao.me</span>)
- [Alephium API Documenation](https://alephium.hongchao.me/docs) (<span class="image-label">alephium.hongchao.me/docs</span>)

It's comforting to be able to monitor the status of your full node wherever
you are:

<img src="{{ site.baseurl }}/images/alephium-grafana.png"
alt="Alephium Overview"/>

It is also pretty easy to develop against the remote Alephium locally,
e.g.

{% highlight bash %}
# Port forward alephium from Kubernetes cluster
➜ kubectl port-forward svc/alephium 12973
Forwarding from 127.0.0.1:12973 -> 12973
Forwarding from [::1]:12973 -> 12973

# Curl locally
➜ curl localhost:12973/infos/self-clique
{"cliqueId":"03764042ab3c875481e5eed6d7a59027a7232582c189e1c266f57b62591ae0d8e0","networkId":1,"numZerosAtLeastInHash":18,"nodes":[{"address":"127.0.0.1","restPort":12973,"wsPort":11973,"minerApiPort":10973}],"selfReady":true,"synced":true,"groupNumPerBroker":4,"groups":4}
{% endhighlight %}

The code for setting everything up is open sourced in the
[alephium-stack](https://github.com/h0ngcha0/alephium-stack)
repo. Checkout the
[README.md](https://github.com/h0ngcha0/alephium-stack/blob/master/README.md)
for more details. Alephium is one of those rare gems in the Crypto
space that has solid innovations, high code quality and great mindset
for decentralization. Enjoy and Happy hacking! :fire::fire::fire: