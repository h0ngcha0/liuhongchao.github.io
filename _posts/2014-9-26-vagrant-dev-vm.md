---
layout: post
tags: Vagrant
category: Software
title: Virtualized Development Environment
---

Yesterday, a burglar sneaked into our office and stole one of my
colleague's Macbook while all of us were having a meeting in a
conference room.

This is annoying. My colleague not only lost her computer but also a
few hour's work of setting it up. This makes me value even more of a
virtualized development environment which is version controlled and can
be reproduced in a matter of minutes. Lately I've been running
virtualbox inside my Macbook managed by
[Vagrant](https://www.vagrantup.com/) and provisioned by
[Ansible](http://www.ansible.com/). In general it has been a very
pleasant experience. [Here](https://github.com/liuhongchao/ansible-dev-vm) is
the code I wrote to set it up.

And the following is screenshot of this very post being written under
my virtualized development environment.

![writing blog in vm]({{ site.baseurl }}/images/vm-writing-blog.png)
