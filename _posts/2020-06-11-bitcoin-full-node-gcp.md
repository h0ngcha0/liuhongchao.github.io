---
layout: post
category: Bitcoin, Google Cloud Platform, GCP, Blockchain
title: Bitcoin Full Node on GKE
---

<img src="{{ site.baseurl }}/images/bitcoin-cloud.png"
alt="bitcoin cloud" style="width: 200px;"/>

So finally you decided to exercise your ultimate self sovereignty
within the Bitcoin network by running a full node, but where?

You could run it on a laptop, an [android
phone](https://www.htcexodus.com/), or even a [Respberry
Pi](https://www.raspberrypifullnode.com/). If you think it's too much
work, there are also commercial options such as [Casa Node
2](https://keys.casa/lightning-bitcoin-node/), [Lux
Node](https://luxnode.io/) or [Nodl
One](https://www.nodl.it/nodl-one.html). But wouldn't it be nice if
you can run your personal full node in the cloud where you can access
from anywhere across all your devices? Well, cost is certainly a
concern. For example, [Allnodes](https://www.allnodes.com/host) can
help you to host it for $50 a month and a setup fee of $10, which is
still expensive enough to put off many people.

Wait, isn't [Bitcoin Core](https://github.com/bitcoin/bitcoin)
supposed to be a piece of software that is fault tolerant?
GCP's [Preemptible
VMs](https://cloud.google.com/compute/docs/instances/preemptible)
sounds like a reasonable place to run it with a much [lower
price](https://cloud.google.com/compute/vm-instance-pricing#n1_standard_machine_types)
if you don't mind your node occationally goes offline for a while. 
In fact, a
[n1-standard-1](https://cloud.google.com/compute/docs/machine-types#n1_standard_machine_types)
machine with 1 virtual CPU and 3.75GB memory only costs $7.3 a
month, roughly 30% the cost of its non-preemptible alternative. On top
of that, since Kubernetes has become such a juggernaut in the world of
cloud computing, wouldn't it be nice to declaritively specify how the
Bitcoin full node should be run and let Kubernetes handle the
instability of the cheap machine?

Welcome to use
[bitcoin-gcp-k8s](https://github.com/liuhongchao/bitcoin-gcp-k8s), a
set of [Terraform](https://www.terraform.io/) configurations that help
you to automatically setup a Bitcoin full node on GCP as a Kubernetes
deployment running in a cluster powered by preemptible VMs. Here are
some of the benefits you get:

- Only ~$20 a month
- Access from anywhere, on any device.
- Super easy to setup and config. 15 minutes to get a full node up and
  running.
- Familiar toolings from the Kubernetes world, e.g `kubectl`
- You can run other workload as well, e.g. I run
  [nioctib](https://nioctib.tech) in the same Kubernetes cluster as my Bitcoin
  full node. Great way to build and deploy Bitcoin based applications. 
- Google Cloud Platform offers $300 free credit for new customers,
  meaning almost free for the 1st year! Note that running a full node
  is not mining, therefore it doesn't violate GCP Free Tier's [Terms
  and Conditions](https://cloud.google.com/terms/free-trial).

Following is an example of interacting with the Bitcoin full node after
port-forwarding it from GCP to the local machine.

<img src="{{ site.baseurl }}/images/bitcoind-gcp-interact.png"
alt="interact with bitcoind"/>


More details please take a look at the
[README](https://github.com/liuhongchao/bitcoin-gcp-k8s/blob/master/README.md)
file. Be your own bank and enjoy! :)

