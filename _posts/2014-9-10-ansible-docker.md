---
layout: post
title: Provision docker using ansible
---

I love [Ansible](http://www.ansible.com/) and
[Docker](http://www.docker.com), they are great two pieces of
software that work pretty nicely together. While there are [ansible
modules](http://docs.ansible.com/docker_module.html) to manage docker
containers, docker images can be built using ansbile as well. We just need
a base images that's ansible enabled:

{% gist liuhongchao/4cc6266212c9304dd116 Dockerfile %}
