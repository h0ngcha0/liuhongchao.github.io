---
layout: post
category: Programming
title: Typed actors are discouraged in Akka?
---

![Akka mountain]({{ site.baseurl }}/images/gen_server.jpg)

Coming from an Erlang background, I tend to use the gen_server
approach (known as [active object
patten](http://en.wikipedia.org/wiki/Active_object)) when it comes to
implementing a server process (or actor in the Akka world). There are
some benefits with this approach, the most important one being that
the API interfaces can be well defined, which enables type checking,
more maintainable code and better IDE support.

There seem to be something similiar to gen_server in Akka known as [typed
actors](http://doc.akka.io/docs/akka/snapshot/scala/typed-actors.html). Here
is a very simple example:

{% highlight scala linenos=table %}
trait Api {
  def doSomething(): Unit //fire-forget
}

class ApiImpl extends Api {
  def doSomething() = {
    println("doSometing")
  }
}

val api = TypedActor(system).
  typedActorOf(TypedProps(classOf[Api], new ApiImpl()), "Api")

api.doSomething()  // will print "doSomething"

{% endhighlight %}

If we invoke api.doSomething, a message will be sent to a hidden
actor telling it to execute the doSomething function, exactly what
you would expect from a gen_server.

The
[documentation](http://doc.akka.io/docs/akka/snapshot/scala/typed-actors.html)
of typed actor seem to suggest that it should be sparsely used
because it can be abused as RPC, which is known as a leaky
abstraction. There is also a
[discussion]((http://doc.akka.io/docs/akka/snapshot/scala/typed-actors.html))
on stackoverflow where people seem to suggest that the way to fix the
problem that plain Akka actor lacks well defined API is to make better
documentation. I am aware of the fact that typed actor is unable to
perform become/unbecome operations and is less explicit of the fact
that it's an actor (which is the case for gen_server as well, but
doesn't seem to be a problem for developers). I am still not convinced
that the cons of using typed actors outweighs the pros.

I think typed actor should be used more, am I wrong?
