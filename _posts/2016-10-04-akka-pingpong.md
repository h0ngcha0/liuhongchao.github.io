---
layout: post
category: Software, functional programming, Akka, Scala
title: A Game of Ping Pong with Akka
---

Being an Erlang developer for few years, [Akka](http://akka.io) gives me very homey feelings. It
takes direct inspiration from the [Erlang/OTP](http://www.erlang.org/) and
[Riak Core](https://github.com/basho/riak_core), and grows into a great library for
building concurrent, distrbuted and fault tolerant applications. On top of its core,
modules such as [Akka streams](http://doc.akka.io/docs/akka/current/scala/stream/index.html) is
developed to serve as a better abstraction for a class of problems over raw actors;
[Akka HTTP](http://doc.akka.io/docs/akka-http/current/scala.html) is written to help build Rest APIs,
[Akka Persistence](http://doc.akka.io/docs/akka/current/scala/persistence.html) is added to facilitate
writing [CQRS](https://en.wikipedia.org/wiki/Command%E2%80%93query_separation) systems, among other things.

Few days ago I gave a talk at the [Scala Meetup](http://www.meetup.com/Scala-Geats/)
in Gothenburg introducing Akka along with my colleague Ola and Tobias. My talk was structured as
a code demo that shows how to start from a simple akka actor based rest api which takes a *ping* message
and respond with a *pong* message, and gradually build up with fault tolerance, clustering, CQRS, etc.

The source code of the demo session can be found [here](https://github.com/liuhongchao/pingpong-with-akka).
It is devided up into the following 5 steps (branches) to facilitate diffing :)

- [00-rest-boilerplates](https://github.com/liuhongchao/pingpong-with-akka/tree/00-rest-boilerplates)
- [01-basic-ping-pong](https://github.com/liuhongchao/pingpong-with-akka/tree/01-basic-ping-pong)
- [02-supervised-ping-pong](https://github.com/liuhongchao/pingpong-with-akka/tree/02-supervised-ping-pong)
- [03-clustered-ping-pong](https://github.com/liuhongchao/pingpong-with-akka/tree/03-clustered-ping-pong)
- [04-persistent-ping-pong](https://github.com/liuhongchao/pingpong-with-akka/tree/04-persistent-ping-pong)
- [05-persistent-view-ping-pong](https://github.com/liuhongchao/pingpong-with-akka/tree/05-persistent-view-ping-pong)

Happy Akka-ing!
