---
layout: post
category: Software, functional programming, Akka, Scala
title: A Game of Ping Pong with Akka
---

Being an Erlang developer for few years, Akka gives me very homey feelings. It
takes direct inspiration from the Erlang/OTP and [Riak Core](https://github.com/basho/riak_core),
and grows into a great library for building concurrent, distrbuted and fault tolerant applications.
On top of its core, modules such as akka streams are developed to serve as a better abstraction for a
class of problems than raw actors. Akka also includes many useful utitilies like Akka HTTP
and Akka Persistence, which can be used to write Rest Api and CQRS systems, respectively.

Few days ago I gave a talk at the [Scala Meetup](http://www.meetup.com/Scala-Geats/)
in Gothenburg introducing Akka along with my colleague Ola and Tobias. My talk was structured as
a code demo that shows how to start from a simple akka actor based rest api which takes a *ping* message
and respond with a *pong* message, and gradually adding fault tolerance, clustering, CQRS, etc to it.

The source code of the demo session can be found [here](https://github.com/liuhongchao/pingpong-with-akka).
It is devided up into the following 5 steps (branches) to facilitate diffing :)

- [00-rest-boilerplates](https://github.com/liuhongchao/pingpong-with-akka/tree/00-rest-boilerplates)
- [01-basic-ping-pong](https://github.com/liuhongchao/pingpong-with-akka/tree/01-basic-ping-pong)
- [02-supervised-ping-pong](https://github.com/liuhongchao/pingpong-with-akka/tree/02-supervised-ping-pong)
- [03-clustered-ping-pong](https://github.com/liuhongchao/pingpong-with-akka/tree/03-clustered-ping-pong)
- [04-persistent-ping-pong](https://github.com/liuhongchao/pingpong-with-akka/tree/04-persistent-ping-pong)
- [05-persistent-view-ping-pong](https://github.com/liuhongchao/pingpong-with-akka/tree/05-persistent-view-ping-pong)

Happy Akka-ing!
